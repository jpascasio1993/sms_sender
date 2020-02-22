package com.flux.smssender.sms_sender;

import com.flux.sms_scheduler.SmsSchedulerPlugin;
import com.flux.sms_scheduler.SmsService;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;

public class MyApplication  extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {

    @Override
    public void onCreate() {
        super.onCreate();
        SmsService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        SmsSchedulerPlugin.registerWith(registry.registrarFor("com.flux.sms_scheduler.SmsSchedulerPlugin"));
    }
}
