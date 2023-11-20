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
                   let delay = arguments["delay"] as? Int,
                   let message = arguments["message"] as? String {
                    self?.scheduleAlarm(delay: delay, message: message)
                }
            } else if call.method == "cancelAllAlarms" {
                self?.cancelAllAlarms()
            }
        })

        // Request notification permissions
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }

        GeneratedPluginRegistrant.register(with: self)

    }

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Your custom initialization code

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}

private func scheduleAlarm(delay: Int, message: String) {
    // Schedule local notification
    let content = UNMutableNotificationContent()
    content.title = "Alarm"
    content.body = message

    // Create a unique identifier for the notification
    let identifier = UUID().uuidString

    // Set up the trigger for the notification
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(delay / 1000), repeats: false)

    // Create the notification request
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

    // Add the request to the notification center
    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        } else {
            print("Notification scheduled successfully with message: \(message)")
        }
    }

    // Log the scheduled alarm
    print("Alarm scheduled with delay: \(delay) seconds and message: \(message)")

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
