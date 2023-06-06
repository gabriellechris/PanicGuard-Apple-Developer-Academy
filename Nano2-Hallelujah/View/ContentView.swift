//
//  ContentView.swift
//  Nano2-Hallelujah
//
//  Created by Gabriella Christina Kandinata on 18/05/23.
//

import SwiftUI
import HealthKit
import HealthKitUI
import UserNotifications

struct ContentView: View {
    @State var isModalShown: Bool = false
    @State private var isWorkoutActive = false
    @State var heartRate : Double = 0
    @State private var showConfirmationModal = false
    @State private var showExercisesModal = false
    @State private var heartRateData: [HeartRateEntry] = []

        
    let healthStore = HKHealthStore()
    
    // get heart rate to show
    func getHeartRateData() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                // Handle the error
                print("Error querying heart rate samples: \(error.localizedDescription)")
                return
            }
            
            if let samples = samples as? [HKQuantitySample] {
                for sample in samples {
                    let heartRateUnit = HKUnit(from: "count/min")
                    heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                    
                    // Use the heart rate data as needed
                    print("Heart Rate: \(heartRate)")
                }
            }
        }
        
        healthStore.execute(heartRateQuery)
    }
    
    // Request authorization for all needed health data when the view appears
    func requestAuthorization() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let hrvType = HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let restingHeartRateType = HKObjectType.quantityType(forIdentifier: .restingHeartRate)!
        let respiratoryRateType = HKObjectType.quantityType(forIdentifier: .respiratoryRate)!
           
        let typesToRead: Set<HKObjectType> = [heartRateType, hrvType, restingHeartRateType, respiratoryRateType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if let error = error {
                // Handle the error
                print("Error requesting authorization: \(error.localizedDescription)")
            } else {
                // Authorization succeeded
                print("Authorization succeeded")
            }
        }
    }
    
   //Retrieve health's data
    
    func retrieveHealthData(completion: @escaping (Double, Double, Double, Double) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!
        let restingHeartRateType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate)!
        let respiratoryRateType = HKQuantityType.quantityType(forIdentifier: .respiratoryRate)!

//        let healthDataTypes: [HKQuantityType] = [heartRateType, hrvType, restingHeartRateType, respiratoryRateType]

        let healthDataQuery = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample] else {
                // Handle error
                return
            }

            var heartRate: Double = 0
            var hrv: Double = 0
            var restingHeartRate: Double = 0
            var respiratoryRate: Double = 0

            for sample in samples {
                if sample.sampleType == heartRateType {
                    heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                } else if sample.sampleType == hrvType {
                    hrv = sample.quantity.doubleValue(for: HKUnit.secondUnit(with: .milli))
                } else if sample.sampleType == restingHeartRateType {
                    restingHeartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                } else if sample.sampleType == respiratoryRateType {
                    respiratoryRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                }
            }

            completion(heartRate, hrv, restingHeartRate, respiratoryRate)
        }

        healthStore.execute(healthDataQuery)
    }


    // check if any conditions are met
    func checkHealthData() {
        retrieveHealthData { (heartRate, hrv, restingHeartRate, respiratoryRate) in
            // Calculate the threshold values for each parameter
            let heartRateThreshold = 1.2 * heartRate // 20% increase
            let hrvThreshold = 0.7 * hrv // 30% decrease
            let restingHeartRateThreshold = 1.15 * restingHeartRate // 15% increase
            let respiratoryRateThreshold = 1.5 * respiratoryRate // 50% increase
            print(heartRate)
            // Check if any of the conditions are met
//            if heartRate > heartRateThreshold {
//                // Condition 1: 20% increase in heart rate
//                showPushNotification()
//                navigateToConfirmationModalAutomatically()
            if heartRate > 40 {
                // Condition 1: 20% increase in heart rate
                showPushNotification()
                navigateToConfirmationModalAutomatically()
            } else if hrv < hrvThreshold {
                // Condition 2: 30% decrease in HRV
                showPushNotification()
                navigateToConfirmationModalAutomatically()
            } else if restingHeartRate > restingHeartRateThreshold {
                // Condition 3: 15% increase in resting heart rate
                showPushNotification()
                navigateToConfirmationModalAutomatically()
            } else if respiratoryRate > respiratoryRateThreshold {
                // Condition 4: 50% increase in respiratory rate
                showPushNotification()
                navigateToConfirmationModalAutomatically()
            }
        }
    }

    // Alert
    func showPushNotification() {
        // Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "Health Alert"
        content.body = "Are you having an anxiety attack?"
        content.sound = UNNotificationSound.default

        // Create the notification trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // Create the notification request
        let request = UNNotificationRequest(identifier: "HealthAlertNotification", content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error showing push notification: \(error.localizedDescription)")
            } else {
                print("Push notification shown successfully")
            }
        }
    }


    func navigateToConfirmationModal() {
        showConfirmationModal = true
    }

    func navigateToConfirmationModalAutomatically() {
        DispatchQueue.main.async {
            showConfirmationModal = true
            print("navigate")
        }
    }

    // Update on background
    func startObservingNewUpdates() {

        let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate)!

        // 1. Enable background delivery for heart rate
        self.healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate) { (success, error) in
            if let unwrappedError = error {
                print("Could not enable background delivery: \(unwrappedError)")
            }
            if success {
                print("Background delivery enabled")
            }
        }

        // 2. Open observer query
        let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completionHandler, error) in
            self.updateHeartRate() {
                completionHandler()
            }
        }
        healthStore.execute(query)
    }

    func updateHeartRate(completionHandler: @escaping () -> Void) {

        var anchor: HKQueryAnchor?

        let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate)!

        let anchoredQuery = HKAnchoredObjectQuery(type: sampleType, predicate: nil, anchor: anchor, limit: HKObjectQueryNoLimit) {query, newSamples, deletedSamples, newAnchor, error in

            self.handleNewHeartRateSamples(new: newSamples ?? [], deleted: deletedSamples ?? [])

            anchor = newAnchor

            completionHandler()
        }
        healthStore.execute(anchoredQuery)
    }

    func handleNewHeartRateSamples(new: [HKSample], deleted: [HKDeletedObject]) {
        for sample in new {
            if let heartRateSample = sample as? HKQuantitySample {
                self.heartRate = heartRateSample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                
//                // Handle the new heart rate sample data here
//                print("Heart rate: \(heartRate)")
            }
        }
    }

    
    
    var body: some View {
        
            ZStack {
                Color(.black)
                    .ignoresSafeArea()
                
                
                VStack {
//                    HStack {
//                        Text("You've done well 🤗")
//                            .padding()
//                            .foregroundColor(.white)
//                            .font(.title)
//                        Spacer()
//                    }
//
                    
                    Spacer()
                        .frame(height: 25)
                    
                    
                    Text("Your current heart rate")
                        .foregroundColor(.gray)
                        .font(.body)
                    
                    HStack {
                        Text(String(format: "%.0f", heartRate)) // Format the heart rate value as a whole number
                            .foregroundColor(.white)
                            .font(.system(size: 100))
                            .onAppear() {
                                getHeartRateData()
                            }
                        
                        Image("heart")
                    }
                    
                    Text("BPM")
                        .foregroundColor(.gray)
                        .font(.headline)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    //Title
                    Text("History")
                        .foregroundColor(.white)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(24)
                    
                    
                    //Data heart rate

                    HeartRateListView()
                    
//                    ForEach(0..<5) { index in
//                        HStack {
//                            Text("Jam")
//                                .foregroundColor(.white)
//
//                            Spacer()
//                                .frame(width: 230)
//                            Text("heart rate")
//                                .foregroundColor(.white)
//                        }
//
//                        if index != 4 {
//                            Divider()
//                                .background(.white)
//                        }
//                    }
                    
                    
                    
//                    Spacer()
                    
                        
                    
                    Button() {
                        showExercisesModal = true
                    } label: {
                        Text("Learn more")
                            .frame(width: 150, height: 20)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .font(.headline)
                            .foregroundColor(Color.orange)
                            .background(Color(hex:0xFF1E1E1E))
                            .fontWeight(.medium)
                            .cornerRadius(15)
                    }
                    .padding(20)
                    .clipShape(Capsule())
                    
                    Spacer()
                }
                
                Spacer()
                
            }
            .onAppear {
                requestAuthorization()
                checkHealthData()
            }
            .navigationTitle("You've done well 🤗")
            .fullScreenCover(isPresented: $showConfirmationModal) {
                Confirmation_Modal(showConfirmationModel: $showConfirmationModal, showExercisesModal: $showExercisesModal)
            }
            .fullScreenCover(isPresented: $showExercisesModal) {
                Exercises_Tutorial(showExercisesModal: $showExercisesModal)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

struct HeartRateEntry: Identifiable {
    let id = UUID()
    let time: String
    let heartRate: Int
}

struct HeartRateListView: View {
    @State private var heartRateData: [HeartRateEntry] = []

    var body: some View {
        List(heartRateData, id: \.id) { entry in
            HStack {
                Text(entry.time)
                    .foregroundColor(.white)

                Spacer()

                Text("\(entry.heartRate)")
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            retrieveHeartRateData()
        }
    }

    func retrieveHeartRateData() {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 5, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            guard let samples = samples as? [HKQuantitySample] else {
                return
            }

            var entries: [HeartRateEntry] = []
            for sample in samples {
                let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                let heartRateValue = sample.quantity.doubleValue(for: heartRateUnit)
                let time = formatDate(sample.endDate)

                let entry = HeartRateEntry(time: time, heartRate: Int(heartRateValue))
                entries.append(entry)
            }

            DispatchQueue.main.async {
                heartRateData = entries
            }
        }

        HKHealthStore().execute(query)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}
