// DSActionTileConfiguration.swift
// Rogers iOS Design System
//
// Figma reference:
//   Action Tile → Chatr-POC node 128:199 (Frame 29)
//
// Defines the data model for DSActionTile — a horizontal card component
// displaying an icon, title, status text, and optional action button.

import SwiftUI

// MARK: - DSActionTileStatus

/// Semantic status states for an action tile that determine the visual
/// treatment of the status text and (optionally) the icon color.
public enum DSActionTileStatus: String, CaseIterable {
    /// Active/enabled state — typically rendered in success green.
    case active
    /// Inactive/disabled state — typically rendered in error red.
    case inactive
    /// Warning state — typically rendered in warning orange.
    case warning
    /// Error state — typically rendered in error red.
    case error
    /// Neutral state — typically rendered in secondary gray.
    case neutral
}

// MARK: - DSActionTileStatus color mapping

public extension DSActionTileStatus {
    /// Maps the status type to the appropriate semantic text color token.
    var textColor: DSTextColor {
        switch self {
        case .active:   return .success
        case .inactive: return .error
        case .warning:  return .warning
        case .error:    return .error
        case .neutral:  return .secondary
        }
    }
}

// MARK: - DSActionTileConfiguration

/// A value-type configuration for `DSActionTile` that defines all content,
/// layout, and accessibility properties.
///
/// Use this to construct a tile programmatically or to store/share tile state.
public struct DSActionTileConfiguration: Equatable {
    
    // MARK: Content
    
    /// Icon displayed on the left side (24×24 pt recommended).
    public var icon: Image
    
    /// Primary title text (e.g., "Roaming").
    public var title: String
    
    /// Status text displayed below the title (e.g., "Not Active").
    public var status: String
    
    /// Semantic status type that controls the color of the status text.
    public var statusType: DSActionTileStatus
    
    /// Optional action button title (e.g., "Activate now").
    /// When `nil`, the tile is display-only with no button.
    public var buttonTitle: String?
    
    // MARK: Accessibility
    
    /// Overrides the computed accessibility label (defaults to "{title}, {status}").
    public var accessibilityLabel: String?
    
    /// Describes the purpose of the tile or what happens when tapped.
    public var accessibilityHint: String?
    
    /// Identifier used by UI automation test frameworks.
    public var accessibilityIdentifier: String?
    
    // MARK: Init
    
    /// Creates a new action tile configuration.
    ///
    /// - Parameters:
    ///   - icon: Icon displayed on the left (24×24 pt recommended).
    ///   - title: Primary title text.
    ///   - status: Status text displayed below the title.
    ///   - statusType: Semantic status controlling the status text color.
    ///   - buttonTitle: Optional action button title. When `nil`, no button is shown.
    ///   - accessibilityLabel: VoiceOver label override (defaults to "{title}, {status}").
    ///   - accessibilityHint: VoiceOver hint describing the tile's purpose.
    ///   - accessibilityIdentifier: UI testing identifier.
    public init(
        icon: Image,
        title: String,
        status: String,
        statusType: DSActionTileStatus = .neutral,
        buttonTitle: String? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.icon = icon
        self.title = title
        self.status = status
        self.statusType = statusType
        self.buttonTitle = buttonTitle
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
    // MARK: Equatable (Image is not Equatable — compare scalar fields only)
    
    public static func == (lhs: DSActionTileConfiguration, rhs: DSActionTileConfiguration) -> Bool {
        lhs.title == rhs.title &&
        lhs.status == rhs.status &&
        lhs.statusType == rhs.statusType &&
        lhs.buttonTitle == rhs.buttonTitle &&
        lhs.accessibilityLabel == rhs.accessibilityLabel &&
        lhs.accessibilityHint == rhs.accessibilityHint &&
        lhs.accessibilityIdentifier == rhs.accessibilityIdentifier
    }
}
