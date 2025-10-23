//  AffirmationsViewModel.swift

import Foundation
import SwiftData
internal import Combine

@MainActor
final class AffirmationsViewModel: ObservableObject {
    @Published var affirmations: [Affirmation] = []
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadAffirmations()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadAffirmations()
    }
    
    func loadAffirmations() {
        guard let context = modelContext else {
            affirmations = Affirmation.sampleAffirmations
            return
        }
        
        let descriptor = FetchDescriptor<Affirmation>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        do {
            affirmations = try context.fetch(descriptor)
            if affirmations.isEmpty {
                for affirmation in Affirmation.sampleAffirmations {
                    context.insert(affirmation)
                }
                try context.save()
                affirmations = try context.fetch(descriptor)
            }
        } catch {
            print("Error loading affirmations: \(error)")
            affirmations = Affirmation.sampleAffirmations
        }
    }
    
    func toggleFavorite(_ affirmation: Affirmation) {
        affirmation.isFavorite.toggle()
        saveContext()
    }
    
    func addAffirmation(text: String, category: String) {
        guard let context = modelContext else { return }
        let newAffirmation = Affirmation(
            text: text,
            category: category,
            createdAt: Date(),
            isFavorite: false
        )
        context.insert(newAffirmation)
        saveContext()
        loadAffirmations()
    }
    
    private func saveContext() {
        guard let context = modelContext else { return }
        do {
            try context.save()
            objectWillChange.send()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
