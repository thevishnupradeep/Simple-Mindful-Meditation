//
//  Notifier.swift
//  smm
//
//  Created by Vishnu Pradeep on 5/7/20.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import UIKit
import SwiftUI
import Foundation
import UserNotifications

class Notifier: ObservableObject {
    private let defaultNFKey = "@SMMDefualtNotification"
    private let center = UNUserNotificationCenter.current()
    private var defaultNotification: String?
    
    private let notificationCenter: NotificationCenter
    
    @Published var isEnabled: Bool = true {
        didSet {
            print("Current isEnabled Value", isEnabled)
        }
    }
    
    @Published var isDenied: Bool = false {
        didSet {
            print("Current isDenied Value", isEnabled)
        }
    }
    
    init() {
        self.defaultNotification = UserDefaults.standard.string(forKey: defaultNFKey)
        print("Found notification: ", self.defaultNotification ?? "")

        self.notificationCenter = NotificationCenter.default
        self.notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToForeground() {
        self.checkNotificationPermission()
    }
    
    func checkNotificationPermission() {
        center.getNotificationSettings(completionHandler: {(settings) in
            switch settings.authorizationStatus {
                case .authorized, .provisional:
                    self.isEnabled = true
                    self.isDenied = false
                case .denied:
                    self.isEnabled = false
                    self.isDenied = true
                case .notDetermined:
                    self.isEnabled = false
                    self.isDenied = false
                @unknown default:
                    self.isEnabled = false
                    self.isDenied = false
            }
        })
    }
    
    func getPermission() {
        if !self.isDenied {
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    print("Yay!")
                } else {
                    print("D'ah")
                }
            }
        }
        else {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
    }
    
    func removeScheduledNotification() {
        print("Attempt Removing notification: ", self.defaultNotification ?? "")
        if self.defaultNotification != nil {
            print("Removing notification: ", self.defaultNotification!)
            center.removePendingNotificationRequests(withIdentifiers: [self.defaultNotification!])
            UserDefaults.standard.removeObject(forKey: defaultNFKey)
            self.defaultNotification = nil
        }
    }
    
    func scheduleNotification(timeInSeconds: Int) {
        self.removeScheduledNotification()
        
        let mountains: UNNotificationSound = UNNotificationSound.init(named: UNNotificationSoundName(rawValue: "timer_complete.mp3"))
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = mountains

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timeInSeconds), repeats: false)
        let notificationIdentifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
        print("Saving notification", notificationIdentifier)
        UserDefaults.standard.set(notificationIdentifier, forKey: defaultNFKey)
        defaultNotification = notificationIdentifier
        center.add(request)
    }
}
