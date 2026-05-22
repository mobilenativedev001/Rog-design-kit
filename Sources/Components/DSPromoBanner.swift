// DSPromoBanner.swift
// Rogers iOS Design System
//
// A horizontal promotional/offer strip component derived from Figma node 128:60
// (Chatr-POC, "Frame 25"):
//
//   ┌────────────────────────────────────────────────────┐
//   │  🏷  Special Offer for you                         │  ← 33pt tall
//   └────────────────────────────────────────────────────┘
//   Background: #55228A (promoBannerBackground token)
//   Text:       White TedNext Bold 12pt (label style)
//   Icon:       SF Symbol "tag.fill" — white, 12pt (optional)
//   Shape:      Rectangle — NO rounded corners
//   Padding:    10pt leading/trailing, vertically centred
//
// Figma pixel analysis summary:
//   • Icon cluster  x=10–29  (18pt wide)
//   • Text starts   x=49     ("Special Offer for you", white)
//   • All rows top/bottom are fully filled → sharp rectangular corners confirmed
//
// Components exposed:
//   DSPromoBanner      — full SwiftUI component with variants + previews
//   DSPromoBannerVariant — colour scheme enum
//   DSPromoBannerConfiguration — data model used by UIKit compat layer

import SwiftUI
import Tokens

// MARK: - DSPromoBannerVariant

/// The colour scheme applied to a `DSPromoBanner`.
///
/// - `offer`   — Deep brand purple `#55228A` / white.  Matches Figma node 128:60.
/// - `success` — Semantic green / white.
/// - `warning` — Semantic amber / near-black.
/// - `info`    — Brand-primary blue / white.
/// - `custom`  — Caller-supplied background + foreground colours.
public enum DSPromoBannerVariant: Equatable {
    case offer
    case success
    case warning
    case info
    case custom(background: Color, foreground: Color)

    // MARK: Colours

    var backgroundColor: Color {
        switch self {
        case .offer:                     return RDSToken.Color.promoBannerBackgroundColor
        case .success:                   return RDSToken.Color.successColor
        case .warning:                   return RDSToken.Color.warningColor
        case .info:                      return RDSToken.Color.primaryColor
        case .custom(let bg, _):         return bg
        }
    }

    var foregroundColor: Color {
        switch self {
        case .offer:                     return RDSToken.Color.promoBannerForegroundColor
        case .success:                   return .white
        case .warning:                   return Color(RDSToken.Color.textPrimary)
        case .info:                      return .white
        case .custom(_, let fg):         return fg
        }
    }

    // MARK: Equatable

    public static func == (lhs: DSPromoBannerVariant, rhs: DSPromoBannerVariant) -> Bool {
        switch (lhs, rhs) {
        case (.offer, .offer),
             (.success, .success),
             (.warning, .warning),
             (.info, .info):
            return true
        case (.custom(let lb, let lf), .custom(let rb, let rf)):
            return lb == rb && lf == rf
        default:
            return false
        }
    }
}

// MARK: - DSPromoBannerConfiguration

/// Data model for `DSPromoBanner`.  Pass to the UIKit compat layer or use
/// directly with the SwiftUI component.
public struct DSPromoBannerConfiguration: Equatable {

    // MARK: Properties

    /// The label displayed in the banner.
    public var text: String

    /// SF Symbol name for the leading icon.  Pass `nil` to hide the icon.
    /// Defaults to `"tag.fill"` matching Figma node 128:60.
    public var iconName: String?

    /// Colour scheme.  Defaults to `.offer` (deep brand purple / white).
    public var variant: DSPromoBannerVariant

    /// Minimum height of the banner in points.  Defaults to `33`.
    public var minHeight: CGFloat

    /// Horizontal padding applied to both leading and trailing edges.
    public var horizontalPadding: CGFloat

    /// Spacing between the icon and the text.
    public var iconTextSpacing: CGFloat

    // MARK: Init

    public init(
        text: String,
        iconName: String? = "tag.fill",
        variant: DSPromoBannerVariant = .offer,
        minHeight: CGFloat = 33,
        horizontalPadding: CGFloat = 10,
        iconTextSpacing: CGFloat = 6
    ) {
        self.text               = text
        self.iconName           = iconName
        self.variant            = variant
        self.minHeight          = minHeight
        self.horizontalPadding  = horizontalPadding
        self.iconTextSpacing    = iconTextSpacing
    }

    // MARK: Factory presets

    /// Figma-exact preset for "Special Offer for you" (node 128:60).
    public static func specialOffer(text: String = "Special Offer for you") -> DSPromoBannerConfiguration {
        DSPromoBannerConfiguration(text: text, iconName: "tag.fill", variant: .offer)
    }

    /// Success / confirmation banner with a checkmark icon.
    public static func successBanner(text: String) -> DSPromoBannerConfiguration {
        DSPromoBannerConfiguration(text: text, iconName: "checkmark.circle.fill", variant: .success)
    }

    /// Warning / caution banner with an exclamation icon.
    public static func warningBanner(text: String) -> DSPromoBannerConfiguration {
        DSPromoBannerConfiguration(text: text, iconName: "exclamationmark.triangle.fill", variant: .warning)
    }

    /// Informational banner with an info icon.
    public static func infoBanner(text: String) -> DSPromoBannerConfiguration {
        DSPromoBannerConfiguration(text: text, iconName: "info.circle.fill", variant: .info)
    }
}

// MARK: - DSPromoBanner

/// A full-width horizontal promotional strip.
///
/// Faithfully reproduces Figma node 128:60 and extends it into a general-purpose
/// notification/promo component for the Rogers design system.
///
/// ```swift
/// // Exact Figma reproduction
/// DSPromoBanner(text: "Special Offer for you")
///
/// // Configuration-based
/// DSPromoBanner(configuration: .successBanner(text: "Your plan has been updated"))
///
/// // Custom variant
/// DSPromoBanner(
///     text: "Limited time deal",
///     iconName: "flame.fill",
///     variant: .custom(background: .red, foreground: .white)
/// )
/// ```
public struct DSPromoBanner: View {

    // MARK: Properties

    private let configuration: DSPromoBannerConfiguration

    // MARK: Init

    /// Create a banner from individual parameters.
    public init(
        text: String,
        iconName: String? = "tag.fill",
        variant: DSPromoBannerVariant = .offer,
        minHeight: CGFloat = 33,
        horizontalPadding: CGFloat = 10,
        iconTextSpacing: CGFloat = 6
    ) {
        self.configuration = DSPromoBannerConfiguration(
            text: text,
            iconName: iconName,
            variant: variant,
            minHeight: minHeight,
            horizontalPadding: horizontalPadding,
            iconTextSpacing: iconTextSpacing
        )
    }

    /// Create a banner from a `DSPromoBannerConfiguration`.
    public init(configuration: DSPromoBannerConfiguration) {
        self.configuration = configuration
    }

    // MARK: Body

    public var body: some View {
        ZStack {
            // Background — rectangular, NO corner radius (confirmed by pixel analysis)
            configuration.variant.backgroundColor
                .frame(maxWidth: .infinity)
                .frame(minHeight: configuration.minHeight)

            HStack(spacing: configuration.iconTextSpacing) {
                if let iconName = configuration.iconName {
                    Image(systemName: iconName)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(configuration.variant.foregroundColor)
                        .accessibilityHidden(true)
                }

                Text(configuration.text)
                    .font(RDSToken.Typography.label.font)
                    .foregroundColor(configuration.variant.foregroundColor)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, configuration.horizontalPadding)
            .padding(.vertical, 7)
        }
        .frame(maxWidth: .infinity)
        // Accessibility: announce as a single static text element
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(configuration.text)
        .accessibilityAddTraits(.isStaticText)
        // Optional identifier for UI testing
        ._optionalAccessibilityIdentifier("DSPromoBanner-\(configuration.variant.accessibilityName)")
    }
}

// MARK: - DSPromoBannerVariant accessibility helpers

private extension DSPromoBannerVariant {
    var accessibilityName: String {
        switch self {
        case .offer:         return "offer"
        case .success:       return "success"
        case .warning:       return "warning"
        case .info:          return "info"
        case .custom:        return "custom"
        }
    }
}

// MARK: - View helper

private extension View {
    @ViewBuilder
    func _optionalAccessibilityIdentifier(_ id: String) -> some View {
        if #available(iOS 14.0, *) {
            self.accessibilityIdentifier(id)
        } else {
            self
        }
    }
}

// MARK: - Previews

#if DEBUG
struct DSPromoBanner_Previews: PreviewProvider {

    // MARK: Figma node 128:60 — exact reproduction

    static var previews: some View {
        VStack(spacing: 20) { // Set uniform 20pt gap
            Group {
                allVariants
//                noIcon
//                darkMode
//                dynamicTypeXXL
                inContext
            }
        }
    }

    // MARK: Exact Figma reproduction (node 128:60)

    static var figmaNode128_60: some View {
        DSPromoBanner(text: "Special Offer for you")
            .frame(width: 244, height: 30)
            .previewDisplayName("Figma node 128:60 — exact")
            .previewLayout(.sizeThatFits)
            .padding(8)
    }

    // MARK: All variants

    static var allVariants: some View {
        VStack(spacing: 10) {
            DSPromoBanner(configuration: .specialOffer())
            DSPromoBanner(configuration: .successBanner(text: "Your plan has been updated"))
            DSPromoBanner(configuration: .warningBanner(text: "Payment due in 3 days"))
            DSPromoBanner(configuration: .infoBanner(text: "New features available"))
            DSPromoBanner(
                text: "Limited time deal",
                iconName: "flame.fill",
                variant: .custom(background: Color(red: 0.8, green: 0.1, blue: 0.1), foreground: .white)
            )
        }
        .previewDisplayName("All variants")
        .previewLayout(.sizeThatFits)
    }

    // MARK: No icon

    static var noIcon: some View {
        VStack(spacing: 0) {
            DSPromoBanner(text: "Special Offer for you", iconName: nil)
            DSPromoBanner(text: "Payment confirmed", iconName: nil, variant: .success)
        }
        .previewDisplayName("No icon")
        .previewLayout(.sizeThatFits)
    }

    // MARK: Dark mode

    static var darkMode: some View {
        VStack(spacing: 0) {
            DSPromoBanner(configuration: .specialOffer())
            DSPromoBanner(configuration: .successBanner(text: "Your plan has been updated"))
            DSPromoBanner(configuration: .warningBanner(text: "Payment due in 3 days"))
        }
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark mode")
        .previewLayout(.sizeThatFits)
    }

    // MARK: Dynamic type XXL

    static var dynamicTypeXXL: some View {
        DSPromoBanner(text: "Special Offer for you")
            .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
            .previewDisplayName("Dynamic Type XXL")
            .previewLayout(.sizeThatFits)
    }

    // MARK: In context — plan card header

    static var inContext: some View {
        VStack(spacing: 0) {
            // Promo strip sits flush at the top of a card
            DSPromoBanner(text: "Special Offer for you")
                .frame(height: 40)

            VStack(alignment: .leading, spacing: 12) {
                DSLabel("Rogers Infinite+",
                        style: RDSToken.Typography.title4,
                        color: .primary)

                DSLabel("$55/month • Unlimited Canada-wide data",
                        style: RDSToken.Typography.bodyRegular,
                        color: .secondary)

                DSButton(
                    "Get this plan",
                    variant: .primary,
                    size: .medium
                ) {}
            }
            .padding()
            .background(Color(RDSToken.Color.surface))
        }
        .background(Color(RDSToken.Color.surface))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        .padding()
        .previewDisplayName("In context — plan card")
        .previewLayout(.sizeThatFits)
    }
}
#endif
