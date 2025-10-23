//  QuotesViewModel.swift

import Foundation
import SwiftData
internal import Combine

@MainActor
final class QuotesViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var quoteOfTheDay: Quote?
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadQuotes()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadQuotes()
    }
    
    func loadQuotes() {
        guard let context = modelContext else {
            quotes = Quote.sampleQuotes
            quoteOfTheDay = quotes.first
            return
        }
        
        let descriptor = FetchDescriptor<Quote>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        do {
            quotes = try context.fetch(descriptor)
            if quotes.isEmpty {
                for quote in Quote.sampleQuotes {
                    context.insert(quote)
                }
                try context.save()
                quotes = try context.fetch(descriptor)
            }
            selectQuoteOfTheDay()
        } catch {
            print("Error loading quotes: \(error)")
            quotes = Quote.sampleQuotes
            quoteOfTheDay = quotes.first
        }
    }
    
    func selectQuoteOfTheDay() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let todayQuote = quotes.first(where: { quote in
            guard let shownDate = quote.shownDate else { return false }
            return calendar.isDate(shownDate, inSameDayAs: today)
        }) {
            quoteOfTheDay = todayQuote
        } else {
            if let randomQuote = quotes.randomElement() {
                randomQuote.shownDate = today
                quoteOfTheDay = randomQuote
                if let context = modelContext {
                    try? context.save()
                }
            }
        }
    }
    
    func refreshQuote() {
        if let randomQuote = quotes.randomElement() {
            randomQuote.shownDate = Date()
            quoteOfTheDay = randomQuote
            if let context = modelContext {
                try? context.save()
            }
        }
    }
    
    func toggleFavorite(_ quote: Quote) {
        quote.isFavorite.toggle()
        
        if let context = modelContext {
            do {
                try context.save()
                objectWillChange.send()
            } catch {
                print("Error saving favorite: \(error)")
            }
        }
    }
}

