package com.example.bokertov;

import static android.view.WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.PowerManager;
import android.util.Log;
import android.app.KeyguardManager;
import android.view.WindowManager;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import androidx.core.app.NotificationCompat;

import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.Locale;

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

            Log.d("AlarmReceiver", "Alarm Received from Receiver");

            String message = intent.getStringExtra("message");

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

                // Check if the screen is locked
                KeyguardManager keyguardManager = (KeyguardManager) context.getSystemService(Context.KEYGUARD_SERVICE);
                boolean isScreenLocked = keyguardManager.inKeyguardRestrictedInputMode();

                // Screen is not locked, successfully unlocked
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
                keyguardManager = (KeyguardManager) context.getSystemService(Context.KEYGUARD_SERVICE);
                KeyguardManager.KeyguardLock keyguardLock = keyguardManager.newKeyguardLock("Unlock");
                keyguardLock.disableKeyguard();

                // Release the wake lock
                wakeLock.release();

                // Send the message to the Flutter side using the method channel
                new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "com.example.bokertov")
                        .invokeMethod("onAlarmTriggered", "Rciver Message");

                if (isScreenLocked) {
                    // Screen is locked, show notification
                    showUnlockNotification(context, message);
                }
            } else {
                Log.d("AlarmReceiver", "Launch Intent is null");
            }
        }
    }

    private void showUnlockNotification(Context context, String message) {
        // Create a notification channel with high importance
        NotificationChannel channel = new NotificationChannel("channel_id", "Channel Name",
                NotificationManager.IMPORTANCE_HIGH);

        // Get the NotificationManager and create the channel
        NotificationManager notificationManager = (NotificationManager) context
                .getSystemService(Context.NOTIFICATION_SERVICE);
        notificationManager.createNotificationChannel(channel);

        // Prepare notification content intent to unlock the screen
        Intent unlockIntent = new Intent(context, MainActivity.class);
        unlockIntent.setAction("com.example.bokertov.ALARM_TRIGGERED");
        unlockIntent.putExtra("message", message);
        unlockIntent.putExtra("unlockFromNotification", true);

        // Change to the appropriate activity
        PendingIntent contentIntent = PendingIntent.getActivity(
                context,
                0,
                unlockIntent,
                PendingIntent.FLAG_IMMUTABLE);

        if (message == null) {
            message = "Your alarm is on!";
        }

        Calendar calendar = Calendar.getInstance();
        SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm", Locale.getDefault());
        String currentTime = dateFormat.format(calendar.getTime());

        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(context, "channel_id")
                .setSmallIcon(R.drawable.ic_notifction)
                .setContentTitle("Alarm  " + currentTime) // Add the current time to the title
                .setContentText(message)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setAutoCancel(true)
                .setSound(null) // Set the sound to null to turn it off
                .setContentIntent(contentIntent);

        // Show the notification
        notificationManager.notify(123, mBuilder.build());
    }

}
