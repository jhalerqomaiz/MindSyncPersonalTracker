//  Colors.swift

import SwiftUI

extension Color {
    static let appPrimary = Color("PrimaryColor", bundle: nil).withFallback(Color(hex: "00CED1"))
    static let appSecondary = Color("SecondaryColor", bundle: nil).withFallback(Color(hex: "FFD700"))
    static let appAccent = Color("AccentColor", bundle: nil).withFallback(Color(hex: "1E90FF"))
    func withFallback(_ fallback: Color) -> Color { return self }
}

extension LinearGradient {
    static let primaryGradient = LinearGradient(colors: [Color(hex: "00CED1"), Color(hex: "1E90FF")], startPoint: .leading, endPoint: .trailing)
    static let accentGradient = LinearGradient(colors: [Color(hex: "FFD700"), Color(hex: "FFA500")], startPoint: .topLeading, endPoint: .bottomTrailing)
}

