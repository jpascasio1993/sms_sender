package com.flux.sms_scheduler;

import android.util.Log;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class SmsSchedulerBackgroundHandler implements MethodChannel.MethodCallHandler {

    private PluginRegistry.Registrar registrar;

    public SmsSchedulerBackgroundHandler(PluginRegistry.Registrar registrar) {
        this.registrar = registrar;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.i(getClass().getSimpleName(), "onMethodCall: "+call.method);
        if (call.method.equals("sms_scheduler.initialized")) {
            //SmsService.destroy();
            SmsService.onInitialized();
            result.success(true);
        }
        else if(call.method.equals("sms_scheduler.background_tasks")) {
            result.success(true);
        }
        else {
            result.notImplemented();
        }
    }
}
