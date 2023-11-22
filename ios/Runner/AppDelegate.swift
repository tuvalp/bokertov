import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var methodChannel: FlutterMethodChannel?

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: "com.example.bokertov", binaryMessenger: controller.binaryMessenger)
        print("IOS onCreate!!!");

        methodChannel?.setMethodCallHandler({ [weak self] (call, result) in
            if call.method == "scheduleAlarm" {
                print("scheduleAlarm");
                if let arguments = call.arguments as? [String: Any],
                   let time = arguments["time"] as? Int,
                   let message = arguments["message"] as? String {
                    self?.scheduleAlarm(time: time, message: message)
                }
            } else if call.method == "cancelAllAlarms" {
                self?.cancelAllAlarms()
            }
        })

        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .provisional, .criticalAlert]) { (granted, error) in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }


        GeneratedPluginRegistrant.register(with: self)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func scheduleAlarm(time: Int, message: String) {
        // Convert time to Date or use your own logic to determine the notification time
        // For example, you can use DateComponents to specify hours and minutes
        let date = Date()

        let triggerDate = Calendar.current.date(byAdding: .second, value: time, to: date)!

        // Create a content for the critical alert
        let content = UNMutableNotificationContent()
        content.title = "Critical Alert Title"
        content.body = message
        content.sound = UNNotificationSound.defaultCritical

        // Create a trigger with a 5-second delay
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)

        // Create a request with the content and trigger
        let request = UNNotificationRequest(identifier: "criticalAlertIdentifier", content: content, trigger: trigger)

        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            // Handle any errors
        }
    }
    

    private func cancelAllAlarms() {
        // Cancel all scheduled notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        // Cancel background tasks
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalNever)
    }

    override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Handle background fetch, unlock the screen, and launch the app
        print("Unlock screen and launch app method triggered")
        unlockScreenAndLaunchApp()
        completionHandler(.newData)
    }

    private func unlockScreenAndLaunchApp() {
        // Unlocking the screen programmatically is not possible in iOS due to security restrictions.
        // You can launch the app and navigate to a specific route using Flutter method channel.
        methodChannel?.invokeMethod("onAlarmTriggered", arguments: nil)
        print("Unlock screen and launch app method triggered")
    }
}
