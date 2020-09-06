//
//  Welcome.swift
//  smm
//
//  Created by Vishnu Pradeep on 09/07/2020.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import SwiftUI

struct Welcome: View {
    let timerManager: TimerManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Welcome!")
                .font(.custom("Metropolis-Bold", size: 30))
                .padding(.vertical, 10)
                Text("Start meditating by choosing the required time. The completed meditation time will be added to Apple Health App.")
                .frame(maxWidth: 550)
                .font(.custom("Metropolis-Regular", size: 17))
                .lineSpacing(6)
                .multilineTextAlignment(.center)
                .padding(.vertical, 10)
                
                Image(systemName: "staroflife")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(Color.init(hex: "#FF2D55"))
                .padding()
                
                Button(action: {
                    print("Activating HKit")
                    self.timerManager.hkManager.activateHealthKit()
                    self.timerManager.markInitiationComplete(enableHK: false)
                }) {
                    Text("Connect Health App")
                    .padding()
                    .padding(.horizontal, 20)
                    .background(Color.init(hex: "#16191F"))
                    .foregroundColor(.white)
                    .font(.custom("Metropolis-Bold", size: 20))
                    .cornerRadius(10)
                }
                Spacer().frame(height: 10)
                Button(action: {
                    self.timerManager.markInitiationComplete(enableHK: false)
                }) {
                    Text("Do it later")
                    .padding()
                    .padding(.horizontal, 20)
                    .foregroundColor(Color.init(hex: colorScheme == .dark ? "#F2F2F2" : "#16191F"))
                    .foregroundColor(Color.init(hex: "#16191F"))
                    .font(.custom("Metropolis-Bold", size: 20))
                    .cornerRadius(10)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(10)
            .padding(.vertical, 20)
            .background(Color.init(hex: colorScheme == .dark ? "#2F2F2F" : "#F5F5F5"))
            .cornerRadius(50)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
