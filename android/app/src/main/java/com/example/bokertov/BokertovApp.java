package com.example.bokertov;

import android.app.Application;

import io.flutter.app.FlutterApplication;
import io.flutter.view.FlutterMain;

public class BokertovApp extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
    }
}
