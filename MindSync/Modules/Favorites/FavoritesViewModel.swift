//  FavoritesViewModel.swift

import Foundation
import SwiftData
internal import Combine

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favoriteAffirmations: [Affirmation] = []
    @Published var favoriteQuotes: [Quote] = []
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadFavorites()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadFavorites()
    }
    
    func loadFavorites() {
        guard let context = modelContext else {
            favoriteAffirmations = Affirmation.sampleAffirmations.filter { $0.isFavorite }
            favoriteQuotes = Quote.sampleQuotes.filter { $0.isFavorite }
            return
        }
        
        let affirmationDescriptor = FetchDescriptor<Affirmation>(
            predicate: #Predicate { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        let quoteDescriptor = FetchDescriptor<Quote>(
            predicate: #Predicate { $0.isFavorite == true },
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        
        do {
            favoriteAffirmations = try context.fetch(affirmationDescriptor)
            favoriteQuotes = try context.fetch(quoteDescriptor)
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
    
    func removeFavoriteAffirmation(_ affirmation: Affirmation) {
        affirmation.isFavorite = false
        if let context = modelContext {
            try? context.save()
            loadFavorites()
        }
    }
    
    func removeFavoriteQuote(_ quote: Quote) {
        quote.isFavorite = false
        if let context = modelContext {
            try? context.save()
            loadFavorites()
        }
    }
}

