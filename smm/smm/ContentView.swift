//
//  ContentView.swift
//  smm
//
//  Created by Vishnu Pradeep on 4/10/20.
//  Copyright © 2020 Maven Intel. All rights reserved.

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showSettings = false
    @ObservedObject var timerManager = TimerManager()
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .center) {
                    Text("MEDITATE")
                    .fontWeight(.bold)
                    .font(.custom("Metropolis-Bold", size: 30))
                    .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        self.showSettings.toggle()
                    }) {
                        Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.init(hex: colorScheme == .dark ? "#F2F2F2" : "#16191F"))
                    }.sheet(isPresented: $showSettings) {
                        AppSettings(showSettings: self.$showSettings, timerManager: self.self.timerManager)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 30)
                
                Spacer()
                if timerManager.timerMode == .initial {
                    DurationPicker(timerManager: timerManager)
                }
                else if timerManager.timerMode == .completed {
                    CompleteView(timerManager: timerManager)
                }
                else {
                    Countdown(timerManager: timerManager)
                    
                    if timerManager.persistScreen {
                        Text("Screen display will remain on while you meditate, to turn the display off changes can be made in the srettings.")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .font(.custom("Metropolis-Light", size: 16))
                        .lineSpacing(6)
                        .frame(maxWidth: 350)
                        .padding(.top, 30)
                        
                        Button(action: {
                            self.showSettings = true
                        }) {
                            Text("Settings")
                            .foregroundColor(Color.blue)
                            .multilineTextAlignment(.center)
                            .font(.custom("Metropolis-Light", size: 16))
                            .frame(maxWidth: 350)
                            .padding(.top, 20)
                            .padding(.bottom, 30)
                        }
                    }
                    
                }
                Spacer()
                
                if timerManager.timerMode != .completed {
                    Button(action: {
                        self.timerManager.timerMode == .running ?
                        self.timerManager.pause() :
                        self.timerManager.start()
                    }) {
                        Image(systemName: timerManager.timerMode == .running ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(.red)
                    }
                    
                    if timerManager.timerMode == .paused {
                        Button(action: {
                            self.timerManager.reset()
                        }) {
                            Image(systemName: "stop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .padding(.top, 50)
                            .foregroundColor(.blue)
                        }
                    }
                    else {
                        Spacer()
                        .frame(width: 70, height: 70)
                        .padding(.top, 50)
                    }
                }
                
                Spacer()
                .frame(height: 30)
            }
            if !self.timerManager.shownInitialView {
                Welcome(timerManager: self.timerManager)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
