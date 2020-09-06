//
//  Countdown.swift
//  smm
//
//  Created by Vishnu Pradeep on 03/07/2020.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import SwiftUI

struct Countdown: View {
    @ObservedObject var timerManager: TimerManager
    @Environment(\.colorScheme) var colorScheme
    
    var conic: AngularGradient
    
    init(timerManager: TimerManager) {
        self.timerManager = timerManager
        let colors = Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red])
        self.conic = AngularGradient(gradient: colors, center: .center, startAngle: .zero, endAngle: .degrees(360))
    }
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                .trim(from: 0, to: 1)
                .stroke(colorScheme == .dark ? Color.white.opacity(0.09) : Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                
                Circle()
                .trim(from: 0, to: self.timerManager.progress)
                    .stroke(self.conic, style: StrokeStyle(lineWidth: 25, lineCap: .round))
            }
            .frame(width: 250, height: 250)
            .rotationEffect(.init(degrees: -90))
            Text(self.timerManager.timeString)
            .font(.custom("Metropolis-Bold", size: 25))
            .frame(width: 100, height: 50)
        }
    }
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
