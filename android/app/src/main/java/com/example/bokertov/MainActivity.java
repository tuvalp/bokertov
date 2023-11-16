package com.example.bokertov;

import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.net.Uri;
import android.provider.Settings;
import android.app.PendingIntent;
import android.app.AlarmManager;
import android.view.WindowManager;
import android.os.Build;
import android.content.SharedPreferences;
import android.util.Log;
import android.content.Context;
import android.util.AttributeSet;
import android.Manifest;
import android.content.pm.PackageManager;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.app.KeyguardManager;
import android.content.Context;
import android.os.PowerManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;
import android.content.ComponentName;
import androidx.annotation.NonNull;

@TargetApi(Build.VERSION_CODES.ECLAIR)
public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.example.bokertov";
    private static final int PERMISSION_REQUEST_CODE = 1;

    private final Handler handler = new Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FlutterEngine flutterEngine = getFlutterEngine();
        FlutterEngineCache.getInstance().put("bokertov_engine", flutterEngine);

        checkAndRequestPermissions();

        Intent intent = getIntent();
        if (intent.getBooleanExtra("unlockFromNotification", false)) {
            unlockScreen();
        }

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("scheduleAlarm")) {
                                int delay = call.argument("delay");
                                String message = call.argument("message");
                                scheduleAlarm(delay, message);
                            } else if (call.method.equals("cancelAllAlarms")) {
                                cancelAllAlarms();
                            }
                        });

    }

    private void permissionsChack() {

    }

    private final Runnable appLaunchCallback = () -> {
        Log.d("AlarmReceiver", "Handler");

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON |
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED |
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD);

        Intent intent = getIntent();
        String message = intent.getStringExtra("message");

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(),
                CHANNEL)
                .invokeMethod("onAlarmTriggered", "Handler Message");
    };

    private void scheduleAlarm(int delay, String message) {
        Intent intent = new Intent(this, AlarmReceiver.class);
        intent.setAction("com.example.bokertov.ALARM_TRIGGERED");
        intent.putExtra("message", message);

        PendingIntent pendingIntent = PendingIntent.getBroadcast(this, 0, intent,
                PendingIntent.FLAG_IMMUTABLE | PendingIntent.FLAG_UPDATE_CURRENT);

        // Schedule alarm with AlarmManager
        AlarmManager alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);

        if (alarmManager != null) {
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + delay, pendingIntent);
        }

        handler.postDelayed(appLaunchCallback, delay);

    }

    private void cancelAllAlarms() {
        Log.d("ALARM:", "alarm has been canceled");
        AlarmManager alarmManager = (AlarmManager) getSystemService(ALARM_SERVICE);

        Intent intent = new Intent(this, AlarmReceiver.class);
        intent.setAction("com.example.bokertov.ALARM_TRIGGERED");

        PendingIntent pendingIntent = PendingIntent.getBroadcast(
                this,
                0,
                intent,
                PendingIntent.FLAG_IMMUTABLE);

        // Cancel the alarm
        alarmManager.cancel(pendingIntent);

        // Remove the specific callback related to launching the app
        handler.removeCallbacks(appLaunchCallback);
    }

    private void checkAndRequestPermissions() {
        String[] permissions = {
                Manifest.permission.WAKE_LOCK,
                Manifest.permission.DISABLE_KEYGUARD,
                Manifest.permission.SCHEDULE_EXACT_ALARM,
                Manifest.permission.SYSTEM_ALERT_WINDOW,
                Manifest.permission.RECEIVE_BOOT_COMPLETED,
                Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
        };

        if (checkPermissions(permissions)) {
            // Permissions are already granted, proceed with your actions
        } else {
            requestAppPermissions(permissions, PERMISSION_REQUEST_CODE);
        }
    }

    private boolean checkPermissions(String[] permissions) {
        for (String permission : permissions) {
            if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    private void requestAppPermissions(String[] permissions, int requestCode) {
        ActivityCompat.requestPermissions(this, permissions, requestCode);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
            @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION_REQUEST_CODE) {
            // Check if all permissions are granted
            boolean allPermissionsGranted = checkPermissions(permissions);

            if (allPermissionsGranted) {
                // Permissions are granted, proceed with your actions
            } else {
                // Some permissions are denied, handle accordingly
                // You might want to show a message to the user or take some other action
            }
        }
    }

    private void unlockScreen() {
        // Acquire a wake lock to ensure that the device stays awake during this
        // operation
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON |
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED |
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD);

        PowerManager powerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
        PowerManager.WakeLock wakeLock = powerManager.newWakeLock(
                PowerManager.FULL_WAKE_LOCK |
                        PowerManager.ACQUIRE_CAUSES_WAKEUP |
                        PowerManager.ON_AFTER_RELEASE,
                "MyApp:UnlockScreen");

        wakeLock.acquire();

        // Unlock the screen using KeyguardManager
        KeyguardManager keyguardManager = (KeyguardManager) getSystemService(Context.KEYGUARD_SERVICE);
        KeyguardManager.KeyguardLock keyguardLock = keyguardManager.newKeyguardLock("Unlock");
        keyguardLock.disableKeyguard();

        // Release the wake lock
        wakeLock.release();
    }

}
