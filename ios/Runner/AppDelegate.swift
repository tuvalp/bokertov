import UIKit
import UserNotifications
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    var methodChannel: FlutterMethodChannel?

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: "com.example.bokertov", binaryMessenger: controller.binaryMessenger)
        print("IOS onCreate!!!")

        methodChannel?.setMethodCallHandler({ [weak self] (call, result) in
            if call.method == "scheduleAlarm" {
                print("scheduleAlarm")
                if let arguments = call.arguments as? [String: Any],
                   let time = arguments["delay"] as? Int,
                   let message = arguments["message"] as? String {
                    self?.scheduleAlarm(time: time, message: message)
                }
            } else if call.method == "cancelAllAlarms" {
                self?.cancelAllAlarms()
            }
        })

        // Request notification permission here
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }

        // Set the delegate to handle notification actions
        UNUserNotificationCenter.current().delegate = self

        if let notification = launchOptions?[.remoteNotification] as? [String: Any] {
            handleNotificationTapped(notification)
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func scheduleAlarm(time: Int, message: String) {
        // Convert milliseconds to seconds
        let seconds = Double(time) / 1000.0

        // Calculate the fire date by adding the specified time to the current date
        let currentDate = Date()
        let fireDate = currentDate.addingTimeInterval(seconds)

        // Create a notification content
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = message
        content.sound = UNNotificationSound.default

        // Create a notification trigger with the calculated fire date
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fireDate), repeats: false)

        // Create a notification request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully!")
            }
        }
    }

    func cancelAllAlarms() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("All alarms canceled successfully!")
    }

    // MARK: - UNUserNotificationCenterDelegate

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Check the identifier to determine which action was selected
        let actionIdentifier = response.actionIdentifier

        // Check if the app is in the foreground or background
 if UIApplication.shared.applicationState == .active {
        // App is in the foreground
        print("App is in the foreground")
        methodChannel?.invokeMethod("onAlarmReceived", arguments: nil)
    } else {
        // App is in the background or not running
        print("App is in the background or not running")

        let flutterViewController = FlutterViewController()

        // Initialize Flutter only once
        GeneratedPluginRegistrant.register(with: flutterViewController)

        window?.rootViewController = flutterViewController
        window?.makeKeyAndVisible()

        // Listen for Flutter engine creation completion
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(forName: UIWindow.didBecomeVisibleNotification, object: window, queue: nil) { _ in
                // Invoke the method once Flutter is ready
                self.methodChannel?.invokeMethod("onAlarmReceived", arguments: nil, result: { (result) in
                    if let error = result as? FlutterError {
                        print("Error invoking method: \(error)")
                    }
                })
            }
        } else {
            // Fallback on earlier versions if needed
        }
    }


        // Call the completion handler
        completionHandler()
    }

    // Handle the case when the app is launched due to a notification tap
    func handleNotificationTapped(_ notification: [String: Any]) {
        methodChannel?.invokeMethod("onAlarmReceived", arguments: nil)
    }
}
