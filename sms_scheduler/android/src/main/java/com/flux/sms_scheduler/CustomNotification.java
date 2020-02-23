package com.flux.sms_scheduler;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;

import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;

public class CustomNotification {
    private static String channelID = "SMS_SCHEDULER";
    private static String channelName = "SMS_SCHEDULER_CHANNEL";
    static android.app.Notification createNotification(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            channelID = createNotificationChannel(context, channelID, channelName);
        }
        Intent notificationIntent = SmsSchedulerPlugin.getMainActivityIntent(context);
        PendingIntent pendingIntent=PendingIntent.getActivity(context, 0,
                notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        return setupNotificationChannel(context, channelID, pendingIntent);
//        int iconResourceId = context.getResources().getIdentifier("ic_launcher","mipmap",context.getPackageName());
//        return  new NotificationCompat.Builder(context,SmsService.CHANNEL_ID)
//                .setSmallIcon(iconResourceId)
//                .setOngoing(true)
//                .setContentTitle("SMS Scheduler")
//                .setContentText("SMS Scheduler has started")
//                .setContentIntent(pendingIntent)
//                .setPriority(NotificationCompat.PRIORITY_HIGH).build();
    }

    private static Notification setupNotificationChannel(Context context, String channelID,  PendingIntent notificationIntent){
//        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
//            NotificationChannel serviceChannel = new NotificationChannel(
//                    SmsService.CHANNEL_ID,
//                    "Sms Scheduler",
//                    NotificationManager.IMPORTANCE_DEFAULT
//            );
//
//            NotificationManager notificationManager =
//                    (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
//            if (notificationManager != null)
//            {
//                notificationManager.createNotificationChannel(serviceChannel);
//            }
//        }q
        // int iconResourceId = context.getResources().getIdentifier("ic_launcher","mipmap",context.getPackageName());
        Notification mNotification =
                new NotificationCompat.Builder(context, channelID)
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setContentTitle("SMS Scheduler")
                        .setContentText("SMS Scheduler has started")
                        .setOngoing(true)
                        .setContentIntent(notificationIntent)
                        .setPriority(NotificationCompat.PRIORITY_HIGH)
                        .build();
        mNotification.flags |= Notification.FLAG_NO_CLEAR;
        return mNotification;
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private static String createNotificationChannel(Context context, String channelID, String channelName){
        NotificationChannel chan = new NotificationChannel(channelID,
                channelName, NotificationManager.IMPORTANCE_HIGH);
        chan.setLightColor(Color.BLUE);
        chan.setLockscreenVisibility( Notification.VISIBILITY_PRIVATE);
        NotificationManager service = (NotificationManager)context.getSystemService(Context.NOTIFICATION_SERVICE);
        service.createNotificationChannel(chan);
        return channelID;
    }
}