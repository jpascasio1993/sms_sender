package com.flux.sms_scheduler;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.core.app.NotificationCompat;

public class Notification {
    static android.app.Notification createNotification(Context context) {
        setupNotificationChannel(context);
        Intent notificationIntent = SmsSchedulerPlugin.getMainActivityIntent(context);
        PendingIntent pendingIntent=PendingIntent.getActivity(context, 0,
                notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        int iconResourceId = context.getResources().getIdentifier("ic_launcher","mipmap",context.getPackageName());
        return  new NotificationCompat.Builder(context,SmsService.CHANNEL_ID)
                .setSmallIcon(iconResourceId)
                .setOngoing(true)
                .setContentTitle("SMS Scheduler")
                .setContentText("SMS Scheduler has started")
                .setContentIntent(pendingIntent)
                .setPriority(NotificationCompat.PRIORITY_HIGH).build();
    }

    public static void setupNotificationChannel(Context context){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationChannel serviceChannel = new NotificationChannel(
                    SmsService.CHANNEL_ID,
                    "Sms Scheduler",
                    NotificationManager.IMPORTANCE_DEFAULT
            );

            NotificationManager notificationManager =
                    (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            if (notificationManager != null)
            {
                notificationManager.createNotificationChannel(serviceChannel);
            }
        }
    }
}


