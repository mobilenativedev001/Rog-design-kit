// DSButtonConfiguration.swift
// Rogers iOS Design System
//
// Figma reference:
//   Primary button  → https://www.figma.com/design/xcGZSaCf2gcFMmzzZmAxrn/Chatr-POC?node-id=5-486
//   Outline button  → https://www.figma.com/design/xcGZSaCf2gcFMmzzZmAxrn/Chatr-POC?node-id=126-210
//
// Defines the data-only types (variant, size, configuration) that drive DSButton
// rendering. All styling logic lives in DSButtonStyle; this layer is pure data.

import SwiftUI

// MARK: - DSButtonVariant

/// The visual treatment variant for `DSButton`.
///
/// Map to Figma button variants in the Chatr design kit.
public enum DSButtonVariant: String, CaseIterable {
    /// Solid Rogers-purple fill — primary calls-to-action (Figma node 5:486).
    case primary
    /// Solid brand-teal fill — secondary priority actions.
    case secondary
    /// Transparent background with a colored stroke border (Figma node 126:210).
    case outline
    /// Solid semantic-error fill — irreversible / destructive actions.
    case destructive
    /// No fill, no border — lowest-priority or in-context text actions.
    case ghost
}

// MARK: - DSButtonSize

/// The size tier controlling vertical padding, horizontal padding, font size,
/// minimum tap-target height, and icon size.
public enum DSButtonSize: String, CaseIterable {
    /// Compact — 36 pt min-height, suitable for toolbars and dense UIs.
    case small
    /// Default — 48 pt min-height, matches Figma 12 pt vertical padding.
    case medium
    /// Prominent — 56 pt min-height, hero or full-width CTAs.
    case large
}

// MARK: - DSButtonSize layout metrics

public extension DSButtonSize {
    /// Vertical inset applied above and below the label.
    var verticalPadding: CGFloat {
        switch self {
        case .small:  return 8
        case .medium: return 12   // matches Figma py-[12px]
        case .large:  return 16
        }
    }

    /// Horizontal inset applied to the left and right of the label.
    var horizontalPadding: CGFloat {
        switch self {
        case .small:  return 16
        case .medium: return 24
        case .large:  return 32
        }
    }

    /// Body font size for the button label.
    var fontSize: CGFloat {
        switch self {
        case .small:  return 14
        case .medium: return 16   // matches Figma ds-body-r-font-size
        case .large:  return 18
        }
    }

    /// Minimum tappable height (WCAG 2.5.5 target-size guidance: ≥44 pt).
    var minHeight: CGFloat {
        switch self {
        case .small:  return 44   // never below 44 pt for accessibility
        case .medium: return 48
        case .large:  return 56
        }
    }

    /// Square dimension for leading/trailing icon images.
    var iconSize: CGFloat {
        switch self {
        case .small:  return 16
        case .medium: return 20
        case .large:  return 22
        }
    }

    /// Loading spinner scale factor relative to the default ProgressView size.
    var spinnerScale: CGFloat {
        switch self {
        case .small:  return 0.75
        case .medium: return 1.0
        case .large:  return 1.0
        }
    }
}

// MARK: - DSButtonConfiguration

/// A value-type aggregate of all properties that control a `DSButton`'s
/// appearance and behaviour. Pass this to the configuration-based initialiser
/// when you need to share, store, or mutate button state.
public struct DSButtonConfiguration: Equatable {

    // MARK: Content

    /// Primary button label text.
    public var title: String

    /// Optional icon rendered to the left of the label.
    public var leadingIcon: Image?

    /// Optional icon rendered to the right of the label.
    public var trailingIcon: Image?

    // MARK: Styling

    /// Visual treatment applied to the button.
    public var variant: DSButtonVariant

    /// Size tier controlling padding, font, and tap-target height.
    public var size: DSButtonSize

    // MARK: State

    /// When `true`, the label is hidden and a spinner is shown; taps are blocked.
    public var isLoading: Bool

    /// When `true`, the button is non-interactive and rendered with muted tokens.
    public var isDisabled: Bool

    // MARK: Accessibility

    /// Overrides the computed accessibility label (defaults to `title`).
    public var accessibilityLabel: String?

    /// Describes what happens when the button is activated.
    public var accessibilityHint: String?

    /// Identifier used by UI automation test frameworks.
    public var accessibilityIdentifier: String?

    // MARK: Init

    public init(
        title: String,
        variant: DSButtonVariant = .primary,
        size: DSButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    // MARK: Equatable (Image is not Equatable — compare scalar fields only)

    public static func == (lhs: DSButtonConfiguration, rhs: DSButtonConfiguration) -> Bool {
        lhs.title == rhs.title &&
        lhs.variant == rhs.variant &&
        lhs.size == rhs.size &&
        lhs.isLoading == rhs.isLoading &&
        lhs.isDisabled == rhs.isDisabled &&
        lhs.accessibilityLabel == rhs.accessibilityLabel &&
        lhs.accessibilityHint == rhs.accessibilityHint &&
        lhs.accessibilityIdentifier == rhs.accessibilityIdentifier
    }
}
