package com.flux.sms_scheduler;
import android.content.BroadcastReceiver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Telephony;
import android.telephony.SmsMessage;
import android.util.Log;

public class SmsReceiver extends BroadcastReceiver{

    public static final String SMS_BUNDLE = "pdus";

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
            SmsMessage[] msgs = Telephony.Sms.Intents.getMessagesFromIntent(intent);
            String format = intent.getStringExtra("format");

            String phoneNumber = msgs[0].getDisplayOriginatingAddress();
            Long timeDate = System.currentTimeMillis();
            String message = msgs[0].getDisplayMessageBody();


            Log.i("SmsReceiver", "senderNum: "+ phoneNumber + "; message: " + message);

            ContentValues values = new ContentValues();
            values.put("address", phoneNumber);
            values.put("date", timeDate);
            values.put("body", message);
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
