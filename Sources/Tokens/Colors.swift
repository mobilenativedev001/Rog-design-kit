// Enterprise-grade color tokens with semantic naming, dark mode and accessibility support
// This file centralizes all color values (palette) and exposes semantic tokens
// for both UIKit (UIColor) and SwiftUI (Color). Avoids hardcoded colors outside
// the palette and provides dynamic colors that respect trait collections and
// accessibility contrast settings.

import Foundation
import UIKit
import SwiftUI

public enum RDSToken {
    public enum Color {
        // MARK: - Public Semantic UIColor tokens
        // UIKit consumers can use e.g. `RDSToken.Color.primary`
        public static var primary: UIColor { dynamicColor(light: Palette.blue500, dark: Palette.blue300, highContrastLight: Palette.blue600, highContrastDark: Palette.blue200) }
        public static var secondary: UIColor { dynamicColor(light: Palette.teal500, dark: Palette.teal300, highContrastLight: Palette.teal600, highContrastDark: Palette.teal200) }
        public static var success: UIColor { dynamicColor(light: Palette.green600, dark: Palette.green400, highContrastLight: Palette.green700, highContrastDark: Palette.green300) }
        public static var warning: UIColor { dynamicColor(light: Palette.orange600, dark: Palette.orange400, highContrastLight: Palette.orange700, highContrastDark: Palette.orange300) }
        public static var error: UIColor { dynamicColor(light: Palette.red600, dark: Palette.red400, highContrastLight: Palette.red700, highContrastDark: Palette.red300) }

        public static var background: UIColor { dynamicColor(light: Palette.gray50, dark: Palette.gray900, highContrastLight: Palette.gray30, highContrastDark: Palette.gray950) }
        public static var surface: UIColor { dynamicColor(light: Palette.white, dark: Palette.gray850, highContrastLight: Palette.gray10, highContrastDark: Palette.gray925) }
        public static var border: UIColor { dynamicColor(light: Palette.gray200, dark: Palette.gray700, highContrastLight: Palette.gray300, highContrastDark: Palette.gray850) }

        public static var textPrimary: UIColor { dynamicColor(light: Palette.gray900, dark: Palette.gray50, highContrastLight: Palette.gray950, highContrastDark: Palette.gray30) }
        public static var textSecondary: UIColor { dynamicColor(light: Palette.gray600, dark: Palette.gray200, highContrastLight: Palette.gray700, highContrastDark: Palette.gray150) }
        public static var textDisabled: UIColor { dynamicColor(light: Palette.gray400, dark: Palette.gray600, highContrastLight: Palette.gray400, highContrastDark: Palette.gray600) }

        // MARK: - SwiftUI-friendly tokens
        public static var primaryColor: SwiftUI.Color { swiftUIColor(fromUIColor: primary) }
        public static var secondaryColor: SwiftUI.Color { swiftUIColor(fromUIColor: secondary) }
        public static var successColor: SwiftUI.Color { swiftUIColor(fromUIColor: success) }
        public static var warningColor: SwiftUI.Color { swiftUIColor(fromUIColor: warning) }
        public static var errorColor: SwiftUI.Color { swiftUIColor(fromUIColor: error) }

        public static var backgroundColor: SwiftUI.Color { swiftUIColor(fromUIColor: background) }
        public static var surfaceColor: SwiftUI.Color { swiftUIColor(fromUIColor: surface) }
        public static var borderColor: SwiftUI.Color { swiftUIColor(fromUIColor: border) }

        public static var textPrimaryColor: SwiftUI.Color { swiftUIColor(fromUIColor: textPrimary) }
        public static var textSecondaryColor: SwiftUI.Color { swiftUIColor(fromUIColor: textSecondary) }
        public static var textDisabledColor: SwiftUI.Color { swiftUIColor(fromUIColor: textDisabled) }


        // MARK: - Helpers

        /// Create a dynamic UIColor that respects user interface style and accessibility contrast.
        private static func dynamicColor(light: UIColor, dark: UIColor, highContrastLight: UIColor? = nil, highContrastDark: UIColor? = nil) -> UIColor {
            return UIColor { trait in
                let prefersHighContrast = UIAccessibility.isDarkerSystemColorsEnabled 
                let isDark = trait.userInterfaceStyle == .dark
                if prefersHighContrast {
                    return isDark ? (highContrastDark ?? dark) : (highContrastLight ?? light)
                }
                return isDark ? dark : light
            }
        }

        private static func swiftUIColor(fromUIColor: UIColor) -> SwiftUI.Color {
            return SwiftUI.Color(fromUIColor)
        }
    }

    // MARK: - Spacing tokens (moved here so Tokens module centralizes tokens in one place)
    public enum Spacing {
        public static let small: CGFloat = 8
        public static let medium: CGFloat = 16
        public static let large: CGFloat = 24
    }
}

// MARK: - Central Palette
private enum Palette {
    // Greys
    static let white = UIColor(hex: "#FFFFFF")
    static let gray10 = UIColor(hex: "#F8F9FA")
    static let gray30 = UIColor(hex: "#F1F3F5")
    static let gray50 = UIColor(hex: "#F0F2F5")
    static let gray150 = UIColor(hex: "#E6E7E9")
    static let gray200 = UIColor(hex: "#D1D5DB")
    static let gray300 = UIColor(hex: "#B8BEC6")
    static let gray400 = UIColor(hex: "#9AA0A6")
    static let gray600 = UIColor(hex: "#6B7178")
    static let gray700 = UIColor(hex: "#4B5157")
    static let gray850 = UIColor(hex: "#2E3337")
    static let gray900 = UIColor(hex: "#121416")
    static let gray925 = UIColor(hex: "#0B0C0D")
    static let gray950 = UIColor(hex: "#060606")

    // Primary palette (blue family)
    static let blue200 = UIColor(hex: "#90CAF9")
    static let blue300 = UIColor(hex: "#42A5F5")
    static let blue500 = UIColor(hex: "#0B66D1")
    static let blue600 = UIColor(hex: "#0956B0")

    // Secondary (teal)
    static let teal200 = UIColor(hex: "#88E0D6")
    static let teal300 = UIColor(hex: "#4DD6C8")
    static let teal500 = UIColor(hex: "#008F80")
    static let teal600 = UIColor(hex: "#007A6B")

    // Success (green)
    static let green300 = UIColor(hex: "#66BB6A")
    static let green400 = UIColor(hex: "#43A047")
    static let green600 = UIColor(hex: "#2E7D32")
    static let green700 = UIColor(hex: "#256026")

    // Warning (orange)
    static let orange300 = UIColor(hex: "#FFA726")
    static let orange400 = UIColor(hex: "#FB8C00")
    static let orange600 = UIColor(hex: "#EF6C00")
    static let orange700 = UIColor(hex: "#E65100")

    // Error (red)
    static let red300 = UIColor(hex: "#EF5350")
    static let red400 = UIColor(hex: "#E53935")
    static let red600 = UIColor(hex: "#C62828")
    static let red700 = UIColor(hex: "#B71C1C")
}

// MARK: - UIColor helpers

extension UIColor {
    /// Initialize from hex string like "#RRGGBB" or "RRGGBB".
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexString.hasPrefix("#") { hexString.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
