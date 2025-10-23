//  QuotesView.swift

import SwiftUI
import SwiftData

struct QuotesView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: QuotesViewModel
    
    init(modelContext: ModelContext? = nil) {
        _viewModel = StateObject(wrappedValue: QuotesViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Quote of the Day
                    if let quote = viewModel.quoteOfTheDay {
                        VStack(spacing: 16) {
                            Image(systemName: "quote.opening")
                                .font(.system(size: 40))
                                .foregroundColor(Color(hex: "00CED1").opacity(0.5))
                            
                            Text(quote.text)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                            
                            Text("— \(quote.author)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            HStack(spacing: 16) {
                                Button(action: {
                                    viewModel.toggleFavorite(quote)
                                }) {
                                    HStack {
                                        Image(systemName: quote.isFavorite ? "heart.fill" : "heart")
                                        Text(quote.isFavorite ? "Saved" : "Save")
                                    }
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(quote.isFavorite ? .red : Color(hex: "00CED1"))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(quote.isFavorite ? Color.red : Color(hex: "00CED1"), lineWidth: 2)
                                    )
                                }
                                
                                Button("New Quote") {
                                    viewModel.refreshQuote()
                                }
                                .buttonStyle(PrimaryButtonStyle())
                            }
                        }
                        .padding()
                        .cardStyle()
                    }
                    
                    // All Quotes
                    Text("All Quotes")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(viewModel.quotes, id: \.id) { quote in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(quote.text)
                                    .font(.body)
                                    .lineLimit(nil)
                                Text("— \(quote.author)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                viewModel.toggleFavorite(quote)
                            }) {
                                Image(systemName: quote.isFavorite ? "heart.fill" : "heart")
                                    .font(.title3)
                                    .foregroundColor(quote.isFavorite ? .red : .gray)
                            }
                        }
                        .padding()
                        .cardStyle()
                    }
                }
                .padding()
            }
            .navigationTitle("Quotes")
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
        }
    }
}

