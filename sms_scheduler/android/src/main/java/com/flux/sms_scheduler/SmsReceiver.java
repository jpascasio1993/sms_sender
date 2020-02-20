package com.flux.sms_scheduler;
import android.annotation.TargetApi;
import android.content.BroadcastReceiver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Telephony;
import android.telephony.SmsMessage;
import android.util.Log;

import java.util.Date;

public class SmsReceiver extends BroadcastReceiver{

    public static final String SMS_BUNDLE = "pdus";


    @TargetApi(Build.VERSION_CODES.KITKAT)
    private SmsMessage[] readMessages(Intent intent) {
        return Telephony.Sms.Intents.getMessagesFromIntent(intent);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        // TODO Auto-generated method stub
        try{
//            if(!MyApplication.getInstance().isMyServiceRunning(SMSDispatcher.class))
//            {
//                Intent i= new Intent(context, SMSDispatcher.class);
//                i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                context.startService(i);
//            }
            SmsMessage[] msgs = readMessages(intent);


            String phoneNumber = msgs[0].getDisplayOriginatingAddress();
            Long timeDate = (new Date()).getTime();
            // String body = msgs[0].getDisplayMessageBody();
            String body = "";
            for (SmsMessage msg : msgs) {
                body = body.concat(msg.getMessageBody());
            }

            Log.i("SmsReceiver", "senderNum: "+ phoneNumber + "; message: " + body);

            ContentValues values = new ContentValues();
            values.put("address", phoneNumber);
            values.put("date", timeDate);
            values.put("body", body);
            values.put("type", 1);
            values.put("read", 0);
            Uri mUri = context.getContentResolver().insert(Uri.parse("content://sms"), values);
        }catch (Exception e)
        {
            e.printStackTrace();
        }

//        Bundle intentExtras = intent.getExtras();
//
//        if (intentExtras != null) {
//            Object[] sms = (Object[]) intentExtras.get(SMS_BUNDLE);
//            String smsMessageStr = "";
//            for (int i = 0; i < sms.length; ++i) {
//                String format = intentExtras.getString("format");
//                SmsMessage smsMessage = SmsMessage.createFromPdu((byte[]) sms[i], format);
//
//                String smsBody = smsMessage.getMessageBody().toString();
//                String address = smsMessage.getOriginatingAddress();
//
//                smsMessageStr += "SMS From: " + address + "\n";
//                smsMessageStr += smsBody + "\n";
//            }
//
//            MainActivity inst = MainActivity.instance();
//            inst.updateInbox(smsMessageStr);
//        }
    }

}
