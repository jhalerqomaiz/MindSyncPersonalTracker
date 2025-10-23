//  ProgressView.swift

import SwiftUI
import SwiftData

struct ProgressMeditationView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ProgressViewModel
    
    init(modelContext: ModelContext? = nil) {
        _viewModel = StateObject(wrappedValue: ProgressViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Today's Stats
                    if let today = viewModel.todayRecord {
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(hex: "00CED1"))
                                Text("Today's Activity")
                                    .font(.headline)
                                Spacer()
                            }
                            
                            HStack(spacing: 24) {
                                StatItem(icon: "timer", value: "\(today.meditationMinutes)", label: "Minutes")
                                Divider().frame(height: 40)
                                StatItem(icon: "quote.bubble", value: "\(today.affirmationsCount)", label: "Affirmations")
                                Divider().frame(height: 40)
                                StatItem(icon: "text.quote", value: "\(today.quotesViewed)", label: "Quotes")
                            }
                        }
                        .padding()
                        .cardStyle()
                    } else {
                        Text("Start your practice today!")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding()
                            .cardStyle()
                    }
                    
                    // Statistics Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(icon: "flame.fill", title: "Current Streak", value: "\(viewModel.currentStreak)", subtitle: "days", color: .orange)
                        StatCard(icon: "timer", title: "Total Minutes", value: "\(viewModel.totalMinutes)", subtitle: "meditation", color: Color(hex: "00CED1"))
                        StatCard(icon: "quote.bubble", title: "Affirmations", value: "\(viewModel.totalAffirmations)", subtitle: "listened", color: Color(hex: "1E90FF"))
                        StatCard(icon: "text.quote", title: "Quotes", value: "\(viewModel.totalQuotes)", subtitle: "viewed", color: Color(hex: "FFD700"))
                    }
                    
                    // Recent Activity
                    if !viewModel.progressRecords.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Activity")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(viewModel.progressRecords.prefix(7), id: \.id) { record in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(record.date, style: .date)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                        Text("\(record.totalActivities) activities")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    HStack(spacing: 12) {
                                        if record.meditationMinutes > 0 {
                                            Label("\(record.meditationMinutes)m", systemImage: "timer")
                                                .font(.caption)
                                        }
                                        if record.affirmationsCount > 0 {
                                            Label("\(record.affirmationsCount)", systemImage: "quote.bubble")
                                                .font(.caption)
                                        }
                                        if record.quotesViewed > 0 {
                                            Label("\(record.quotesViewed)", systemImage: "text.quote")
                                                .font(.caption)
                                        }
                                    }
                                }
                                .padding()
                                .cardStyle()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Progress")
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
            .refreshable {
                viewModel.loadProgress()
            }
        }
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Color(hex: "00CED1"))
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

