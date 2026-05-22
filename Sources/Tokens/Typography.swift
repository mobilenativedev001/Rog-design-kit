// Typography.swift
// Rogers iOS Design System — Tokens module
//
// Defines the complete Rogers / Chatr type scale as `RDSToken.Typography` constants.
// Each entry is a `DSTextStyle` value that carries font name, size, line height,
// letter spacing, and the corresponding `UIFont.TextStyle` for Dynamic Type scaling.
//
// Design token sources (Figma Chatr-POC):
//   --ds-title-3-*   → node 5:441  (TedNext-Bold 30/36 #5D2894)
//   --ds-body-r-*    → node 5:395  (TedNext-Medium 16/24 #1F1F1F)
//   UILabel snippet  → hero body   (TedNext-Bold 16/36 white)
//
// Usage:
//   // SwiftUI
//   Text("Sign in").font(RDSToken.Typography.title3.font)
//
//   // UIKit
//   label.font = RDSToken.Typography.title3.scaledUIFont
//   label.attributedText = RDSToken.Typography.heroBody
//       .attributedString("Now you make the call...", textColor: .white)

import Foundation
import UIKit
import SwiftUI

// MARK: - DSTextStyle

/// A value type that encapsulates every measurable property of a text style.
///
/// Fonts are loaded by name ("TedNext-Bold", "TedNext-Medium") with automatic
/// fallback to the system font at the equivalent weight.  Dynamic Type scaling
/// is applied via `UIFontMetrics` so all sizes respect the user's accessibility
/// size preference.
public struct DSTextStyle {

    // MARK: Raw Figma-sourced values

    /// The PostScript name of the desired typeface.
    public let fontName: String

    /// Design-canvas font size in points.
    public let size: CGFloat

    /// Total line height in points (baseline-to-baseline).
    /// Maps to `--ds-*-line-height` in the Figma token system.
    public let lineHeight: CGFloat

    /// Inter-character spacing in points (0 = no extra tracking).
    /// Maps to `--ds-*-letter-spacing`.
    public let letterSpacing: CGFloat

    /// The closest `UIFont.TextStyle` semantic — used by `UIFontMetrics` for
    /// proper Dynamic Type scaling.
    public let uiFontTextStyle: UIFont.TextStyle

    /// When `true`, text is rendered in `.uppercased()` form (e.g. Overline).
    public let isUppercased: Bool

    // MARK: Init

    public init(
        fontName: String,
        size: CGFloat,
        lineHeight: CGFloat,
        letterSpacing: CGFloat = 0,
        uiFontTextStyle: UIFont.TextStyle = .body,
        isUppercased: Bool = false
    ) {
        self.fontName        = fontName
        self.size            = size
        self.lineHeight      = lineHeight
        self.letterSpacing   = letterSpacing
        self.uiFontTextStyle = uiFontTextStyle
        self.isUppercased    = isUppercased
    }

    // MARK: - UIFont

    /// Base (unscaled) UIFont — uses the named typeface with system-weight fallback.
    public var baseUIFont: UIFont {
        if let font = UIFont(name: fontName, size: size) { return font }
        // Fallback: map known font names to system weights
        let weight: UIFont.Weight = fontName.lowercased().contains("bold") ? .bold : .medium
        return UIFont.systemFont(ofSize: size, weight: weight)
    }

    /// Dynamic-Type-scaled UIFont. Respects the user's text-size accessibility setting.
    public var scaledUIFont: UIFont {
        UIFontMetrics(forTextStyle: uiFontTextStyle).scaledFont(for: baseUIFont)
    }

    // MARK: - SwiftUI Font

    /// Dynamic-Type-aware SwiftUI `Font` wrapping `scaledUIFont`.
    public var font: Font {
        Font(scaledUIFont)
    }

    // MARK: - Line spacing helpers

    /// Extra inter-line spacing for SwiftUI's `.lineSpacing()` modifier.
    ///
    /// SwiftUI adds this value *between* lines (not as the total line height),
    /// so the total line height becomes `font.lineHeight + lineSpacing`.
    /// Calculated as `max(0, lineHeight − baseUIFont.lineHeight)`.
    public var swiftUILineSpacing: CGFloat {
        max(0, lineHeight - baseUIFont.lineHeight)
    }

    // MARK: - UIKit attributed string

    /// Returns an `NSAttributedString` with the correct paragraph style for
    /// pixel-perfect line-height reproduction in UIKit.
    ///
    /// The paragraph style uses explicit `minimumLineHeight`/`maximumLineHeight`
    /// rather than `lineHeightMultiple`, which is the correct way to achieve a
    /// fixed absolute line height.  A `baselineOffset` is added to vertically
    /// centre glyphs within the taller line box.
    ///
    ///     label.attributedText = RDSToken.Typography.heroBody
    ///         .attributedString("Now you make the call…", textColor: .white)
    public func attributedString(
        _ text: String,
        textColor: UIColor,
        alignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> NSAttributedString {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.minimumLineHeight = lineHeight
        paraStyle.maximumLineHeight = lineHeight
        paraStyle.alignment         = alignment
        paraStyle.lineBreakMode     = lineBreakMode
        // Centre glyphs vertically within the taller line box.
        let baselineOffset = (lineHeight - scaledUIFont.lineHeight) / 4

        var attributes: [NSAttributedString.Key: Any] = [
            .font:           scaledUIFont,
            .foregroundColor: textColor,
            .paragraphStyle: paraStyle,
        ]
        if abs(baselineOffset) > 0.01 {
            attributes[.baselineOffset] = baselineOffset
        }
        if abs(letterSpacing) > 0.01 {
            attributes[.kern] = letterSpacing
        }

        let str = isUppercased ? text.uppercased() : text
        return NSAttributedString(string: str, attributes: attributes)
    }

    /// Convenience: returns the `[NSAttributedString.Key: Any]` dictionary only.
    public func attributedStringAttributes(
        textColor: UIColor,
        alignment: NSTextAlignment = .natural,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> [NSAttributedString.Key: Any] {
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.minimumLineHeight = lineHeight
        paraStyle.maximumLineHeight = lineHeight
        paraStyle.alignment         = alignment
        paraStyle.lineBreakMode     = lineBreakMode
        let baselineOffset = (lineHeight - scaledUIFont.lineHeight) / 4

        var attributes: [NSAttributedString.Key: Any] = [
            .font:           scaledUIFont,
            .foregroundColor: textColor,
            .paragraphStyle: paraStyle,
        ]
        if abs(baselineOffset) > 0.01 { attributes[.baselineOffset] = baselineOffset }
        if abs(letterSpacing) > 0.01  { attributes[.kern]           = letterSpacing  }
        return attributes
    }
}

// MARK: - RDSToken.Typography

public extension RDSToken {

    /// The complete Rogers design-system type scale.
    ///
    /// Naming mirrors the Figma token system (`--ds-title-3-*`, `--ds-body-r-*`, etc.).
    /// All sizes are Dynamic Type aware — they scale with the user's accessibility
    /// text-size preference via `UIFontMetrics`.
    ///
    ///     // SwiftUI
    ///     DSLabel("Sign in", style: .title3, color: .brand)
    ///
    ///     // UIKit
    ///     label.attributedText = RDSToken.Typography.title3
    ///         .attributedString("Sign in", textColor: RDSToken.Color.brandText)
    enum Typography {

        // MARK: Display (hero / marketing)

        /// Largest display style — splash screens, hero banners.
        /// TedNext-Bold 48/56 pt.
        public static let display = DSTextStyle(
            fontName: "TedNext-Bold",
            size: 48,
            lineHeight: 56,
            uiFontTextStyle: .largeTitle
        )

        // MARK: Title scale

        /// TedNext-Bold 36/44 pt.
        public static let title1 = DSTextStyle(
            fontName: "TedNext-Bold",
            size: 36,
            lineHeight: 44,
            uiFontTextStyle: .largeTitle
        )

        /// TedNext-Bold 32/40 pt.
        public static let title2 = DSTextStyle(
            fontName: "TedNext-Bold",
            size: 32,
            lineHeight: 40,
            uiFontTextStyle: .title1
        )

        /// TedNext-Bold 30/36 pt — Figma `--ds-title-3-*` (node 5:441).
        /// Brand purple `#5D2894` is the canonical text colour for this style.
        public static let title3 = DSTextStyle(
            fontName: "TedNext-Bold",
            size: 30,
            lineHeight: 36,
            uiFontTextStyle: .title2
        )

        /// TedNext-Bold 24/32 pt.
        public static let title4 = DSTextStyle(
            fontName: "TedNext-Bold",
            size: 24,
            lineHeight: 32,
            uiFontTextStyle: .title3
        )

        // MARK: Body scale

        /// TedNext-Medium 18/28 pt.
        public static let bodyLarge = DSTextStyle(
            fontName: "TedNext-Medium",
            size: 18,
            lineHeight: 28,
            uiFontTextStyle: .body
        )

        /// TedNext-Medium 16/24 pt — Figma `--ds-body-r-*` (node 5:395).
        public static let bodyRegular = DSTextStyle(
            fontName: "TedNext-Medium",
            size: 16,
            lineHeight: 24,
            uiFontTextStyle: .body
        )

        /// TedNext-Bold 16/24 pt — body text at bold weight.
        public static let bodyBold = DSTextStyle(
            fontName: "TedNext-Bold",
            size: 16,
            lineHeight: 24,
            uiFontTextStyle: .body
        )

        /// TedNext-Bold 16/36 pt — hero / banner body text with generous line
        /// height for airy layout on coloured or image backgrounds.
        ///
        /// Source: UILabel snippet —
        ///   `UIFont(name: "TedNext-Bold", size: 16)`,
        ///   paragraph style `// Line height: 36 pt`.
        ///   (Note: the exported `lineHeightMultiple: 0.98` is a tool artefact;
        ///   the correct implementation uses `minimumLineHeight/maximumLineHeight = 36`.)
        public static let heroBody = DSTextStyle(
            fontName: "TedNext-Bold",
            size: 16,
            lineHeight: 36,
            uiFontTextStyle: .body
        )

        /// TedNext-Medium 14/20 pt.
        public static let bodySmall = DSTextStyle(
            fontName: "TedNext-Medium",
            size: 14,
            lineHeight: 20,
            uiFontTextStyle: .subheadline
        )

        // MARK: Utility scale

        /// TedNext-Medium 12/16 pt — inline hints, badges, timestamps.
        public static let caption = DSTextStyle(
            fontName: "TedNext-Medium",
            size: 12,
            lineHeight: 16,
            uiFontTextStyle: .caption1
        )

        /// TedNext-Bold 12/16 pt — supporting labels, tab bar items.
        public static let label = DSTextStyle(
            fontName: "TedNext-Bold",
            size: 12,
            lineHeight: 16,
            uiFontTextStyle: .caption1
        )

        /// TedNext-Bold 10/16 pt · letter-spacing +0.8 · uppercased.
        /// For section headers, tag labels, status chips.
        public static let overline = DSTextStyle(
            fontName: "TedNext-Bold",
            size: 10,
            lineHeight: 16,
            letterSpacing: 0.8,
            uiFontTextStyle: .caption2,
            isUppercased: true
        )
    }
}
