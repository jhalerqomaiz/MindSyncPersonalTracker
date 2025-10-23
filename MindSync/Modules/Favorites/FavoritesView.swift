//  FavoritesView.swift

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: FavoritesViewModel
    
    init(modelContext: ModelContext? = nil) {
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.favoriteAffirmations.isEmpty && viewModel.favoriteQuotes.isEmpty {
                        emptyState
                    } else {
                        // Favorite Affirmations
                        if !viewModel.favoriteAffirmations.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Favorite Affirmations")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(viewModel.favoriteAffirmations, id: \.id) { affirmation in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(affirmation.text)
                                                .font(.body)
                                            Text(affirmation.category)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Button(action: {
                                            viewModel.removeFavoriteAffirmation(affirmation)
                                        }) {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                    .cardStyle()
                                }
                            }
                        }
                        
                        // Favorite Quotes
                        if !viewModel.favoriteQuotes.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Favorite Quotes")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .padding(.top, 8)
                                
                                ForEach(viewModel.favoriteQuotes, id: \.id) { quote in
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(quote.text)
                                                .font(.body)
                                            Text("— \(quote.author)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Button(action: {
                                            viewModel.removeFavoriteQuote(quote)
                                        }) {
                                            Image(systemName: "heart.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                    .cardStyle()
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Favorites")
            .onAppear {
                viewModel.setModelContext(modelContext)
                viewModel.loadFavorites()
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("No Favorites Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the heart icon on affirmations\nand quotes to save them here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 60)
    }
}

