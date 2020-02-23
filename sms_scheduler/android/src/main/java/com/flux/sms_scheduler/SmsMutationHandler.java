package com.flux.sms_scheduler;

import android.content.ContentValues;
import android.content.Context;
import android.net.Uri;
import android.util.Log;

import org.json.JSONArray;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.Scheduler;
import io.reactivex.android.schedulers.AndroidSchedulers;
import io.reactivex.disposables.Disposable;
import io.reactivex.schedulers.Schedulers;

public class SmsMutationHandler implements MethodChannel.MethodCallHandler {

    private Context context;
    private String TAG = "SmsMutationHandler";
    public SmsMutationHandler(Context context) {
        this.context = context;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("sms_scheduler.sms_read")) {

                Observable.fromCallable(() -> {
                    JSONArray smsIds = ((JSONArray) call.arguments).getJSONArray(0);
                    for(int i=0; i< smsIds.length(); i++) {
                        long id = smsIds.getLong(i);
                        ContentValues values = new ContentValues();
                        values.put("read", true);
                        //context.getContentResolver().update(Uri.parse("content://sms/"),values, "_id="+msgIds.get(i), null);
                        int rowsAffected = context.getContentResolver().update(Uri.parse("content://sms/"), values, "_id=" + id, null);
//                        Log.i(getClass().getSimpleName(), "onMethodCall: sms_scheduler.sms_read rowsAffected:: "+rowsAffected);
                    }
                    return true;
                })
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Observer<Boolean>() {
                    @Override
                    public void onSubscribe(Disposable d) {

                    }

                    @Override
                    public void onNext(Boolean aBoolean) {
                        result.success(true);
                    }

                    @Override
                    public void onError(Throwable e) {
//                        Log.i(getClass().getSimpleName(), "onError: "+e.getMessage());
                        result.error(TAG+":: sms_scheduler.sms_read", e.getMessage(), null);
                    }

                    @Override
                    public void onComplete() {

                    }
                });


        } else {
            result.notImplemented();
        }
    }
}
