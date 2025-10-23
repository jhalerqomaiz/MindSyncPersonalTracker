//  MeditateViewModel.swift

import Foundation
import SwiftData
internal import Combine

@MainActor
final class MeditateViewModel: ObservableObject {
    @Published var meditations: [Meditation] = []
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var totalTime: TimeInterval = 0
    @Published var selectedMeditation: Meditation?
    
    private var modelContext: ModelContext?
    private var timer: Timer?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadMeditations()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        loadMeditations()
    }
    
    func loadMeditations() {
        guard let context = modelContext else {
            meditations = Meditation.sampleMeditations
            return
        }
        
        let descriptor = FetchDescriptor<Meditation>(sortBy: [SortDescriptor(\.createdAt, order: .reverse)])
        do {
            meditations = try context.fetch(descriptor)
            if meditations.isEmpty {
                for meditation in Meditation.sampleMeditations {
                    context.insert(meditation)
                }
                try context.save()
                meditations = try context.fetch(descriptor)
            }
        } catch {
            print("Error loading meditations: \(error)")
            meditations = Meditation.sampleMeditations
        }
    }
    
    func startMeditation(_ meditation: Meditation) {
        selectedMeditation = meditation
        isPlaying = true
        currentTime = 0
        totalTime = TimeInterval(meditation.durationMinutes * 60)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.currentTime += 1
                if self.currentTime >= self.totalTime {
                    self.completeMeditation()
                }
            }
        }
        
        // Update meditation stats
        meditation.playCount += 1
        meditation.lastPlayedAt = Date()
        if let context = modelContext {
            try? context.save()
        }
    }
    
    func pauseMeditation() {
        isPlaying = false
        timer?.invalidate()
        timer = nil
    }
    
    func stopMeditation() {
        pauseMeditation()
        currentTime = 0
        selectedMeditation = nil
    }
    
    func completeMeditation() {
        pauseMeditation()
        
        // Update progress
        if let meditation = selectedMeditation, let context = modelContext {
            updateProgress(minutes: meditation.durationMinutes, context: context)
        }
        
        currentTime = 0
        selectedMeditation = nil
    }
    
    private func updateProgress(minutes: Int, context: ModelContext) {
        let calendar = Calendar.current
        let today = Date()
        let startOfDay = calendar.startOfDay(for: today)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }

        let descriptor = FetchDescriptor<ProgressRecord>(
            predicate: #Predicate { record in
                record.date >= startOfDay && record.date < endOfDay
            }
        )
        
        do {
            let records = try context.fetch(descriptor)
            if let todayRecord = records.first {
                todayRecord.meditationMinutes += minutes
            } else {
                let newRecord = ProgressRecord(date: today, meditationMinutes: minutes)
                context.insert(newRecord)
            }
            try context.save()
        } catch {
            print("Error updating progress: \(error)")
        }
    }
    
    var currentTimeString: String {
        let minutes = Int(currentTime) / 60
        let seconds = Int(currentTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var totalTimeString: String {
        let minutes = Int(totalTime) / 60
        let seconds = Int(totalTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return currentTime / totalTime
    }
    
    deinit {
        timer?.invalidate()
    }
}

