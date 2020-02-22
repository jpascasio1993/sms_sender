package com.flux.sms_scheduler_example;

import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.provider.Settings;

import androidx.annotation.NonNull;

import com.flux.sms_scheduler.SmsSchedulerPlugin;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

//    Intent myIntent = new Intent();
//    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//      myIntent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
//      myIntent.setData(Uri.parse("package:" +
//              getPackageName()));
//      startActivity(myIntent);
//    }
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    ((SmsSchedulerPlugin)getFlutterEngine().getPlugins().get(SmsSchedulerPlugin.class)).onActivityResult(requestCode, resultCode, data);
  }
}
