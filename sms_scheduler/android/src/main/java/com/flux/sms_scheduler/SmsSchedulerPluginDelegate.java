package com.flux.sms_scheduler;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.PowerManager;
import android.provider.Settings;
import android.provider.Telephony;
import android.util.Log;

import androidx.annotation.RequiresApi;

import org.json.JSONArray;
import org.json.JSONException;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class SmsSchedulerPluginDelegate implements PluginRegistry.ActivityResultListener {

    private static MethodChannel.Result mResult;
    private int CODE_REQUEST_CHECK_BATTERY = 3930;
    private int CODE_SMS_DEFAULT_APP = 3931;


    void schedulerStart(final Context context,  final MethodChannel.Result result, Object args) throws JSONException {
        if(SmsService.isServiceRunning()) {
            result.success(true);
            return;
        }
        long callbackHandle = ((JSONArray) args).getLong(0);
        SmsService.destroy();

        SmsService.setCallbackDispatcher(context, callbackHandle);
        // SmsService.startBackgroundIsolate(context, callbackHandle);
        SmsService.startSmsService(context);
        result.success(true);
    }

    void schedulerStop(final Context context, final MethodChannel.Result result, Object args) {
        SmsService.stopSmsService(context);
        result.success(true);
    }

    void schedulerRefresh(final Context context, final MethodChannel.Result result, Object args){
        SmsService.refreshScheduler(context);
        result.success(true);
    }

    void schedulerAddTask(final Context context, final MethodChannel.Result result, Object args) throws JSONException {
        SmsService.addTask(context,(JSONArray) args);
        result.success(true);
    }

    void schedulerBackgroundReply(final Context context, MethodChannel.Result result, Object args) throws JSONException {
        SmsService.backgroundReply(((JSONArray) args).getInt(0));
        result.success(true);
    }

    void schedulerRescheduleTask(final Context context, MethodChannel.Result result, Object args) throws JSONException {
        SmsService.rescheduleTask(context,(JSONArray) args);
        result.success(true);
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    void setAsDefaultSms(final Activity activity, final MethodChannel.Result result) {
        mResult = result;
//        Log.i(getClass().getSimpleName(), "setAsDefaultSms: "+Thread.currentThread());
        if(!Telephony.Sms.getDefaultSmsPackage(activity).equals(activity.getPackageName())) {
            Intent intent = new Intent(Telephony.Sms.Intents.ACTION_CHANGE_DEFAULT);
            intent.putExtra(Telephony.Sms.Intents.EXTRA_PACKAGE_NAME, activity.getPackageName());
            activity.startActivityForResult(intent, CODE_SMS_DEFAULT_APP);
        }else {
            result.success(true);
            mResult = null;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
    void requestIgnoreBatteryOptimization(final Activity activity, final MethodChannel.Result result) {
        mResult = result;
        PowerManager pm = (PowerManager) activity.getSystemService(Context.POWER_SERVICE);

        if(!pm.isIgnoringBatteryOptimizations(activity.getPackageName())){
            Intent intent = new Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
            intent.setData(Uri.parse("package:" +
                    activity.getPackageName()));
            activity.startActivityForResult(intent, CODE_REQUEST_CHECK_BATTERY);
        }
        else {
            mResult = null;
            result.success(true);
        }
    }

    void cleanUp() {
        mResult = null;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
//        Log.i(getClass().getSimpleName(), "setAsDefaultSms: "+Thread.currentThread());
        Log.i(getClass().getSimpleName(), "onActivityResult: resultCode:: requestCode "+ resultCode+":: "+requestCode);
//        Log.i(getClass().getSimpleName(), "onActivityResult: mResult:: "+(mResult != null));
//        Log.i(getClass().getSimpleName(), "onActivityResult: "+(resultCode == Activity.RESULT_OK));
        if (requestCode == CODE_REQUEST_CHECK_BATTERY) {
            if(mResult != null) {
                mResult.success((resultCode == Activity.RESULT_OK));
            }
            return true;
        }
        else if(requestCode == CODE_SMS_DEFAULT_APP) {
            if (mResult != null) {
                mResult.success((resultCode == Activity.RESULT_OK));
            }
            return true;
        }
        cleanUp();
        return false;
    }
}
