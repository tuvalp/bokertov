package com.example.bokertov;

import static android.view.WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.PowerManager;
import android.util.Log;
import android.app.KeyguardManager;
import android.view.WindowManager;
import android.os.Build;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;

import io.flutter.plugin.common.MethodChannel;

public class AlarmReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        FlutterEngine flutterEngine = new FlutterEngine(context);
        flutterEngine.getDartExecutor().executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()

        );
        if ("com.example.bokertov.ALARM_TRIGGERED".equals(intent.getAction())) {

            flutterEngine.getNavigationChannel().setInitialRoute("/alarm-ring");
            FlutterEngineCache.getInstance().put("bokertov_engine", flutterEngine);

            Log.d("AlarmReceiver", "Alarm Received from Reciver");

            Intent launchIntent = new Intent(context, MainActivity.class);

            if (launchIntent != null) {
                launchIntent.setAction(Intent.ACTION_RUN);
                launchIntent.putExtra("route", "/alarm-ring");

                // Add appropriate flags to the launchIntent
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK |
                        Intent.FLAG_ACTIVITY_CLEAR_TOP |
                        Intent.FLAG_ACTIVITY_SINGLE_TOP |
                        Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT |
                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED |
                        WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD);

                // Start the activity
                context.startActivity(launchIntent);
                Log.d("AlarmReceiver", "App launched");

                // Acquire a wake lock to ensure that the device stays awake during this
                // operation

                PowerManager powerManager = (PowerManager) context.getSystemService(Context.POWER_SERVICE);
                PowerManager.WakeLock wakeLock = powerManager.newWakeLock(
                        PowerManager.FULL_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP
                                | PowerManager.ON_AFTER_RELEASE,
                        "MyApp:AlarmReceiver");
                wakeLock.acquire();

                // Unlock the screen
                KeyguardManager keyguardManager = (KeyguardManager) context.getSystemService(Context.KEYGUARD_SERVICE);
                KeyguardManager.KeyguardLock keyguardLock = keyguardManager.newKeyguardLock("Unlock");
                keyguardLock.disableKeyguard();

                // Release the wake lock
                wakeLock.release();
            } else {
                Log.d("AlarmReceiver", "Launch Intent is null");
            }
        }

    }

}
