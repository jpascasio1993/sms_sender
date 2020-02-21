package com.flux.sms_scheduler.receivers;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;


/**
 * Created by Flux on 2/5/17.
 */

public abstract class BaseBroadcastReceiver extends BroadcastReceiver {
    private Context mContext;
    protected final String TAG = getClass().getSimpleName();

    @Override
    public void onReceive(Context context, Intent intent) {
        mContext = context;
    }
}