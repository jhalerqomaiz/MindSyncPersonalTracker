//  ProgressViewModel.swift

import Foundation
import SwiftData
internal import Combine

@MainActor
final class ProgressViewModel: ObservableObject {
    @Published var progressRecords: [ProgressRecord] = []
    @Published var todayRecord: ProgressRecord?
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadProgress()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadProgress()
    }
    
    func loadProgress() {
        guard let context = modelContext else {
            progressRecords = ProgressRecord.generateSampleRecords(days: 7)
            updateTodayRecord()
            return
        }
        
        let calendar = Calendar.current
        let endDate = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -30, to: endDate) else { return }
        
        let descriptor = FetchDescriptor<ProgressRecord>(
            predicate: #Predicate { record in
                record.date >= startDate && record.date <= endDate
            },
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            progressRecords = try context.fetch(descriptor)
            updateTodayRecord()
        } catch {
            print("Error loading progress: \(error)")
            progressRecords = []
        }
    }
    
    private func updateTodayRecord() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        todayRecord = progressRecords.first(where: { calendar.isDate($0.date, inSameDayAs: today) })
    }
    
    var totalMinutes: Int {
        progressRecords.reduce(0) { $0 + $1.meditationMinutes }
    }
    
    var totalAffirmations: Int {
        progressRecords.reduce(0) { $0 + $1.affirmationsCount }
    }
    
    var totalQuotes: Int {
        progressRecords.reduce(0) { $0 + $1.quotesViewed }
    }
    
    var currentStreak: Int {
        guard !progressRecords.isEmpty else { return 0 }
        let calendar = Calendar.current
        var streak = 0
        var currentDate = Date()
        let sortedRecords = progressRecords.sorted { $0.date > $1.date }
        
        for record in sortedRecords {
            if calendar.isDate(record.date, inSameDayAs: currentDate) {
                if record.totalActivities > 0 {
                    streak += 1
                    guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else { break }
                    currentDate = previousDay
                } else {
                    break
                }
            } else {
                break
            }
        }
        return streak
    }
}

