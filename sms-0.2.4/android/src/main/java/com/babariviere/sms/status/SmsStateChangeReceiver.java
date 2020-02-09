package com.babariviere.sms.status;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.telephony.SmsManager;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.plugin.common.EventChannel;

/**
 * Created by Joan Pablo on 4/17/2018.
 */

public class SmsStateChangeReceiver extends BroadcastReceiver {
    private EventChannel.EventSink eventSink;
    private int msgParts = -1;
    private int sentId = -1;

    public SmsStateChangeReceiver(EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            if (sentId != intent.getIntExtra("sentId", -1)) {
                sentId = intent.getIntExtra("sentId", -1);
                msgParts = intent.getIntExtra("msgParts", -1);
            }
            JSONObject stateChange = new JSONObject();
            stateChange.put("sentId", sentId);

            // int msgParts = intent.getIntExtra("msgParts",-1);

            String action = intent.getAction();
            boolean anyError = false;
            switch (action != null ? action : "none") {
            case "SMS_SENT": {
                // if (getResultCode() != Activity.RESULT_OK) {
                // anyError = true
                // stateChange.put("state", "fail");
                // } else {
                // stateChange.put("state", "sent");
                // }
                if (getResultCode() == Activity.RESULT_OK) {
                    stateChange.put("state", "sent");
                } else {
                    anyError = true;
                }
                Log.d("flutter_sms", "Sent result: " + sentResult(getResultCode()));
                Log.d("flutter_sms_sentId", String.valueOf(intent.getIntExtra("sentId", -1)));
                break;
            }
            case "SMS_DELIVERED": {
                stateChange.put("state", "delivered");
                break;
            }
            default: {
                stateChange.put("state", "none");
            }
            }

            msgParts--;
            Log.d("msgParts", String.valueOf(msgParts));
            if (msgParts <= 0) {
                if (anyError) {
                    stateChange.put("state", "fail");
                }
                // context.unregisterReceiver(this);
                eventSink.success(stateChange);
            }

        } catch (JSONException e) {
            e.printStackTrace();
            eventSink.error("#01", e.getMessage(), null);
        }
    }

    String sentResult(int resultCode) {
        switch (resultCode) {
        case Activity.RESULT_OK:
            return "Activity.RESULT_OK";
        case SmsManager.RESULT_ERROR_GENERIC_FAILURE:
            return "SmsManager.RESULT_ERROR_GENERIC_FAILURE";
        case SmsManager.RESULT_ERROR_RADIO_OFF:
            return "SmsManager.RESULT_ERROR_RADIO_OFF";
        case SmsManager.RESULT_ERROR_NULL_PDU:
            return "SmsManager.RESULT_ERROR_NULL_PDU";
        case SmsManager.RESULT_ERROR_NO_SERVICE:
            return "SmsManager.RESULT_ERROR_NO_SERVICE";
        default:
            return "Unknown error code";
        }
    }
}
