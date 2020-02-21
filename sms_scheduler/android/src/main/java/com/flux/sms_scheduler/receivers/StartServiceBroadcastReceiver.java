package com.flux.sms_scheduler.receivers;

import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.flux.sms_scheduler.SmsService;

/**
 * Created by flux on 2/13/17.
 */

public class StartServiceBroadcastReceiver extends BaseBroadcastReceiver
{
    public static final int REQUEST_CODE = 1339;
    
    @Override
    public void onReceive(Context context, Intent intent)
    {
//        //JetpayNotificationService.StartService(context);
//        Intent i= new Intent(context, MainActivity.class);
//        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        context.startActivity(i);
//        Intent i= new Intent(context.getApplicationContext(), Dispatcher.class);
//        context.startService(i);
        Log.w(TAG, "onReceive: BOOT");
        SmsService.startSmsService(context);
    }
}