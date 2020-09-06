//
//  HealthKitManager.swift
//  smm
//
//  Created by Vishnu Pradeep on 5/7/20.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import SwiftUI
import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    @Published var hasPermission: Bool = true {
        didSet {
            print("Current HK Permission", self.hasPermission)
        }
    }
    let healthStore = HKHealthStore()
    let mindfulType = HKObjectType.categoryType(forIdentifier: .mindfulSession)
    
    init() {
        print("Starting HealthKitManager")
        self.hasPermission = UserDefaults.standard.bool(forKey: "@SMMHKPermission")
        print("Starting HealthKitManager \(self.hasPermission)")
        if (self.hasPermission) {
            self.activateHealthKit()
        }
    }
    
    func activateHealthKit() {
        // Define what HealthKit data we want to ask to read
        let typestoRead = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
        ])

        // Define what HealthKit data we want to ask to write
        let typestoShare = Set([
            HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!
        ])
        
        // Prompt the User for HealthKit Authorization
        self.healthStore.requestAuthorization(toShare: typestoShare, read: typestoRead) { (success, error) in
            if !success {
                print("____________________HealthKit Auth error_________________________")
                print(error as Any)
                print("____________________HealthKit Auth error_________________________")
                self.hasPermission = false
            }
            else {
                print("We have healthStore")
                self.hasPermission = true
            }
            
            let defaults = UserDefaults.standard
            defaults.set(self.hasPermission, forKey: "@SMMHKPermission")
        }
    }
    
    func retrieveMindFulMinutes() {
    }
    
    func addMinutes(timeIntervals: [Dictionary<String, Date>]) {
        for timeInterval in timeIntervals {
            print(timeInterval)
            let startTime: Date = timeInterval["start"]!
            let endTime: Date = timeInterval["end"]!
            let mindfullSample = HKCategorySample(type:mindfulType!, value: 0, start: startTime, end: endTime)
            
            healthStore.save(mindfullSample, withCompletion: { (success, error) -> Void in
                if error != nil {return}

                print("New data was saved in HealthKit: \(success)")
                self.retrieveMindFulMinutes()
            })
        }
        
    }
}
