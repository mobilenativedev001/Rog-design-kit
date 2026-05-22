// DSLabel.swift
// Rogers iOS Design System
//
// Reusable text components built on the RDSToken.Typography scale.
//
// Figma reference:
//   Page header (title+subtitle) → node 5:448
//   Title style                  → node 5:441  (TedNext-Bold 30/36 #5D2894)
//   Body style                   → node 5:395  (TedNext-Medium 16/24 #1F1F1F)
//   Hero text (UILabel snippet)  → TedNext-Bold 16/36 white
//
// Components:
//   DSLabel          — single configurable text view (all styles + colours)
//   DSPageHeader     — title + optional subtitle pair (Figma node 5:448)
//   DSHeroText       — bold white multi-line text for coloured / image backgrounds
//
// Usage:
//   DSLabel("Sign in", style: .title3, color: .brand)
//
//   DSPageHeader(
//       title: "Sign in",
//       subtitle: "With your My Chatr credentials"
//   )
//
//   DSHeroText("Now you make the call\nSign in to manage your account.")

import SwiftUI
import Tokens

// MARK: - DSTextColor

/// Semantic text-colour roles that map to RDSToken.Color dynamic tokens.
/// All values automatically adapt to light/dark mode and high-contrast settings.
public enum DSTextColor {
    /// Primary content text — near-black on light, near-white on dark.
    case primary
    /// Secondary / supporting text — medium grey on both themes.
    case secondary
    /// Rogers brand purple — Figma title colour `#5D2894` (node 5:441).
    case brand
    /// White — for text displayed on coloured or dark backgrounds (UILabel snippet).
    case inverse
    /// Semantic error colour.
    case error
    /// Semantic success colour.
    case success
    /// Semantic warning colour.
    case warning
    /// Disabled / non-interactive text.
    case disabled
    /// Escape hatch: supply any arbitrary SwiftUI `Color`.
    case custom(Color)

    // MARK: SwiftUI Color

    public var color: Color {
        switch self {
        case .primary:          return RDSToken.Color.textPrimaryColor
        case .secondary:        return RDSToken.Color.textSecondaryColor
        case .brand:            return RDSToken.Color.brandTextColor
        case .inverse:          return RDSToken.Color.inverseTextColor
        case .error:            return RDSToken.Color.errorColor
        case .success:          return RDSToken.Color.successColor
        case .warning:          return RDSToken.Color.warningColor
        case .disabled:         return RDSToken.Color.textDisabledColor
        case .custom(let c):    return c
        }
    }

    // MARK: UIColor (for UIKit consumers)

    public var uiColor: UIColor {
        switch self {
        case .primary:          return RDSToken.Color.textPrimary
        case .secondary:        return RDSToken.Color.textSecondary
        case .brand:            return RDSToken.Color.brandText
        case .inverse:          return RDSToken.Color.inverseText
        case .error:            return RDSToken.Color.error
        case .success:          return RDSToken.Color.success
        case .warning:          return RDSToken.Color.warning
        case .disabled:         return RDSToken.Color.textDisabled
        case .custom(let c):    return UIColor(c)
        }
    }
}

// MARK: - DSLabel

/// The fundamental text component for the Rogers design system.
///
/// `DSLabel` is a thin SwiftUI wrapper that pairs a `DSTextStyle` (from
/// `RDSToken.Typography`) with a `DSTextColor` semantic role and common
/// layout options.  All fonts scale with the user's Dynamic Type setting.
///
///     // Body text
///     DSLabel("With your My Chatr credentials")
///
///     // Explicit style + brand colour (Figma title 5:441)
///     DSLabel("Sign in", style: .title3, color: .brand)
///
///     // Capped to two lines
///     DSLabel("Long caption text…", style: .caption, numberOfLines: 2)
public struct DSLabel: View {

    // MARK: Properties

    public let text: String
    public let style: DSTextStyle
    public let textColor: DSTextColor
    public let alignment: TextAlignment
    /// Maximum number of lines. `0` (default) = unlimited.
    public let numberOfLines: Int

    // MARK: Init

    public init(
        _ text: String,
        style: DSTextStyle = RDSToken.Typography.bodyRegular,
        color: DSTextColor = .primary,
        alignment: TextAlignment = .leading,
        numberOfLines: Int = 0
    ) {
        self.text         = text
        self.style        = style
        self.textColor    = color
        self.alignment    = alignment
        self.numberOfLines = numberOfLines
    }

    // MARK: Body

    public var body: some View {
        Text(style.isUppercased ? text.uppercased() : text)
            .font(style.font)
            .foregroundColor(textColor.color)
            .lineSpacing(style.swiftUILineSpacing)
            .tracking(style.letterSpacing)
            .multilineTextAlignment(alignment)
            .lineLimit(numberOfLines == 0 ? nil : numberOfLines)
            // Allow vertical growth; prevent horizontal clipping.
            .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - DSPageHeader

/// A title + optional subtitle composition matching Figma node 5:448.
///
/// Rendered exactly as the Figma spec:
///   • Title  — TedNext-Bold 30/36 pt, brand purple `#5D2894`
///   • Subtitle — TedNext-Medium 16/24 pt, primary dark `#1F1F1F`
///
///     DSPageHeader(
///         title: "Sign in",
///         subtitle: "With your My Chatr credentials"
///     )
///
///     // Custom title colour (e.g. inverse for dark screens)
///     DSPageHeader(title: "Welcome", titleColor: .inverse)
public struct DSPageHeader: View {

    // MARK: Properties

    public let title: String
    public let subtitle: String?
    public let titleColor: DSTextColor
    public let subtitleColor: DSTextColor
    public let alignment: TextAlignment

    // MARK: Init

    /// - Parameters:
    ///   - title:         Main page title.
    ///   - subtitle:      Optional secondary descriptor displayed below the title.
    ///   - titleColor:    Colour for the title (default: `.brand` — Rogers purple).
    ///   - subtitleColor: Colour for the subtitle (default: `.primary`).
    ///   - alignment:     Horizontal text alignment for both lines (default: `.leading`).
    public init(
        title: String,
        subtitle: String? = nil,
        titleColor: DSTextColor = .brand,
        subtitleColor: DSTextColor = .primary,
        alignment: TextAlignment = .leading
    ) {
        self.title         = title
        self.subtitle      = subtitle
        self.titleColor    = titleColor
        self.subtitleColor = subtitleColor
        self.alignment     = alignment
    }

    // MARK: Body

    public var body: some View {
        VStack(alignment: textAlignment, spacing: 4) {
            DSLabel(title,
                    style: RDSToken.Typography.title3,
                    color: titleColor,
                    alignment: alignment)

            if let subtitle = subtitle {
                DSLabel(subtitle,
                        style: RDSToken.Typography.bodyRegular,
                        color: subtitleColor,
                        alignment: alignment)
            }
        }
        // Make the header accessible as a single announcement unit.
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel(accessibilityLabel)
    }

    // MARK: Helpers

    private var textAlignment: HorizontalAlignment {
        switch alignment {
        case .leading:  return .leading
        case .center:   return .center
        case .trailing: return .trailing
        }
    }

    private var accessibilityLabel: String {
        if let subtitle = subtitle { return "\(title), \(subtitle)" }
        return title
    }
}

// MARK: - DSHeroText

/// Bold multi-line text for hero sections, splash screens, and marketing banners
/// displayed on coloured or dark backgrounds.
///
/// Matches the UILabel snippet specification:
///   • Font     : TedNext-Bold 16 pt (heroBody style)
///   • Colour   : white (inverse)
///   • Line height: 36 pt (explicit — not `lineHeightMultiple: 0.98`)
///   • Multi-line with word wrapping
///
///     DSHeroText("Now you make the call\nSign in to manage your account.")
///
///     // Overriding alignment
///     DSHeroText("Your Rogers account, all in one place.", alignment: .center)
public struct DSHeroText: View {

    // MARK: Properties

    public let text: String
    public let color: DSTextColor
    public let alignment: TextAlignment

    // MARK: Init

    /// - Parameters:
    ///   - text:      The hero text to display (supports multi-line with `\n`).
    ///   - color:     Text colour (default: `.inverse` — white, for dark backgrounds).
    ///   - alignment: Horizontal text alignment (default: `.leading`).
    public init(
        _ text: String,
        color: DSTextColor = .inverse,
        alignment: TextAlignment = .leading
    ) {
        self.text      = text
        self.color     = color
        self.alignment = alignment
    }

    // MARK: Body

    public var body: some View {
        DSLabel(
            text,
            style: RDSToken.Typography.heroBody,
            color: color,
            alignment: alignment,
            numberOfLines: 0
        )
    }
}

// MARK: - Previews

#if DEBUG
struct DSLabel_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            typeScalePreview
                .preferredColorScheme(.light)
                .previewDisplayName("Type Scale – Light")

            typeScalePreview
                .preferredColorScheme(.dark)
                .previewDisplayName("Type Scale – Dark")

            pageHeaderPreview
                .preferredColorScheme(.light)
                .previewDisplayName("DSPageHeader – Light")

            pageHeaderPreview
                .preferredColorScheme(.dark)
                .previewDisplayName("DSPageHeader – Dark")

            heroTextPreview
                .preferredColorScheme(.light)
                .previewDisplayName("DSHeroText – Light")

            colorsPreview
                .preferredColorScheme(.light)
                .previewDisplayName("DSTextColor palette")

            figmaSignInScreen
                .preferredColorScheme(.light)
                .previewDisplayName("Figma node 5:448 exact")
        }
    }

    // MARK: Full type scale

    static var typeScalePreview: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                DSLabel("Display 48",    style:RDSToken.Typography.display,      color: .primary)
                DSLabel("Title 1 36",    style: RDSToken.Typography.title1,       color: .primary)
                DSLabel("Title 2 32",    style: RDSToken.Typography.title2,       color: .primary)
                DSLabel("Title 3 30",    style: RDSToken.Typography.title3,       color: .brand)
                DSLabel("Title 4 24",    style: RDSToken.Typography.title4,       color: .primary)
                DSLabel("Body Large 18", style: RDSToken.Typography.bodyLarge,    color: .primary)
                DSLabel("Body Regular 16", style: RDSToken.Typography.bodyRegular, color: .primary)
                DSLabel("Body Bold 16",  style: RDSToken.Typography.bodyBold,     color: .primary)
                DSLabel("Hero Body 16",  style: RDSToken.Typography.heroBody,     color: .brand)
                DSLabel("Body Small 14", style: RDSToken.Typography.bodySmall,    color: .secondary)
                DSLabel("Caption 12",    style: RDSToken.Typography.caption,      color: .secondary)
                DSLabel("Label 12",      style: RDSToken.Typography.label,        color: .primary)
                DSLabel("overline 10",   style: RDSToken.Typography.overline,     color: .secondary)
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }

    // MARK: DSPageHeader

    static var pageHeaderPreview: some View {
        VStack(spacing: 32) {
            // Exact Figma node 5:448 reproduction
            DSPageHeader(
                title: "Sign in",
                subtitle: "With your My Chatr credentials"
            )
            Divider()
            // Title only
            DSPageHeader(title: "Manage your account")
            Divider()
            // Centred
            DSPageHeader(
                title: "Welcome back",
                subtitle: "Chatr wireless services",
                alignment: .center
            )
            Divider()
            // Inverse on coloured background
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(RDSToken.Color.buttonPrimaryBackground))
                DSPageHeader(
                    title: "Your Rogers Plan",
                    subtitle: "Unlimited everything",
                    titleColor: .inverse,
                    subtitleColor: .inverse
                )
                .padding()
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color(.systemBackground))
    }

    // MARK: DSHeroText

    static var heroTextPreview: some View {
        VStack(spacing: 0) {
            // Matches UILabel snippet exactly
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(RDSToken.Color.buttonPrimaryBackground))
                    .frame(height: 200)
                DSHeroText("Now you make the call\nSign in to manage your account.")
                    .padding(24)
            }
            .padding()

            // On dark background
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.label))
                    .frame(height: 160)
                DSHeroText("Unlimited Canada-wide data.", color: .inverse)
                    .padding(24)
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }

    // MARK: Colour palette

    static var colorsPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(["primary", "secondary", "brand", "inverse on purple", "error", "success", "warning", "disabled"],
                    id: \.self) { name in
                HStack {
                    colorSwatch(for: name)
                    Text(name)
                        .font(RDSToken.Typography.bodyRegular.font)
                        .foregroundColor(dsTextColor(for: name).color)
                        .padding(4)
                        .background(colorSwatch(for: name) == Color.clear
                            ? Color(.secondarySystemBackground) : Color.clear)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }

    private static func dsTextColor(for name: String) -> DSTextColor {
        switch name {
        case "primary":           return .primary
        case "secondary":         return .secondary
        case "brand":             return .brand
        case "inverse on purple": return .inverse
        case "error":             return .error
        case "success":           return .success
        case "warning":           return .warning
        default:                  return .disabled
        }
    }

    private static func colorSwatch(for name: String) -> Color {
        switch name {
        case "inverse on purple": return RDSToken.Color.buttonPrimaryBackgroundColor
        default:                  return .clear
        }
    }

    // MARK: Exact Figma node 5:448 reproduction

    static var figmaSignInScreen: some View {
        VStack(alignment: .leading, spacing: 24) {
            // ── Figma node 5:448 ──────────────────────────
            DSPageHeader(
                title: "Sign in",
                subtitle: "With your My Chatr credentials"
            )
            // ── Form fields ───────────────────────────────
            DSTextField(configuration: .email(),   text: .constant(""))
            DSTextField(configuration: .password(), text: .constant(""))
            // ── Actions ───────────────────────────────────
            DSButton("Sign in", variant: .primary) { }
            DSButton("Create account", variant: .outline) { }
        }
        .padding(24)
        .background(Color(.systemBackground))
    }
}
#endif
