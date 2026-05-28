// DSActionTile.swift
// Rogers iOS Design System
//
// Figma reference:
//   Action Tile → Chatr-POC node 128:199 (Frame 29)
//   Icon + title/status → Frame 22 + Frame 23
//   Button → Frame 5 (outline button, 100px corner radius)
//
// A horizontal tile component presenting an icon, title, status text, and
// optional action button. Suitable for feature toggles, service status cards,
// or informational tiles with CTAs.
//
// Usage:
//   DSActionTile(
//       configuration: DSActionTileConfiguration(
//           icon: Image(systemName: "airplane"),
//           title: "Roaming",
//           status: "Not Active",
//           statusType: .inactive,
//           buttonTitle: "Activate now"
//       )
//   ) {
//       handleActivation()
//   }
//
//   // Display-only tile (no button)
//   DSActionTile(
//       configuration: DSActionTileConfiguration(
//           icon: Image(systemName: "checkmark.circle.fill"),
//           title: "Data Plan",
//           status: "Active",
//           statusType: .active
//       )
//   )

import SwiftUI
import Tokens

// MARK: - DSActionTile

/// A horizontal card component displaying an icon, title, status text, and
/// optional action button.
///
/// Matches Figma node 128:199 (Frame 29) with token-driven styling:
///   • White background with gray border (dark-mode adaptive)
///   • 16px corner radius
///   • Token-based padding and spacing
///   • Status text color mapped to semantic status type
///   • Reuses `DSLabel` for text and `DSButton` for action
///
///     DSActionTile(
///         configuration: DSActionTileConfiguration(
///             icon: Image(systemName: "airplane"),
///             title: "Roaming",
///             status: "Not Active",
///             statusType: .inactive,
///             buttonTitle: "Activate now"
///         )
///     ) {
///         activateRoaming()
///     }
public struct DSActionTile: View {
    
    // MARK: Properties
    
    private let configuration: DSActionTileConfiguration
    private let action: (() -> Void)?
    
    // MARK: Initialisers
    
    /// Convenience initialiser with individual parameters.
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
    ///   - action: Closure invoked when the button is tapped (only relevant if `buttonTitle` is non-nil).
    public init(
        icon: Image,
        title: String,
        status: String,
        statusType: DSActionTileStatus = .neutral,
        buttonTitle: String? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.configuration = DSActionTileConfiguration(
            icon: icon,
            title: title,
            status: status,
            statusType: statusType,
            buttonTitle: buttonTitle,
            accessibilityLabel: accessibilityLabel,
            accessibilityHint: accessibilityHint,
            accessibilityIdentifier: accessibilityIdentifier
        )
        self.action = action
    }
    
    /// Configuration-based initialiser for use with `DSActionTileConfiguration`.
    ///
    /// - Parameters:
    ///   - configuration: A configuration object defining all tile properties.
    ///   - action: Closure invoked when the button is tapped (only relevant if `buttonTitle` is non-nil).
    public init(
        configuration: DSActionTileConfiguration,
        action: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.action = action
    }
    
    // MARK: Body
    
    public var body: some View {
        HStack(spacing: 8) {
            // Left section: icon + title/status
            leftSection
            
            // Spacer for flexible layout
            Spacer(minLength: 16)
            
            // Right section: optional button
            if let buttonTitle = configuration.buttonTitle {
                DSButton(
                    buttonTitle,
                    variant: .outline,
                    size: .medium,
                    action: action ?? {}
                )
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .padding(.leading, RDSToken.Spacing.medium + 1)    // 17pt in Figma
        .padding(.trailing, RDSToken.Spacing.small + 4)    // 12pt in Figma
        .padding(.vertical, RDSToken.Spacing.medium + 5)   // ~21pt in Figma
        .background(RDSToken.Color.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: RDSToken.Spacing.medium)
                .stroke(RDSToken.Color.borderColor, lineWidth: 1)
        )
        .cornerRadius(RDSToken.Spacing.medium)
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint(configuration.accessibilityHint ?? "")
        .optionalAccessibilityIdentifier(configuration.accessibilityIdentifier)
    }
    
    // MARK: - Left Section
    
    private var leftSection: some View {
        HStack(spacing: 8) {
            // Icon (24×24 pt)
            configuration.icon
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(RDSToken.Color.textPrimaryColor)
            
            // Title + Status
            VStack(alignment: .leading, spacing: 0) {
                DSLabel(
                    configuration.title,
                    style: RDSToken.Typography.bodyBold,
                    color: .primary,
                    alignment: .leading
                )
                
                DSLabel(
                    configuration.status,
                    style: RDSToken.Typography.bodySmall,
                    color: configuration.statusType.textColor,
                    alignment: .leading
                )
            }
        }
    }
    
    // MARK: - Helpers
    
    private var accessibilityLabel: String {
        configuration.accessibilityLabel ?? "\(configuration.title), \(configuration.status)"
    }
}

// MARK: - View helper

private extension View {
    /// Applies `accessibilityIdentifier` only when a non-nil value is provided.
    @ViewBuilder
    func optionalAccessibilityIdentifier(_ identifier: String?) -> some View {
        if let id = identifier {
            self.accessibilityIdentifier(id)
        } else {
            self
        }
    }
}

// MARK: - Previews

#if DEBUG
struct DSActionTile_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            statusVariantsPreview
                .preferredColorScheme(.light)
                .previewDisplayName("Status Variants – Light")
            
            statusVariantsPreview
                .preferredColorScheme(.dark)
                .previewDisplayName("Status Variants – Dark")
            
            withoutButtonPreview
                .preferredColorScheme(.light)
                .previewDisplayName("Without Button – Light")
            
            figmaExactPreview
                .preferredColorScheme(.light)
                .previewDisplayName("Figma Exact Match")
        }
    }
    
    // MARK: Status Variants
    
    static var statusVariantsPreview: some View {
        VStack(spacing: 16) {
            DSActionTile(
                icon: Image(systemName: "checkmark.circle.fill"),
                title: "Data Plan",
                status: "Active",
                statusType: .active,
                buttonTitle: "Manage"
            ) {
                print("Manage tapped")
            }
            
            DSActionTile(
                icon: Image(systemName: "airplane"),
                title: "Roaming",
                status: "Not Active",
                statusType: .inactive,
                buttonTitle: "Activate now"
            ) {
                print("Activate tapped")
            }
            
            DSActionTile(
                icon: Image(systemName: "exclamationmark.triangle.fill"),
                title: "Payment",
                status: "Attention Required",
                statusType: .warning,
                buttonTitle: "Review"
            ) {
                print("Review tapped")
            }
            
            DSActionTile(
                icon: Image(systemName: "xmark.circle.fill"),
                title: "Service",
                status: "Error",
                statusType: .error,
                buttonTitle: "Retry"
            ) {
                print("Retry tapped")
            }
            
            DSActionTile(
                icon: Image(systemName: "info.circle"),
                title: "Information",
                status: "Available",
                statusType: .neutral,
                buttonTitle: "Learn more"
            ) {
                print("Learn more tapped")
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: Without Button
    
    static var withoutButtonPreview: some View {
        VStack(spacing: 16) {
            DSActionTile(
                icon: Image(systemName: "checkmark.circle.fill"),
                title: "Unlimited Data",
                status: "Active",
                statusType: .active
            )
            
            DSActionTile(
                icon: Image(systemName: "phone.fill"),
                title: "Voice Calls",
                status: "Unlimited Canada-wide",
                statusType: .neutral
            )
            
            DSActionTile(
                icon: Image(systemName: "message.fill"),
                title: "Text Messages",
                status: "Unlimited",
                statusType: .active
            )
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    // MARK: Figma Exact Match
    
    static var figmaExactPreview: some View {
        // Matches Figma node 128:199 exactly
        VStack(spacing: 24) {
            Text("Figma node 128:199 reproduction")
                .font(RDSToken.Typography.caption.font)
                .foregroundColor(RDSToken.Color.textSecondaryColor)
            
            DSActionTile(
                configuration: DSActionTileConfiguration(
                    icon: Image(systemName: "airplane"),
                    title: "Roaming",
                    status: "Not Active",
                    statusType: .inactive,
                    buttonTitle: "Activate now"
                )
            ) {
                print("Activate now tapped")
            }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
#endif
