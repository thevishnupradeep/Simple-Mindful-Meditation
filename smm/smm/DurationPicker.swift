//
//  DurationPicker.swift
//  smm
//
//  Created by Vishnu Pradeep on 03/07/2020.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import SwiftUI

struct DurationPicker: View {
    @ObservedObject var timerManager: TimerManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack() {
            VStack {
                TimerTitle(value: "Mins")
                Picker(selection: $timerManager.selectedMinuteIndex, label: Text("")) {
                    ForEach(0 ..< self.timerManager.minuteChoices.count) {
                        TimerCountText(value: self.timerManager.minuteChoices[$0])
                    }
                }
                .frame(minWidth: 0, maxWidth: 300)
                .clipped()
            }
            .background(Color.init(hex: colorScheme == .dark ? "#2F2F2F" : "#F5F5F5"))
            .cornerRadius(10)
            .padding(.leading)
            VStack {
                TimerTitle(value: "Secs")
                Picker(selection: $timerManager.selectedSecondIndex, label: Text("")) {
                    ForEach(0 ..< self.timerManager.secChoices.count) {
                        TimerCountText(value: self.timerManager.secChoices[$0])
                    }
                }
                .frame(minWidth: 0, maxWidth: 300)
                .clipped()
            }
            .background(Color.init(hex: colorScheme == .dark ? "#2F2F2F" : "#F5F5F5"))
            .cornerRadius(10)
            .padding(.trailing)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct DurationPicker_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
