//
//  SplashView.swift
//  Druze
//
//  Created by drew on 12/3/23.
//

import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                Home()
            } else {
                Color.white
                Image("bloom-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
