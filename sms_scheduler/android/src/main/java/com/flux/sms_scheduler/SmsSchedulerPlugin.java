package com.flux.sms_scheduler;

import android.content.Context;
import android.content.Intent;

import org.json.JSONArray;
import org.json.JSONException;

import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;
import android.util.Log;
/**
 * SmsSchedulerPlugin
 */
public class SmsSchedulerPlugin implements MethodCallHandler, PluginRegistry.ViewDestroyListener
{
    /**
     * Plugin registration.
     */
    private Registrar registrar;

    public static void registerWith(Registrar registrar) {
//        RxJavaPlugins.setErrorHandler(new Consumer<Throwable>() {
//            @Override
//            public void accept(Throwable throwable) throws Exception {
//                System.out.println("[global error] "+throwable.getMessage());
//            }
//        });
        System.out.println("registerWith!!!!!!!!");
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.flutter.io/sms_scheduler",
                JSONMethodCodec.INSTANCE);
        final MethodChannel backgroundChannel = new MethodChannel(registrar.messenger(), "plugins.flutter.io/sms_scheduler_background",
                JSONMethodCodec.INSTANCE);
        SmsSchedulerPlugin smsScheduler = new SmsSchedulerPlugin(registrar);
        channel.setMethodCallHandler(smsScheduler);
        backgroundChannel.setMethodCallHandler(smsScheduler);
        SmsService.setBackgroundChannel(backgroundChannel);
        registrar.addViewDestroyListener(smsScheduler);
    }

    private SmsSchedulerPlugin(Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        String method = call.method;
        Object arguments = call.arguments;
         System.out.println("method::" + method);
        try {
            if (method.equals("getPlatformVersion")) {
                result.success("Android " + android.os.Build.VERSION.RELEASE);
            } else if(method.equals("sms_scheduler.initialized")){
                //SmsService.destroy();
                SmsService.onInitialized();
                result.success(true);
            }
            else if (method.equals("sms_scheduler.start")) {
                long callbackHandle = ((JSONArray) arguments).getLong(0);
                SmsService.destroy();
                SmsService.setCallbackDispatcher(this.registrar.context(), callbackHandle);
                SmsService.startBackgroundIsolate(this.registrar.context(), callbackHandle);
                SmsService.startSmsService(this.registrar.context());
                result.success(true);
            } else if (method.equals("sms_scheduler.stop")) {
                SmsService.stopSmsService(this.registrar.context());
                result.success(true);
            }
            else if (method.equals("sms_scheduler.apply")) {
                SmsService.refreshScheduler(this.registrar.context());
                result.success(true);
            }
            else if (method.equals("sms_scheduler.addTask")) {
                SmsService.addTask(this.registrar.context(),(JSONArray) arguments);
                result.success(true);
            } else if(method.equals("sms_scheduler.background_reply")){
                SmsService.backgroundReply(((JSONArray) arguments).getInt(0));
                result.success(true);
            }
            else {
              
                result.notImplemented();
            }
        } catch (JSONException e) {
            result.error("error", "JSON error: " + e.getMessage(), null);
        }

    }

    public static Class getMainActivityClass(Context context) {
        String packageName = context.getPackageName();
        Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage(packageName);
        String className = launchIntent.getComponent().getClassName();
        try {
            return Class.forName(className);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static Intent getMainActivityIntent(Context context) {
        String packageName = context.getPackageName();
        return context.getPackageManager().getLaunchIntentForPackage(packageName);
    }

    @Override
    public boolean onViewDestroy(FlutterNativeView flutterNativeView)
    {
        return SmsService.setBackgroundFlutterView(flutterNativeView);
        //return true;
    }
}
