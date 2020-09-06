//
//  TimerCountText.swift
//  smm
//
//  Created by Vishnu Pradeep on 07/07/2020.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import SwiftUI

struct TimerCountText: View {
    @State var value = 0
    var body: some View {
        Text(value <= 9 ? "0\(value)" : "\(value)")
            .font(.custom("Metropolis", size: 20))
    }
}

struct TimerCountText_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
