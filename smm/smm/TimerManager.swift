//
//  TimerManager.swift
//  smm
//
//  Created by Vishnu Pradeep on 5/7/20.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import Foundation
import SwiftUI
import AVFoundation

class TimerManager: ObservableObject {
    @Published var timerMode: TimerMode = .initial
    @Published var secondsLeft: Int = 0
    @Published var selectedMinuteIndex: Int = 1
    @Published var selectedSecondIndex: Int = 0
    @Published var timeString: String = "00:00"
    @Published var progress: CGFloat = 0.0
    @Published var persistScreen: Bool = true {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(self.persistScreen, forKey: "@SMMPersistScreen")
        }
    }
    @Published var shownInitialView = true
    
    private var totalSeconds: Int = 0
    
    private let notificationCenter: NotificationCenter

    let minuteChoices = Array(0...59)
    let secChoices = Array(0...59)

    var hkManager = HealthKitManager()
    var NFManager = Notifier()
    
    private var timer = Timer()
    private var targetTime: Date?
    private var player: AVAudioPlayer?
    
    private var timeIntervals: [Dictionary<String, Date>] = []
    
    init() {
        let selectedMinuteIndex = UserDefaults.standard.integer(forKey: "@SMMTimerMinutes")
        let selectedSecondIndex = UserDefaults.standard.integer(forKey: "@SMMTimerSeconds")
        let persistScreen = UserDefaults.standard.bool(forKey: "@SMMPersistScreen");
        let shownInitialView = UserDefaults.standard.bool(forKey: "@SMMILv1")
        
        self.secondsLeft = self.minuteChoices[selectedMinuteIndex] * 60
        
        self.persistScreen = persistScreen
        self.selectedMinuteIndex = selectedMinuteIndex
        self.selectedSecondIndex = selectedSecondIndex
        self.shownInitialView = shownInitialView

        self.notificationCenter = NotificationCenter.default
        self.notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)

        self.notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func appMovedToBackground() {

    }

    @objc func appMovedToForeground() {
        if self.timerMode == .running {
            if self.targetTime != nil {
                print(self.targetTime!)
                let elapsed = self.targetTime!.timeIntervalSince(Date())

                if elapsed > 0 {
                    self.secondsLeft = Int(elapsed)
                }
                else {
                    self.markTimePause()
                    self.complete()
                }

                print("Difference is \(elapsed)")
            }
        }
    }
    
    func markInitiationComplete(enableHK: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "@SMMILv1")
        defaults.set(enableHK, forKey: "@SMMHKPermission")
        self.shownInitialView = true
        self.persistScreen = true
    }

    func start() {
        var canContinue: Bool = false
        if timerMode == .initial {
            canContinue = self.setMinutes()
            self.readySound()
        }
        else if timerMode == .paused {
            canContinue = true
        }
        else {
            self.markTimeStart()
        }
        
        if !canContinue {
            return;
        }
        
        NFManager.scheduleNotification(timeInSeconds: self.secondsLeft)
        
        timerMode = .running
        if (self.persistScreen) {
            UIApplication.shared.isIdleTimerDisabled = true
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            if self.secondsLeft == 0 {
                let now = Date()
                self.reset()
                self.markTimePause(startTime: now)
                self.complete()
            }
            else {
                self.secondsLeft -= 1
                self.timeString = self.generateTimeString()
                withAnimation(.default) {
                    self.progress = 1.0 - CGFloat(self.secondsLeft) / CGFloat(self.totalSeconds)
                }
            }
        })
    }

    func complete() {
        self.player?.play()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        print("Final Time intervals", self.timeIntervals)
        hkManager.addMinutes(timeIntervals: self.timeIntervals)
        self.timeIntervals = []
        
        timer.invalidate()
        self.timerMode = .completed
        NFManager.removeScheduledNotification()
        UIApplication.shared.isIdleTimerDisabled = false
    }

    func pause() {
        self.timerMode = .paused
        UIApplication.shared.isIdleTimerDisabled = false
        self.markTimePause()
        timer.invalidate()
        NFManager.removeScheduledNotification()
    }

    func reset() {
        timer.invalidate()
        self.timerMode = .initial
        NFManager.removeScheduledNotification()
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func markTimeStart(startTime: Date? = nil) {
        let now = startTime ?? Date()
        let timeDict:[String: Date] = ["start": now]
        self.timeIntervals.append(timeDict)
    }
    
    func markTimePause(startTime: Date? = nil) {
        let now = startTime ?? Date()
        let index = self.timeIntervals.count - 1
        self.timeIntervals[index]["end"] = now
    }

    func setMinutes() -> Bool {
        let defaults = UserDefaults.standard
        defaults.set(self.selectedMinuteIndex, forKey: "@SMMTimerMinutes")
        defaults.set(self.selectedSecondIndex, forKey: "@SMMTimerSeconds")
        
        let selectedMinute = self.minuteChoices[self.selectedMinuteIndex]
        let selectedSecond = self.secChoices[self.selectedSecondIndex]
        
        print("\(selectedMinute) : \(selectedSecond)")
        if selectedMinute <= 0 && selectedSecond <= 0 {
            return false
        }
        
        self.secondsLeft = selectedMinute * 60
        self.secondsLeft += selectedSecond

        let now = Date()
        let calendar = Calendar.current
        self.totalSeconds = self.secondsLeft
        self.targetTime = calendar.date(byAdding: .second, value: self.secondsLeft, to: now)
        
        self.progress = 0.0
        self.timeString = self.generateTimeString()
        self.markTimeStart(startTime: now)
        
        print("Timer set for \(self.targetTime!)")
        return true
    }
    
    func generateTimeString() -> String {
        let timeMinute = self.secondsLeft / 60
        let timeSecond = self.secondsLeft % 60
        
        let timeMinuteString = timeMinute >= 10 ? "\(timeMinute)" : "0\(timeMinute)"
        let timeSecString = timeSecond >= 10 ? "\(timeSecond)" : "0\(timeSecond)"
        return "\(timeMinuteString):\(timeSecString)";
    }
    
    func readySound() {
        let url = Bundle.main.url(forResource: "timer_complete", withExtension: "mp3")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            self.player = try AVAudioPlayer(contentsOf: url!, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
