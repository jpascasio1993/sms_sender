package com.flux.sms_scheduler;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.IBinder;
import android.os.PowerManager;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;

import androidx.core.content.ContextCompat;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.view.FlutterCallbackInformation;
import io.flutter.view.FlutterMain;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterRunArguments;
import io.reactivex.Observable;
import io.reactivex.ObservableSource;
import io.reactivex.Single;
import io.reactivex.SingleEmitter;
import io.reactivex.SingleOnSubscribe;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.functions.Function;
import io.reactivex.subjects.BehaviorSubject;
import io.reactivex.subjects.PublishSubject;

public class SmsService extends Service {
    public static final String TAG = "SmsService";
    private static final String WAKELOCK_TAG = "SmsService:WAKE_LOCK";
    private static final String CALLBACK_HANDLE_KEY = "callback_handle";
    public static final int SERVICE_ID = 1001;
//    public static final String CHANNEL_ID = "sms_scheduler_channel";
    private static final String SHARED_PREFERENCES_KEY = "io.flutter.android_alarm_manager_plugin";
    // static Intent intent;
    private static MethodChannel sBackgroundChannel;

    private static FlutterNativeView sBackgroundFlutterView;
    private static AtomicBoolean sIsIsolateRunning = new AtomicBoolean(false);
    private static PluginRegistrantCallback sPluginRegistrantCallback;
    private static String SMS_SCHEDULER_TASKS_KEY = "SMS_SCHEDULER_TASKS_KEY";
    private static Disposable disposableTask;
    private static BehaviorSubject<JSONObject> tasksBehavior = BehaviorSubject.create();
    private static HashMap<Integer, FunctionReply> functionReplies = new HashMap<>();


    // TODO: add wakelock
    public SmsService() {
    }


    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }


    @Override
    public void onCreate() {
        super.onCreate();
        System.out.println("Service => OnCreate");
        System.out.println("Service => OnCreate => sBackgroundChannel started? " + sIsIsolateRunning.get());
//        Settings.System.putInt(getContentResolver(),
//                Settings.System.WIFI_SLEEP_POLICY,
//                Settings.System.WIFI_SLEEP_POLICY_NEVER);
        acquireWakeLock();
        startForeground(SERVICE_ID, CustomNotification.createNotification(this));
    }


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d("Service", "OnStartCommand");
        System.out.println("Service => OnStartCommand");
        SharedPreferences p = getSharedPreferences(SHARED_PREFERENCES_KEY, 0);
        p.edit().remove(SMS_SCHEDULER_TASKS_KEY).commit();
        invokeCallbackDispatcher2(this);
        destroy();
        long callbackHandle = p.getLong(CALLBACK_HANDLE_KEY, 0);
        startBackgroundIsolate(this,callbackHandle);
//        startForeground(SERVICE_ID, CustomNotification.createNotification(context));
//        return super.onStartCommand(intent, flags, startId);
        return START_STICKY;
    }




    @Override
    public void onDestroy() {
        Log.d("Service", "OnDestroy");
        if (disposableTask != null && !disposableTask.isDisposed())
            disposableTask.dispose();
        stopForeground(true);
        sIsIsolateRunning.set(false);
        //destroy();
        releaseWakeLock();
        super.onDestroy();
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
//        if (disposableTask != null && !disposableTask.isDisposed())
//            disposableTask.dispose();
        //stopForeground(true);
        sIsIsolateRunning.set(false);
        //destroy();
        releaseWakeLock();
        super.onTaskRemoved(rootIntent);


    }

    public void acquireWakeLock() {
        final PowerManager powerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
        releaseWakeLock();
        //Acquire new wake lock
        PowerManager.WakeLock mWakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, WAKELOCK_TAG);
        mWakeLock.setReferenceCounted(false);
        mWakeLock.acquire();
    }
    public void releaseWakeLock() {
        final PowerManager powerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
        PowerManager.WakeLock mWakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, WAKELOCK_TAG);
        if(mWakeLock.isHeld()) {
            mWakeLock.release();
        }
    }

    // Here we start the AlarmService. This method does a few things:
    // - Retrieves the callback information for the handle associated with the
    // callback dispatcher in the Dart portion of the plugin.
    // - Builds the arguments object for running in a new FlutterNativeView.
    // - Enters the isolate owned by the FlutterNativeView at the callback
    // represented by `callbackHandle` and initializes the callback
    // dispatcher.
    // - Registers the FlutterNativeView's PluginRegistry to receive
    // MethodChannel messages.
    public static void startBackgroundIsolate(Context context, long callbackHandle) {

        FlutterMain.ensureInitializationComplete(context, null);
        String mAppBundlePath = FlutterMain.findAppBundlePath();
        FlutterCallbackInformation cb = FlutterCallbackInformation.lookupCallbackInformation(callbackHandle);
        if (cb == null) {
            Log.e(TAG, "Fatal: failed to find callback");
            return;
        }

        // Note that we're passing `true` as the second argument to our
        // FlutterNativeView constructor. This specifies the FlutterNativeView
        // as a background view and does not create a drawing surface.
//        System.out.println("is sBackgroundFlutterView is null? "+(sBackgroundFlutterView == null));
        System.out.println("is sBackgroundFlutterView is null? " + (sBackgroundFlutterView == null));
        System.out.println("sBackgroundChannel started? " + sIsIsolateRunning.get());
        if(sBackgroundFlutterView == null) {
            sBackgroundFlutterView = new FlutterNativeView(context, true);

            // if (!sIsIsolateRunning.get() || (mAppBundlePath != null && !sIsIsolateRunning.get())) {
            // if (!sIsIsolateRunning.get()) {
                Log.i(TAG, "Starting Callback dispatcher...");
                FlutterRunArguments args = new FlutterRunArguments();
                args.bundlePath = mAppBundlePath;
                args.entrypoint = cb.callbackName;
                args.libraryPath = cb.callbackLibraryPath;
                sBackgroundFlutterView.runFromBundle(args);
                sPluginRegistrantCallback.registerWith(sBackgroundFlutterView.getPluginRegistry());
            // }
        }


    }

    private static void invokeCallbackDispatcher2(final Context context) {

        if (disposableTask != null && !disposableTask.isDisposed())
            disposableTask.dispose();
        tasksBehavior = BehaviorSubject.create();
        disposableTask = tasksBehavior.delay(new Function<JSONObject, ObservableSource<JSONObject>>() {
            @Override
            public ObservableSource<JSONObject> apply(JSONObject jsonObject) throws Exception {
                return Observable.just(jsonObject).delay(jsonObject.getLong("delay"), TimeUnit.MILLISECONDS);
            }
        }).observeOn(AndroidSchedulers.mainThread()).flatMap(new Function<JSONObject, ObservableSource<JSONObject>>() {
            @Override
            public ObservableSource<JSONObject> apply(final JSONObject jsonObject) throws Exception {
                return Single.create(new SingleOnSubscribe<JSONObject>() {

                    @Override
                    public void subscribe(final SingleEmitter<JSONObject> emitter) throws Exception {

                        if (sBackgroundChannel == null) {
                            System.out.println("setBackgroundChannel was not called before alarms were scheduled." + " Bailing out.");
                            Log.e(TAG, "setBackgroundChannel was not called before alarms were scheduled." + " Bailing out.");
                            emitter.onSuccess(jsonObject);
                            return;
                        }
                        // Grab the handle for the callback associated with this alarm. Pay close
                        // attention to the type of the callback handle as storing this value in a
                        // variable of the wrong size will cause the callback lookup to fail.
                        long callbackHandle = jsonObject.getLong("callbackHandle");
                        int callbackId = jsonObject.getInt("id");
                        System.out.println("callbackHandle value " + callbackHandle);
                        // Handle the alarm event in Dart. Note that for this plugin, we don't
                        // care about the method name as we simply lookup and invoke the callback
                        // provided.
                        //sBackgroundChannel.invokeMethod("", new Object[]{callbackHandle, callbackId}, new MethodChannel.Result() {
                        sBackgroundChannel.invokeMethod("sms_scheduler.background_tasks", new Object[]{callbackHandle}, new MethodChannel.Result() {
                            @Override
                            public void success(Object o) {
                                System.out.println("invokeMethod success " + o);
                                emitter.onSuccess(jsonObject);
                            }

                            @Override
                            public void error(String errorCode, String errorMessage, Object errorDetails) {
                                System.out.println("invokeMethod error");
                                emitter.tryOnError(new Throwable(errorMessage));
                            }

                            @Override
                            public void notImplemented() {
                                System.out.println("invokeMethod notImplemented");
                                emitter.onSuccess(jsonObject);
                                // emitter.onError(new Exception("notImplemented"));
                            }
                        });
                    }
                }).toObservable();
            }
        }).subscribe();
    }


    public static void setPluginRegistrant(PluginRegistrantCallback callback) {
        sPluginRegistrantCallback = callback;
    }

    public static void setBackgroundChannel(MethodChannel channel) {
        Log.i(TAG, "setBackgroundChannel: ");
        sBackgroundChannel = channel;
    }

    public static void setCallbackDispatcher(Context context, long callbackHandle) {
        SharedPreferences p = context.getSharedPreferences(SHARED_PREFERENCES_KEY, 0);
//        SharedPreferences p = PreferenceManager.getDefaultSharedPreferences(context);
        p.edit().putLong(CALLBACK_HANDLE_KEY, callbackHandle).apply();
    }

    public static void startSmsService(Context context) {
//        intent = new Intent(context, SmsService.class);
//        ContextCompat.startForegroundService(context, intent);
////        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
////            Intent intent = new Intent();
////            String packageName = context.getPackageName();
////            PowerManager pm = (PowerManager) context.getSystemService(POWER_SERVICE);
////            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
////                intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
////                intent.setData(Uri.parse("package:" + packageName));
////                context.startActivity(intent);
////            }
////        }

        Intent restartService = new Intent(context,
                SmsService.class);
        PendingIntent restartServicePI = PendingIntent.getService(
                context, 1, restartService,
                0);

        AlarmManager alarmService = (AlarmManager)context.getSystemService(Context.ALARM_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmService.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,  System.currentTimeMillis() + 1000, restartServicePI);
        }
        else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            alarmService.setExact(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + 1000, restartServicePI);
        }
        else {
            alarmService.set(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + 1000, restartServicePI);
        }
    }

    public static void destroy() {

            if (sBackgroundFlutterView != null && sBackgroundFlutterView.isAttached()) {
                synchronized (sBackgroundFlutterView) {
                    sBackgroundFlutterView.destroy();
                }
            }
    }

    public static void stopSmsService(Context context) {
        Intent serviceIntent = new Intent(context,
                SmsService.class);
        context.stopService(serviceIntent);
    }

    public static void addTask(Context context, JSONArray args) throws JSONException {
        HashMap<String, Object> task = new HashMap<>();
        task.put("id", args.getInt(0));
        task.put("delay", args.getLong(1));
        task.put("callbackHandle", args.getLong(2));
        JSONObject object = new JSONObject(task);
        String key = getTaskKey(Integer.toString((int) task.get("id")));
        SharedPreferences p = context.getSharedPreferences(SHARED_PREFERENCES_KEY, 0);
        Set<String> taskIds = p.getStringSet(SMS_SCHEDULER_TASKS_KEY, new HashSet<String>());

        taskIds.remove(Integer.toString(((int) task.get("id"))));
        taskIds.add(Integer.toString(((int) task.get("id"))));

        p.edit().putString(key, object.toString())
                .putStringSet(SMS_SCHEDULER_TASKS_KEY, taskIds).apply();

        if (tasksBehavior != null)
            tasksBehavior.onNext(object);
    }

    public static boolean setBackgroundFlutterView(FlutterNativeView view) {
        if (sBackgroundFlutterView != null && sBackgroundFlutterView != view) {
            Log.i(TAG, "setBackgroundFlutterView tried to overwrite an existing FlutterNativeView");
            return false;
        }
        sBackgroundFlutterView = view;
        return true;
    }

    public static String getTaskKey(String id) {
        return "sms_scheduler_key_" + id;
    }

    // Called once the Dart isolate (sBackgroundFlutterView) has finished
    // initializing. Processes all alarm events that came in while the isolate
    // was starting.

    public static void onInitialized() {
        Log.i(TAG, "sms_scheduler initialized!");
        sIsIsolateRunning.set(true);
    }

    public static void refreshScheduler(Context context) {
        invokeCallbackDispatcher2(context);
    }

    private static class FunctionReply {
        Disposable disposable;
        PublishSubject<Integer> reply;

        public FunctionReply() {
            reply = PublishSubject.create();
            disposable = reply.subscribe();
        }

        public Disposable getDisposable() {
            return disposable;
        }

        public PublishSubject<Integer> getReply() {
            return reply;
        }
    }


    public static void backgroundReply(int id) {

        if (functionReplies != null || !functionReplies.isEmpty()) {

            functionReplies.get(id).getReply().onNext(id);

        }

    }

    private static void disposeFunctionReplies() {
        if (functionReplies != null)
            for (int i = 0; i < functionReplies.size(); i++) {
                functionReplies.get(i).getDisposable().dispose();
            }
    }
}
