import UIKit
import UserNotifications
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var methodChannel: FlutterMethodChannel?

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: "com.example.bokertov", binaryMessenger: controller.binaryMessenger)
        print("IOS onCreate!!!")

        methodChannel?.setMethodCallHandler({ [weak self] (call, result) in
            if call.method == "scheduleAlarm" {
                print("scheduleAlarm")
                if let arguments = call.arguments as? [String: Any],
                   let time = arguments["time"] as? Int,
                   let message = arguments["message"] as? String {
                    self?.scheduleAlarm(time: time, message: message)
                }
            } else if call.method == "cancelAllAlarms" {
                self?.cancelAllAlarms()
            } else if call.method == "handleNotificationAction" {
                if let action = call.arguments as? String {
                    self?.handleNotificationAction(action)
                }
            }
        })

        private func handleNotificationAction(_ action: String) {
            if action == "action1" {
                // Handle button 1 click
                print("Button 1 clicked")
                methodChannel?.invokeMethod("onButton1Click", arguments: nil)
            } else if action == "action2" {
                // Handle button 2 click
                print("Button 2 clicked")
                methodChannel?.invokeMethod("onButton2Click", arguments: nil)
            }
        }

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
    // Convert time to Date
    let date = Date(timeIntervalSinceNow: TimeInterval(time))

    // Create a content for the regular alert
    let content = UNMutableNotificationContent()
    content.title = "Notification Title"
    content.body = message
    content.sound = UNNotificationSound.default

    // Create actions for the two buttons
    let action1 = UNNotificationAction(identifier: "action-stop", title: "Stop", options: [])
    let action2 = UNNotificationAction(identifier: "action-snooz", title: "Snooz", options: [])

    // Create a category with the two actions
    let category = UNNotificationCategory(identifier: "myCategory", actions: [action1, action2], intentIdentifiers: [], options: [])

    // Register the category
    UNUserNotificationCenter.current().setNotificationCategories([category])

    content.categoryIdentifier = "myCategory"

    // Create a trigger based on the scheduled date
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(5), repeats: false)

    // Create a request with the content and trigger
    let request = UNNotificationRequest(identifier: "regularAlertIdentifier", content: content, trigger: trigger)

    // Add the request to the notification center
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling regular alert: \(error.localizedDescription)")
        } else {
            print("Regular alert scheduled successfully")
        }
    }
}


    private func cancelAllAlarms() {
        // Cancel all scheduled notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
