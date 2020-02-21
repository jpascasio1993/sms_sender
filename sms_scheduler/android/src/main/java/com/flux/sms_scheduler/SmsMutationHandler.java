package com.flux.sms_scheduler;

import android.content.ContentValues;
import android.content.Context;
import android.net.Uri;

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

    public SmsMutationHandler(Context context) {
        this.context = context;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("sms_scheduler.sms_read")) {
                JSONArray smsIds = ((JSONArray) call.arguments);
                Observable.fromCallable(() -> {
                    for(int i=0; i< smsIds.length(); i++) {
                        long id = smsIds.getLong(0);
                        ContentValues values = new ContentValues();
                        values.put("read", true);
                        //context.getContentResolver().update(Uri.parse("content://sms/"),values, "_id="+msgIds.get(i), null);
                        int rowsAffected = context.getContentResolver().update(Uri.parse("content://sms/"), values, "_id=" + id, null);
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
                        result.error(getClass().getSimpleName(), "update sms read status error", null);
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
