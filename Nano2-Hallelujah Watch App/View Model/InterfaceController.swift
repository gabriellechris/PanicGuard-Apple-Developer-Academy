//
//  InterfaceController.swift
//  Nano2-Hallelujah Watch App
//
//  Created by Gabriella Christina Kandinata on 19/05/23.
//

import Foundation
import WatchConnectivity
import WatchKit
import HealthKit

class InterfaceController: WKInterfaceController {

    let healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?
    
    override func didAppear() {
        super.didAppear()
        startWorkoutSession()
    }
    
    func startWorkoutSession() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }
        
        // Configure your workout session
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .running // or any other activity type
        workoutConfiguration.locationType = .outdoor
        
        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            workoutSession?.delegate = self
            workoutSession?.startActivity(with: Date())
        } catch {
            print("Failed to start workout session: \(error)")
        }
    }
    
    func sendDataToPhone(_ isWorkoutActive: Bool) {
        let message = ["isWorkoutActive": isWorkoutActive]
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: { error in
            print("Error sending message to iPhone: \(error.localizedDescription)")
        })
    }
    
    // ...
}

extension InterfaceController: HKWorkoutSessionDelegate {
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed with error: \(error)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        // Handle workout events if needed
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        switch toState {
        case .running, .paused:
            // User is currently in a workout
            sendDataToPhone(true)
        case .ended:
            // Workout has ended
            sendDataToPhone(false)
        default:
            // Not currently in a workout
            sendDataToPhone(false)
        }
    }
    
    // ...
}
