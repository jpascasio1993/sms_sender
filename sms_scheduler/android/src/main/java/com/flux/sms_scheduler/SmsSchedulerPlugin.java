package com.flux.sms_scheduler;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.preference.PreferenceManager;
import android.provider.Settings;
import android.provider.Telephony;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import org.json.JSONArray;
import org.json.JSONException;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;


import static androidx.core.app.ActivityCompat.startActivityForResult;

/** SmsSchedulerPlugin */
public class SmsSchedulerPlugin implements FlutterPlugin, MethodCallHandler, PluginRegistry.ViewDestroyListener, ActivityAware, PluginRegistry.ActivityResultListener {

  private Context context;
  private static ActivityPluginBinding activityPluginBinding;
  private SmsSchedulerPluginDelegate delegate;

  public SmsSchedulerPlugin() {
    delegate = new SmsSchedulerPluginDelegate();
  }

  public SmsSchedulerPlugin(Context context) {
    this.context = context;
    delegate = new SmsSchedulerPluginDelegate();
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "plugins.flutter.io/sms_scheduler", JSONMethodCodec.INSTANCE);
    final MethodChannel smsMutationChannel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "plugins.flutter.io/sms_mutation", JSONMethodCodec.INSTANCE);
    channel.setMethodCallHandler(new SmsSchedulerPlugin(flutterPluginBinding.getApplicationContext()));
    smsMutationChannel.setMethodCallHandler(new SmsMutationHandler(flutterPluginBinding.getApplicationContext()));
    Log.i(getClass().getSimpleName(), "onAttachedToEngine: SMSSCHEDULERPLUGIN");
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

  }


  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel backgroundChannel = new MethodChannel(registrar.messenger(), "plugins.flutter.io/sms_scheduler_background",
            JSONMethodCodec.INSTANCE);

    backgroundChannel.setMethodCallHandler(new SmsSchedulerBackgroundHandler(registrar));
    SmsService.setBackgroundChannel(backgroundChannel);

    final MethodChannel channel = new MethodChannel(registrar.messenger(), "plugins.flutter.io/sms_scheduler",
            JSONMethodCodec.INSTANCE);
    channel.setMethodCallHandler(new SmsSchedulerPlugin(registrar.context()));
    // SmsService.setBackgroundChannel(channel);

    final MethodChannel smsMutationChannel = new MethodChannel(registrar.messenger(), "plugins.flutter.io/sms_mutation",
            JSONMethodCodec.INSTANCE);
    smsMutationChannel.setMethodCallHandler(new SmsMutationHandler(registrar.context()));
    //SmsService.setBackgroundChannel(smsMutationChannel);
  }

  @RequiresApi(api = Build.VERSION_CODES.KITKAT)
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
//    if (call.method.equals("getPlatformVersion")) {
//      result.success("Android " + android.os.Build.VERSION.RELEASE);
//    } else {
//      result.notImplemented();
//    }
    String method = call.method;
    Object arguments = call.arguments;
    System.out.println("method::" + method);
    try {
      if (method.equals("getPlatformVersion")) {
        result.success("Android " + Build.VERSION.RELEASE);
      }
//      else if(method.equals("sms_scheduler.initialized")){
//        //SmsService.destroy();
//        SmsService.onInitialized();
//        result.success(true);
//      }
      else if (method.equals("sms_scheduler.start") && !SmsService.isServiceRunning()) {
        delegate.schedulerStart(context, result, arguments);
      } else if (method.equals("sms_scheduler.stop")) {
        delegate.schedulerStop(context, result, arguments);
      }
      else if (method.equals("sms_scheduler.refreshScheduler")) {
        delegate.schedulerRefresh(context, result, arguments);
      }
      else if (method.equals("sms_scheduler.addTask")) {
        delegate.schedulerAddTask(context, result, arguments);
      } else if(method.equals("sms_scheduler.background_reply")){
        delegate.schedulerBackgroundReply(context, result, arguments);
      }
      else if(method.equals("sms_scheduler.request_ignore_battery_optimization")) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
          delegate.requestIgnoreBatteryOptimization(activityPluginBinding.getActivity(), result);
        }
      }
      else if(method.equals("sms_scheduler.rescheduleTask")) {
        delegate.schedulerRescheduleTask(context, result, arguments);
      }
      else if(method.equals("sms_scheduler.defaultApp")) {
        Log.i(getClass().getSimpleName(), "sms_scheduler.defaultApp");
        delegate.setAsDefaultSms(activityPluginBinding.getActivity(), result);
      }
      else {
        result.notImplemented();
      }
    } catch (JSONException e) {
      result.error("error", "JSON error: " + e.getMessage(), null);
    }
  }

  public static Intent getMainActivityIntent(Context context) {
    String packageName = context.getPackageName();
    return context.getPackageManager().getLaunchIntentForPackage(packageName);
  }


  @Override
  public boolean onViewDestroy(FlutterNativeView flutterNativeView) {
    Log.i(getClass().getSimpleName(), "onViewDestroy: flutterNativeView");
    return SmsService.setBackgroundFlutterView(flutterNativeView);
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    activityPluginBinding = binding;
//    FlutterLifecycleAdapter.getActivityLifecycle(binding);
    Log.i(getClass().getSimpleName(), "onAttachedToActivity: ");
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    activityPluginBinding = null;
    delegate.cleanUp();
//    Log.i(getClass().getSimpleName(), "onDetachedFromActivityForConfigChanges: ");
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    activityPluginBinding = binding;
    Log.i(getClass().getSimpleName(), "onReattachedToActivityForConfigChanges: ");
  }

  @Override
  public void onDetachedFromActivity() {
    activityPluginBinding = null;
    delegate.cleanUp();
    Log.i(getClass().getSimpleName(), "onDetachedFromActivity: ");
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    return delegate.onActivityResult(requestCode, resultCode, data);
  }
}
