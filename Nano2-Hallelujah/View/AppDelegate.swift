////
////  AppDelegate.swift
////  Nano2-Hallelujah
////
////  Created by Gabriella Christina Kandinata on 21/05/23.
////
//
//import UserNotifications
//import SwiftUI
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        UNUserNotificationCenter.current().delegate = self
//        return true
//    }
//}
//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        // Here we actually handle the notification
//        print("Notification received with identifier \(notification.request.identifier)")
//        // So we call the completionHandler telling that the notification should display a banner and play the notification sound - this will happen while the app is in foreground
//        completionHandler([.banner, .sound])
//    }
//}


import UIKit
import HealthKit
import UserNotifications
import SwiftUI
import BackgroundTasks

//@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let healthStore = HKHealthStore()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set the UNUserNotificationCenter delegate for push notification handling
        UNUserNotificationCenter.current().delegate = self

        // Configure the background fetch interval
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)

        // Request authorization for HealthKit
        requestAuthorization()

        return true
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Here we actually handle the notification
        print("Notification received with identifier \(notification.request.identifier)")
        // So we call the completionHandler telling that the notification should display a banner and play the notification sound - this will happen while the app is in foreground
        completionHandler([.banner, .sound])
    }
}

// MARK: - Background Fetch

extension AppDelegate {
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Retrieve the latest health data
        retrieveHealthData { (heartRate, hrv, respiratoryRate) in
            // Process the retrieved data

            // Update the UI or perform any necessary actions

            // Call the completion handler
            completionHandler(.newData) // or .noData if no new data is available
        }
    }

    private func requestAuthorization() {
        // Request authorization for HealthKit data types
        let healthTypesToRead: Set<HKQuantityType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!
        ]

        healthStore.requestAuthorization(toShare: nil, read: healthTypesToRead) { (success, error) in
            if success {
                print("Authorization succeeded")
            } else {
                if let error = error {
                    print("Authorization failed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func retrieveHealthData(completion: @escaping (Double, Double, Double) -> Void) {
        // Retrieve the latest health data
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let respiratoryRateType = HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!

        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { (query, samples, error) in
            if let heartRateSample = samples?.first as? HKQuantitySample {
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let heartRate = heartRateSample.quantity.doubleValue(for: heartRateUnit)

                let hrvUnit = HKUnit(from: "ms")
                let hrv = heartRateSample.quantity.doubleValue(for: hrvUnit)

                let respiratoryRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let respiratoryRate = heartRateSample.quantity.doubleValue(for: respiratoryRateUnit)

                completion(heartRate, hrv, respiratoryRate)
            }

            if let error = error {
                print("Health data retrieval failed: \(error.localizedDescription)")
            }
        }

        healthStore.execute(query)
    }
}
