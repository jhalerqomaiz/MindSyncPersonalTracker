//
//  Meditation.swift
//  MeditationTracker
//

import Foundation
import SwiftData

@Model
final class Meditation {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var durationMinutes: Int
    var descriptionText: String
    var audioFileName: String?
    var category: String
    var createdAt: Date
    var lastPlayedAt: Date?
    var playCount: Int
    
    init(
        id: UUID = UUID(),
        title: String,
        durationMinutes: Int,
        descriptionText: String,
        audioFileName: String? = nil,
        category: String = "General",
        createdAt: Date = Date(),
        lastPlayedAt: Date? = nil,
        playCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.durationMinutes = durationMinutes
        self.descriptionText = descriptionText
        self.audioFileName = audioFileName
        self.category = category
        self.createdAt = createdAt
        self.lastPlayedAt = lastPlayedAt
        self.playCount = playCount
    }
    
    static var sampleMeditations: [Meditation] {
        [
            Meditation(title: "Morning Calm", durationMinutes: 10, descriptionText: "Start your day with peaceful meditation", category: "Morning"),
            Meditation(title: "Deep Relaxation", durationMinutes: 15, descriptionText: "Release tension and find inner peace", category: "Relaxation"),
            Meditation(title: "Focus & Clarity", durationMinutes: 20, descriptionText: "Enhance your concentration", category: "Focus"),
            Meditation(title: "Evening Reflection", durationMinutes: 12, descriptionText: "Reflect on your day", category: "Evening")
        ]
    }
}

