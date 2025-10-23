//
//  MainTabView.swift
//  MeditationTracker
//
//  Created by AI Assistant on 17/10/2025.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Binding var selectedTab: AppViewModel.Tab
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MeditateView(modelContext: modelContext)
                .tabItem {
                    Label(AppViewModel.Tab.meditate.rawValue, 
                          systemImage: AppViewModel.Tab.meditate.icon)
                }
                .tag(AppViewModel.Tab.meditate)
            
            AffirmationsView(modelContext: modelContext)
                .tabItem {
                    Label(AppViewModel.Tab.affirmations.rawValue,
                          systemImage: AppViewModel.Tab.affirmations.icon)
                }
                .tag(AppViewModel.Tab.affirmations)
            
            QuotesView(modelContext: modelContext)
                .tabItem {
                    Label(AppViewModel.Tab.quotes.rawValue,
                          systemImage: AppViewModel.Tab.quotes.icon)
                }
                .tag(AppViewModel.Tab.quotes)
            
            ProgressMeditationView(modelContext: modelContext)
                .tabItem {
                    Label(AppViewModel.Tab.progress.rawValue,
                          systemImage: AppViewModel.Tab.progress.icon)
                }
                .tag(AppViewModel.Tab.progress)
            
            FavoritesView(modelContext: modelContext)
                .tabItem {
                    Label(AppViewModel.Tab.favorites.rawValue,
                          systemImage: AppViewModel.Tab.favorites.icon)
                }
                .tag(AppViewModel.Tab.favorites)
        }
        .tint(Color(hex: "00CED1"))
    }
}

#Preview {
    MainTabView(selectedTab: .constant(.meditate))
        .modelContainer(for: [Meditation.self, Affirmation.self, Quote.self, ProgressRecord.self])
}

