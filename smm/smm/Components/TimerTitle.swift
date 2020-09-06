//
//  TimerTitle.swift
//  smm
//
//  Created by Vishnu Pradeep on 07/07/2020.
//  Copyright © 2020 Maven Intel. All rights reserved.
//

import SwiftUI

struct TimerTitle: View {
    @State var value = ""
    var body: some View {
        Text(self.value)
        .font(.custom("Metropolis-Medium", size: 20))
            .padding(.top)
    }
}

struct TimerTitle_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
