//
//  AddAffirmation.swift
//  MindSync
//
//  Created by b on 19.10.2025.
//

import SwiftUI

struct AddAffirmationView: View {
    @State private var text: String = ""
    @State private var category: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var onSave: (String, String) -> Void
    
    var body: some View {
        ZStack {
            // Фоновый градиент для спокойного ощущения
            LinearGradient(
                colors: [
                    Color("BackgroundSoft").opacity(0.9),
                    Color("BackgroundSoft").opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Add New Affirmation")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.top, 10)
                
                // Поле ввода текста аффирмации
                VStack(alignment: .leading, spacing: 6) {
                    Text("Affirmation")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("Type your affirmation...", text: $text, axis: .vertical)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                        )
                        .lineLimit(3...6)
                }
                
                // Поле ввода категории
                VStack(alignment: .leading, spacing: 6) {
                    Text("Category (optional)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    TextField("e.g. Motivation, Calm, Gratitude", text: $category)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                        )
                }
                
                Spacer()
                
                // Кнопка сохранения
                Button(action: {
                    guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                    onSave(text, category.isEmpty ? "General" : category)
                    dismiss()
                }) {
                    Text("Save Affirmation")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color("AccentColor"), Color("GoldAccent")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .shadow(color: Color("AccentColor").opacity(0.4), radius: 6, x: 0, y: 3)
                        .padding(.bottom, 10)
                }
                .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(text.trimmingCharacters(in: .whitespaces).isEmpty ? 0.6 : 1.0)
            }
            .padding(24)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.easeOut(duration: 0.25), value: text)
        }
    }
}
