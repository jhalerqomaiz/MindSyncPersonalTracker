//
//  SplashScreen.swift
//  MeditationTracker
//
//  Created by AI Assistant on 17/10/2025.
//

import SwiftUI

struct SplashScreen: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0.0
    
    var body: some View {
        ZStack {
            
        }
        .statusBar(hidden: true)
        .onAppear {
            withAnimation(.spring(response: 1.0, dampingFraction: 0.6)) {
                scale = 1.0
            }
            
            withAnimation(.easeIn(duration: 0.8)) {
                opacity = 1.0
            }
        }
    }
}

#Preview {
    SplashScreen()
}

