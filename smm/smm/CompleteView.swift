//
//  CompleteView.swift
//  smm
//
//  Created by Vishnu Pradeep on 11/07/2020.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import SwiftUI

struct CompleteView: View {
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var quoteManager: QuoteManager = QuoteManager()
    
    var body: some View {
        VStack {
            Text("Well Done!")
            .font(.custom("Metropolis-Bold", size: 30))
            .padding()
            
            Text(quoteManager.quote.quote)
            .font(.custom("Metropolis-Light", size: 20))
            .multilineTextAlignment(.center)
            .padding()
            
            Text("- \(quoteManager.quote.quoteBy)")
            .font(.custom("Metropolis-RegularItalic", size: 20))
            .multilineTextAlignment(.leading)
            .padding(.bottom)
            
            Button(action: {
                self.timerManager.timerMode = .initial
            }) {
                Text("Done")
                .padding()
                .padding(.horizontal, 50)
                .background(Color.init(hex: "#16191F"))
                .foregroundColor(.white)
                .font(.custom("Metropolis-Bold", size: 20))
                .cornerRadius(10)
            }
            .padding(.vertical, 30)
        }
        .frame(minWidth: 0, maxWidth: 700)
        
    }
}

struct CompleteView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
