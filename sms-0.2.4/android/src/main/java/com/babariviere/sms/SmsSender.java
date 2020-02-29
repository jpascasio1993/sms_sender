package com.babariviere.sms;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.telephony.SmsManager;
import android.util.Log;

import com.babariviere.sms.permisions.Permissions;

import java.util.ArrayList;
import java.util.UUID;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

import static io.flutter.plugin.common.PluginRegistry.Registrar;
import static io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener;

/**
 * Created by babariviere on 08/03/18.
 */

@TargetApi(Build.VERSION_CODES.DONUT)
class SmsSenderMethodHandler implements RequestPermissionsResultListener {
    private static final SmsManager sms = SmsManager.getDefault();
    private final String[] permissionsList = new String[] { Manifest.permission.SEND_SMS,
            Manifest.permission.READ_PHONE_STATE };
    private MethodChannel.Result result;
    private String address;
    private String body;
    private int sentId;
    private Integer subId;
    private final Registrar registrar;

    SmsSenderMethodHandler(Registrar registrar, MethodChannel.Result result, String address, String body, int sentId,
            Integer subId) {
        this.registrar = registrar;
        this.result = result;
        this.address = address;
        this.body = body;
        this.sentId = sentId;
        this.subId = subId;
    }

    void handle(Permissions permissions) {
        // if (permissions.checkAndRequestPermission(permissionsList,
        // Permissions.SEND_SMS_ID_REQ)) {
        sendSmsMessage();
        // }
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode != Permissions.SEND_SMS_ID_REQ) {
            return false;
        }
        boolean isOk = true;
        for (int res : grantResults) {
            if (res != PackageManager.PERMISSION_GRANTED) {
                isOk = false;
                break;
            }
        }
        if (isOk) {
            sendSmsMessage();
            return true;
        }
        result.error("#01", "permission denied for sending sms", null);
        return false;
    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    private void sendSmsMessage() {
        Intent sentIntent = new Intent("SMS_SENT");
        sentIntent.putExtra("sentId", sentId);
        PendingIntent sentPendingIntent = PendingIntent.getBroadcast(registrar.context(), 0, sentIntent,
                PendingIntent.FLAG_UPDATE_CURRENT);

        Intent deliveredIntent = new Intent("SMS_DELIVERED");
        deliveredIntent.putExtra("sentId", sentId);
        PendingIntent deliveredPendingIntent = PendingIntent.getBroadcast(registrar.context(),
                UUID.randomUUID().hashCode(), deliveredIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        SmsManager sms;
        Log.i(getClass().getSimpleName(), "sendSmsMessage: subId"+subId);
//        Log.i(getClass().getSimpleName(), "sendSmsMessage: address"+ address);
//        try {
//            Log.i(getClass().getSimpleName(), "sendSmsMessage: SMS_OUTGOING_CHECK_MAX_COUNT "+Settings.Global.getInt(registrar.context().getContentResolver(), "SMS_OUTGOING_CHECK_MAX_COUNT".toLowerCase()));
//            Log.i(getClass().getSimpleName(), "sendSmsMessage: SMS_OUTGOING_CHECK_INTERVAL_MS "+Settings.Global.getInt(registrar.context().getContentResolver(), "SMS_OUTGOING_CHECK_INTERVAL_MS".toLowerCase()));
//        }catch(Exception exp) {
//            Log.i(getClass().getSimpleName(), "sendSmsMessage: exp "+exp.getMessage());
//        }
//        Log.i(getClass().getSimpleName(), "sendSmsMessage: body: "+body);
        if (this.subId == null) {
            sms = SmsManager.getDefault();
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                sms = SmsManager.getSmsManagerForSubscriptionId(this.subId);
            } else {
                result.error("#03", "this version of android does not support multicard SIM", null);
                return;
            }
        }
        ArrayList<String> msgParts = sms.divideMessage(body);
        if(msgParts.size() == 1)
            sms.sendTextMessage(address, null, body, sentPendingIntent, deliveredPendingIntent);
        else {
            sentIntent.putExtra("msgParts",msgParts.size());
             ArrayList<PendingIntent> pendingIntents = new ArrayList<PendingIntent>(msgParts.size());
             for (int i = 0; i < msgParts.size(); i++) {
                pendingIntents.add(PendingIntent.getBroadcast(registrar.context(), 0, sentIntent, PendingIntent.FLAG_UPDATE_CURRENT));
            }
            sms.sendMultipartTextMessage(address, null, msgParts, pendingIntents, null);
        }
        result.success(null);
    }
}

@TargetApi(Build.VERSION_CODES.DONUT)
class SmsSender implements MethodCallHandler {
    private final Registrar registrar;
    private final Permissions permissions;

    SmsSender(Registrar registrar) {
        this.registrar = registrar;
        permissions = new Permissions(registrar.activity());
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("sendSMS")) {
            String address = call.argument("address").toString();
            String body = call.argument("body").toString();
            int sentId = call.argument("sentId");
            Integer subId = call.argument("subId");
            if (address == null) {
                result.error("#02", "missing argument 'address'", null);
            } else if (body == null) {
                result.error("#02", "missing argument 'body'", null);
            } else {
                SmsSenderMethodHandler handler = new SmsSenderMethodHandler(registrar, result, address, body, sentId,
                        subId);
                this.registrar.addRequestPermissionsResultListener(handler);
                handler.handle(this.permissions);
            }
        } else {
            result.notImplemented();
        }
    }
}
