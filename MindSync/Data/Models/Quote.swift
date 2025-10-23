//
//  Quote.swift
//  MeditationTracker
//

import Foundation
import SwiftData

@Model
final class Quote {
    @Attribute(.unique) var id: UUID
    var text: String
    var author: String
    var category: String
    var createdAt: Date
    var isFavorite: Bool
    var shownDate: Date?
    
    init(id: UUID = UUID(), text: String, author: String, category: String = "Inspiration", createdAt: Date = Date(), isFavorite: Bool = false, shownDate: Date? = nil) {
        self.id = id
        self.text = text
        self.author = author
        self.category = category
        self.createdAt = createdAt
        self.isFavorite = isFavorite
        self.shownDate = shownDate
    }
    
    static var sampleQuotes: [Quote] {
        [
            Quote(text: "The mind is everything. What you think you become.", author: "Buddha"),
            Quote(text: "In the middle of difficulty lies opportunity.", author: "Albert Einstein"),
            Quote(text: "Peace comes from within. Do not seek it without.", author: "Buddha"),
            Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
            Quote(text: "Happiness is not something ready made. It comes from your own actions.", author: "Dalai Lama")
        ]
    }
}

