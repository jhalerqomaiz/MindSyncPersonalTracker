//
//  Affirmation.swift
//  MeditationTracker
//

import Foundation
import SwiftData

@Model
final class Affirmation {
    // MARK: - Core Properties
    @Attribute(.unique) var id: UUID
    var text: String
    var category: String
    var createdAt: Date
    var isFavorite: Bool
    var playCount: Int
    var lastPlayedAt: Date?
    
    // MARK: - Derived Data (computed values are optional)
    var displayCategory: String {
        category.isEmpty ? "General" : category
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }
    
    // MARK: - Initializer
    init(
        id: UUID = UUID(),
        text: String,
        category: String = "General",
        createdAt: Date = Date(),
        isFavorite: Bool = false,
        playCount: Int = 0,
        lastPlayedAt: Date? = nil
    ) {
        self.id = id
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.category = category.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "General" : category
        self.createdAt = createdAt
        self.isFavorite = isFavorite
        self.playCount = playCount
        self.lastPlayedAt = lastPlayedAt
    }
    
    // MARK: - Behavior Methods
    func toggleFavorite() {
        isFavorite.toggle()
    }
    
    func markPlayed() {
        playCount += 1
        lastPlayedAt = Date()
    }
    
    // MARK: - Sample Data
    static var sampleAffirmations: [Affirmation] {
        [
            Affirmation(text: "I am calm, peaceful, and centered", category: "Peace"),
            Affirmation(text: "I choose to be happy and grateful today", category: "Gratitude"),
            Affirmation(text: "I am confident and capable in all that I do", category: "Confidence"),
            Affirmation(text: "I attract positive energy and abundance", category: "Abundance"),
            Affirmation(text: "I am worthy of love and respect", category: "Self-Love"),
            Affirmation(text: "Every day I am growing and improving", category: "Growth"),
            Affirmation(text: "I trust the process of life and flow with ease", category: "Trust"),
            Affirmation(text: "My thoughts create my reality, and I choose positivity", category: "Mindset")
        ]
    }
}


