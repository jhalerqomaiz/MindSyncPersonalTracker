//
//  AppViewModel.swift
//  MeditationTracker
//
//  Created by AI Assistant on 17/10/2025.
//

import Foundation
import SwiftUI
internal import Combine
import Network

@MainActor
final class AppViewModel: ObservableObject {
    @Published var showSplash = true
    @Published var selectedTab: Tab = .meditate
    @Published var isLoading = true
    @Published var showWebView = false
    @Published var showOfflineScreen = false
    @Published var showNativeFallback = false
    @Published var webURL: String?
    @Published var isConnected = true
    
    private let webManager = WebRequestManager.shared
    private let monitor = NWPathMonitor()
    
    enum Tab: String, CaseIterable {
        case meditate = "Meditate"
        case affirmations = "Affirmations"
        case quotes = "Quotes"
        case progress = "Progress"
        case favorites = "Favorites"
        
        var icon: String {
            switch self {
            case .meditate: return "sparkles"
            case .affirmations: return "quote.bubble"
            case .quotes: return "text.quote"
            case .progress: return "chart.line.uptrend.xyaxis"
            case .favorites: return "heart.fill"
            }
        }
    }
    
    init() {
        startNetworkMonitor()
        setupObservers()
    }
    
    private func setupObservers() {
        Task {
            for await _ in NotificationCenter.default.notifications(named: NSNotification.Name("WebURLUpdated")) {
                await updateWebViewState()
            }
        }
    }
    
    private func startNetworkMonitor() {
        monitor.pathUpdateHandler = { path in
            Task { @MainActor in
                self.isConnected = path.status == .satisfied
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func initialize() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        await webManager.checkServerResponse(test: true)
        
        await updateWebViewState()
        
        if webURL == nil {
            showNativeFallback = true
        } else if !isConnected {
            showOfflineScreen = true
        }
        
        isLoading = false
    }
    
    private func updateWebViewState() async {
        await MainActor.run {
            showWebView = webManager.shouldShowWeb && isConnected
            webURL = webManager.urlString
        }
    }
    
    func reloadWebViewIfConnected() async {
        if isConnected, let url = webManager.urlString {
            showWebView = true
            showOfflineScreen = false
        }
    }
}

