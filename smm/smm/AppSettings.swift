//
//  AppSettings.swift
//  smm
//
//  Created by Vishnu Pradeep on 08/07/2020.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import SwiftUI

struct AppSettings: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var showSettings: Bool
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var hkManager: HealthKitManager = HealthKitManager()
    @ObservedObject var NFManager: Notifier = Notifier()
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("SETTINGS")
                .fontWeight(.bold)
                    .font(.custom("Metropolis-Black", size: 30))
                .multilineTextAlignment(.leading)
                
                Spacer()
                
                Button(action: {
                    self.showSettings.toggle()
                }) {
                    Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color.init(hex: colorScheme == .dark ? "#F2F2F2" : "#16191F"))
                }
            }
            .padding(.vertical)
            
            HStack {
                Toggle(isOn: $timerManager.persistScreen) {
                    Text("Keep screen on while meditating")
                        .font(.custom("Metropolis-Light", size: 16))
                }
                .padding()
            }
            .background(Color.init(hex: colorScheme == .dark ? "#2F2F2F" : "#F5F5F5"))
            .cornerRadius(8)
            .padding(.bottom, 20.0)
            
            HStack {
                Text(hkManager.hasPermission ? "Health App is connected." : "Conect Health App")
                .font(.custom("Metropolis-Light", size: 16))
                Spacer()
                if !hkManager.hasPermission {
                    Button(action: {
                        self.hkManager.activateHealthKit()
                    }) {
                        Text("Connect")
                    }
                }
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.init(hex: colorScheme == .dark ? "#2F2F2F" : "#F5F5F5"))
            .cornerRadius(8)
            .padding(.bottom, 30.0)
            
            HStack {
                Text(NFManager.isEnabled ? "Notifications are turned on." : "Notification is disabled")
                .font(.custom("Metropolis-Light", size: 16))
                Spacer()
                
                if !NFManager.isEnabled {
                    Button(action: {
                        self.NFManager.getPermission()
                    }) {
                        Text(!NFManager.isDenied ? "Settings" : "Enable")
                    }
                }
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(Color.init(hex: colorScheme == .dark ? "#2F2F2F" : "#F5F5F5"))
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
}

struct AppSettings_Previews: PreviewProvider {
    static var previews: some View {
        AppSettings(showSettings: .constant(true), timerManager: TimerManager())
    }
}
