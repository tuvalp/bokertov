import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var methodChannel: FlutterMethodChannel?

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: "com.example.bokertov", binaryMessenger: controller.binaryMessenger)
        
        methodChannel?.setMethodCallHandler({ [weak self] (call, result) in
            if call.method == "scheduleAlarm" {
                if let arguments = call.arguments as? [String: Any],
                   let delay = arguments["delay"] as? Int,
                   let message = arguments["message"] as? String {
                    self?.scheduleAlarm(delay: delay, message: message)
                }
            } else if call.method == "cancelAllAlarms" {
                self?.cancelAllAlarms()
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func scheduleAlarm(delay: Int, message: String) {
        // Schedule local notification
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = message

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        } else {
            print("Notification scheduled successfully with message: \(message)")
        }
    }


        // Schedule background task to launch the app
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
    }

    private func cancelAllAlarms() {
        // Cancel all scheduled notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        // Cancel background tasks
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalNever)
    }

    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle background fetch, unlock the screen, and launch the app
        unlockScreenAndLaunchApp()
        completionHandler(.newData)
    }

    private func unlockScreenAndLaunchApp() {
        // Unlocking the screen programmatically is not possible in iOS due to security restrictions.
        // You can launch the app and navigate to a specific route using Flutter method channel.
        methodChannel?.invokeMethod("onAlarmTriggered", arguments: nil)
    }
}
