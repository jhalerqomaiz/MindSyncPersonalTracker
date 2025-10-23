//  MeditateView.swift

import SwiftUI
import SwiftData

struct MeditateView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: MeditateViewModel
    @State private var showTimer = false
    
    init(modelContext: ModelContext? = nil) {
        _viewModel = StateObject(wrappedValue: MeditateViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if showTimer, let meditation = viewModel.selectedMeditation {
                    timerView(meditation: meditation)
                } else {
                    meditationListView
                }
            }
            .navigationTitle("Meditate")
            .onAppear {
                viewModel.setModelContext(modelContext)
            }
        }
    }
    
    private var meditationListView: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.meditations, id: \.id) { meditation in
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "sparkles")
                                .font(.title2)
                                .foregroundColor(Color(hex: "00CED1"))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(meditation.title)
                                    .font(.headline)
                                Text(meditation.category)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(meditation.durationMinutes) min")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: "00CED1"))
                        }
                        
                        Text(meditation.descriptionText)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            viewModel.startMeditation(meditation)
                            showTimer = true
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Start Meditation")
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        
                        if meditation.playCount > 0 {
                            Text("Played \(meditation.playCount) times")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .cardStyle()
                }
            }
            .padding()
        }
    }
    
    private func timerView(meditation: Meditation) -> some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text(meditation.title)
                .font(.title)
                .fontWeight(.bold)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                    .frame(width: 250, height: 250)
                
                Circle()
                    .trim(from: 0, to: viewModel.progress)
                    .stroke(
                        LinearGradient.primaryGradient,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 250, height: 250)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: viewModel.progress)
                
                VStack(spacing: 8) {
                    Text(viewModel.currentTimeString)
                        .font(.system(size: 48, weight: .bold))
                    Text("/ \(viewModel.totalTimeString)")
                        .font(.system(size: 18))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 32) {
                Button(action: {
                    viewModel.stopMeditation()
                    showTimer = false
                }) {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.red)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    if viewModel.isPlaying {
                        viewModel.pauseMeditation()
                    } else {
                        viewModel.startMeditation(meditation)
                    }
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .frame(width: 80, height: 80)
                        .background(LinearGradient.primaryGradient)
                        .clipShape(Circle())
                }
            }
            .padding(.bottom, 40)
        }
        .padding()
        .onChange(of: viewModel.selectedMeditation) { newValue in
            if newValue == nil {
                showTimer = false
            }
        }
    }
}

