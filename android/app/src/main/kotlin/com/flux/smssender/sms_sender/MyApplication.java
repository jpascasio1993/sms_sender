package com.flux.smssender.sms_sender;

import com.appleeducate.getversion.GetVersionPlugin;
import com.babariviere.sms.SmsPlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import com.flux.sms_scheduler.SmsSchedulerPlugin;
import com.flux.sms_scheduler.SmsService;
import com.rioapp.demo.imeiplugin.ImeiPlugin;
import com.tekartik.sqflite.SqflitePlugin;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.firebase.core.FirebaseCorePlugin;
import io.flutter.plugins.firebase.database.FirebaseDatabasePlugin;
import io.flutter.plugins.packageinfo.PackageInfoPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;

public class MyApplication  extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {

    @Override
    public void onCreate() {
        super.onCreate();
        SmsService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        SmsSchedulerPlugin.registerWith(registry.registrarFor("com.flux.sms_scheduler.SmsSchedulerPlugin"));
        SharedPreferencesPlugin.registerWith(registry.registrarFor("plugins.flutter.io/shared_preferences"));
        FirebaseCorePlugin.registerWith(registry.registrarFor("plugins.flutter.io/firebase_core"));
        FirebaseDatabasePlugin.registerWith(registry.registrarFor("plugins.flutter.io/firebase_database"));
        GetVersionPlugin.registerWith(registry.registrarFor("com.appleeducate.getversion.GetVersionPlugin"));
        ImeiPlugin.registerWith(registry.registrarFor("com.rioapp.demo.imeiplugin.ImeiPlugin"));
        PackageInfoPlugin.registerWith(registry.registrarFor("plugins.flutter.io/package_info"));
        PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
        SmsPlugin.registerWith(registry.registrarFor("com.babariviere.sms.SmsPlugin"));
        SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    }
}
