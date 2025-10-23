//  AffirmationsView.swift

//  AffirmationsView.swift

import SwiftUI
import SwiftData

struct AffirmationsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: AffirmationsViewModel
    @State private var showAddSheet = false
    
    init(modelContext: ModelContext? = nil) {
        _viewModel = StateObject(wrappedValue: AffirmationsViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.affirmations, id: \.id) { affirmation in
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(affirmation.text)
                                    .font(.body)
                                    .lineLimit(nil)
                                Text(affirmation.category)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                viewModel.toggleFavorite(affirmation)
                            }) {
                                Image(systemName: affirmation.isFavorite ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(affirmation.isFavorite ? .red : .gray)
                            }
                        }
                        .padding()
                        .cardStyle()
                    }
                }
                .padding()
            }
            .navigationTitle("Affirmations")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
            .sheet(isPresented: $showAddSheet) {
                AddAffirmationView { text, category in
                    viewModel.addAffirmation(text: text, category: category)
                    showAddSheet = false
                }
                .presentationDetents([.medium])
            }
        }
    }
}
