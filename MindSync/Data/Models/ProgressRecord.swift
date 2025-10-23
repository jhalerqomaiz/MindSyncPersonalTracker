//
//  ProgressRecord.swift
//  MeditationTracker
//

import Foundation
import SwiftData

@Model
final class ProgressRecord {
    @Attribute(.unique) var id: UUID
    var date: Date
    var meditationMinutes: Int
    var affirmationsCount: Int
    var quotesViewed: Int
    var createdAt: Date
    
    init(id: UUID = UUID(), date: Date = Date(), meditationMinutes: Int = 0, affirmationsCount: Int = 0, quotesViewed: Int = 0, createdAt: Date = Date()) {
        self.id = id
        self.date = date
        self.meditationMinutes = meditationMinutes
        self.affirmationsCount = affirmationsCount
        self.quotesViewed = quotesViewed
        self.createdAt = createdAt
    }
    
    var totalActivities: Int {
        meditationMinutes + affirmationsCount + quotesViewed
    }
    
    static func generateSampleRecords(days: Int = 30) -> [ProgressRecord] {
        var records: [ProgressRecord] = []
        let calendar = Calendar.current
        for dayOffset in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) else { continue }
            let record = ProgressRecord(date: date, meditationMinutes: Int.random(in: 0...30), affirmationsCount: Int.random(in: 0...10), quotesViewed: Int.random(in: 0...5))
            records.append(record)
        }
        return records
    }
}

