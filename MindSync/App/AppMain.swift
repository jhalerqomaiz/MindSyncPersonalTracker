//  AppMain.swift

import SwiftUI
import SwiftData
internal import Combine

@main
struct MeditationTrackerApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var modelContainerHolder = ModelContainerHolder()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .modelContainer(modelContainerHolder.container)
        }
    }
}

final class ModelContainerHolder: ObservableObject {
    let container: ModelContainer
    
    init() {
        let schema = Schema([Meditation.self, Affirmation.self, Quote.self, ProgressRecord.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}


struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            if appViewModel.isLoading {
                SplashScreen()
                    .transition(.opacity)
            }
            else if appViewModel.showWebView, let url = appViewModel.webURL {
                WebViewContainer(url: url)
                    .preferredColorScheme(.dark)
                    .transition(.opacity)
            }
            else if appViewModel.showOfflineScreen, let url = appViewModel.webURL {
                WebViewContainer(url: url)
                    .transition(.opacity)
            }
            else if appViewModel.showNativeFallback {
                MainTabView(selectedTab: $appViewModel.selectedTab).transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appViewModel.isLoading)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showWebView)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showOfflineScreen)
        .animation(.easeInOut(duration: 0.5), value: appViewModel.showNativeFallback)
        .task {
            await appViewModel.initialize()
        }
    }
}
