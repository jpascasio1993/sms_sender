package com.flux.smssender.sms_sender

import android.content.Intent
import androidx.annotation.NonNull;
import com.flux.sms_scheduler.SmsSchedulerPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        (flutterEngine!!.plugins.get(SmsSchedulerPlugin::class.java) as SmsSchedulerPlugin).onActivityResult(requestCode, resultCode, data)
    }

    override fun onBackPressed() {
        moveTaskToBack(true)
    }
}
