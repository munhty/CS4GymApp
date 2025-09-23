//
//  DesignSystem.swift
//  CS4GymApp
//
//  Created by AI Assistant on 9/11/25.
//

import SwiftUI

enum AppColors {
    static let primary = Color(hex: "#2563EB")
    static let secondary = Color(hex: "#22C55E")
    static let accent = Color(hex: "#F97316")
    static let backgroundLight = Color(hex: "#F9FAFB")
    static let backgroundDark = Color(hex: "#111827")
    static let surface = Color(hex: "#FFFFFF")
    static let textPrimary = Color(hex: "#1F2937")
    static let textSecondary = Color(hex: "#6B7280")
    static let error = Color(hex: "#EF4444")
    static let success = Color(hex: "#4ADE80")
}

enum AppTypography {
    static func display(_ weight: Font.Weight = .bold) -> Font { .system(size: 36, weight: weight, design: .rounded) }
    static func headline(_ weight: Font.Weight = .semibold) -> Font { .system(size: 24, weight: weight, design: .rounded) }
    static func subtitle(_ weight: Font.Weight = .medium) -> Font { .system(size: 18, weight: weight, design: .rounded) }
    static func body(_ weight: Font.Weight = .regular) -> Font { .system(size: 16, weight: weight, design: .rounded) }
    static func small(_ weight: Font.Weight = .regular) -> Font { .system(size: 14, weight: weight, design: .rounded) }
    static func button(_ weight: Font.Weight = .semibold) -> Font { .system(size: 16, weight: weight, design: .rounded) }
}

enum AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
}

extension Color {
    init(hex: String) {
        var hexString = hex
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        let r, g, b: UInt64
        if hexString.count == 6 {
            r = (int >> 16) & 0xFF
            g = (int >> 8) & 0xFF
            b = int & 0xFF
            self = Color(
                .sRGB,
                red: Double(r) / 255.0,
                green: Double(g) / 255.0,
                blue: Double(b) / 255.0,
                opacity: 1
            )
        } else {
            self = Color.clear
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.button())
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(AppColors.primary)
            .cornerRadius(12)
            .opacity(configuration.isPressed ? 0.9 : 1)
    }
}

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.surface)
                    .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 8)
            )
    }
}

extension View {
    func cardBackground() -> some View { modifier(CardBackground()) }
}


