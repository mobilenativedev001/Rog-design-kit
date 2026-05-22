// DSButton.swift
// Rogers iOS Design System
//
// Enterprise-grade, token-driven button component for SwiftUI.
//
// Figma reference:
//   Primary button  → https://www.figma.com/design/xcGZSaCf2gcFMmzzZmAxrn/Chatr-POC?node-id=5-486
//   Outline button  → https://www.figma.com/design/xcGZSaCf2gcFMmzzZmAxrn/Chatr-POC?node-id=126-210
//
// Usage — inline:
//   DSButton("Sign in", variant: .primary) { handleSignIn() }
//
// Usage — configuration:
//   let config = DSButtonConfiguration(title: "Sign in", variant: .primary, isLoading: true)
//   DSButton(configuration: config) { handleSignIn() }
//
// Supported:
//   Variants : primary · secondary · outline · destructive · ghost
//   Sizes    : small · medium · large
//   States   : normal · pressed · loading · disabled · focused (iOS 14+)
//   Themes   : light · dark · high-contrast (all via RDSToken.Color dynamic UIColor)
//   A11y     : VoiceOver label/hint, loading announcement, WCAG 44 pt min tap-target

import SwiftUI
import Tokens

// MARK: - DSButton

public struct DSButton: View {

    // MARK: Properties

    private let configuration: DSButtonConfiguration
    private let action: () -> Void

    // MARK: Initialisers

    /// Convenience initialiser with individual parameters.
    ///
    /// - Parameters:
    ///   - title:       Button label text.
    ///   - variant:     Visual treatment (default: `.primary`).
    ///   - size:        Size tier (default: `.medium`).
    ///   - isLoading:   Shows a spinner and blocks taps (default: `false`).
    ///   - isDisabled:  Renders muted and blocks taps (default: `false`).
    ///   - leadingIcon: Icon placed to the left of the label.
    ///   - trailingIcon:Icon placed to the right of the label.
    ///   - accessibilityLabel: VoiceOver label override (defaults to `title`).
    ///   - accessibilityHint: VoiceOver hint describing the action.
    ///   - accessibilityIdentifier: UI-testing identifier.
    ///   - action:      Closure invoked on tap (not called during loading).
    public init(
        _ title: String,
        variant: DSButtonVariant = .primary,
        size: DSButtonSize = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        leadingIcon: Image? = nil,
        trailingIcon: Image? = nil,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) {
        self.configuration = DSButtonConfiguration(
            title: title,
            variant: variant,
            size: size,
            isLoading: isLoading,
            isDisabled: isDisabled,
            leadingIcon: leadingIcon,
            trailingIcon: trailingIcon,
            accessibilityLabel: accessibilityLabel,
            accessibilityHint: accessibilityHint,
            accessibilityIdentifier: accessibilityIdentifier
        )
        self.action = action
    }

    /// Configuration-based initialiser for use with `DSButtonConfiguration`.
    public init(configuration: DSButtonConfiguration, action: @escaping () -> Void) {
        self.configuration = configuration
        self.action = action
    }

    // MARK: Body

    public var body: some View {
        Button(action: action) {
            buttonLabel
        }
        .buttonStyle(
            DSButtonStyle(
                variant: configuration.variant,
                size: configuration.size,
                isLoading: configuration.isLoading
            )
        )
        // Disabled state disables isEnabled in the environment (grey tokens)
        .disabled(configuration.isDisabled)
        // Block taps during loading without changing visual disabled state
        .allowsHitTesting(!configuration.isLoading)
        // Accessibility
        .accessibilityLabel(configuration.accessibilityLabel ?? configuration.title)
        .accessibilityHint(configuration.accessibilityHint ?? "")
        .accessibilityAddTraits(.isButton)
        .accessibilityValue(configuration.isLoading ? "Loading" : "")
        .optionalAccessibilityIdentifier(configuration.accessibilityIdentifier)
    }

    // MARK: - Label layout

    @ViewBuilder
    private var buttonLabel: some View {
        HStack(spacing: 8) {
            if let leading = configuration.leadingIcon {
                leading
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: configuration.size.iconSize,
                        height: configuration.size.iconSize
                    )
            }

            Text(configuration.title)

            if let trailing = configuration.trailingIcon {
                trailing
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: configuration.size.iconSize,
                        height: configuration.size.iconSize
                    )
            }
        }
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
struct DSButton_Previews: PreviewProvider {

    static var previews: some View {
        Group {
            variantsPreview
                .preferredColorScheme(.light)
                .previewDisplayName("Variants – Light")

            variantsPreview
                .preferredColorScheme(.dark)
                .previewDisplayName("Variants – Dark")

            sizesPreview
                .preferredColorScheme(.light)
                .previewDisplayName("Sizes")

            statesPreview
                .preferredColorScheme(.light)
                .previewDisplayName("States – Light")

            statesPreview
                .preferredColorScheme(.dark)
                .previewDisplayName("States – Dark")

            iconPreview
                .preferredColorScheme(.light)
                .previewDisplayName("With Icons")
        }
    }

    // MARK: Variant showcase

    static var variantsPreview: some View {
        VStack(spacing: 16) {
            DSButton("Sign in",       variant: .primary)     { }
            DSButton("Activate now",  variant: .secondary)   { }
            DSButton("Learn more",    variant: .outline)      { }
            DSButton("Delete account",variant: .destructive)  { }
            DSButton("Skip",          variant: .ghost)        { }
        }
        .padding()
        .background(Color(.systemBackground))
    }

    // MARK: Size showcase

    static var sizesPreview: some View {
        VStack(spacing: 16) {
            DSButton("Small",  variant: .primary, size: .small)  { }
            DSButton("Medium", variant: .primary, size: .medium) { }
            DSButton("Large",  variant: .primary, size: .large)  { }
        }
        .padding()
        .background(Color(.systemBackground))
    }

    // MARK: State showcase

    static var statesPreview: some View {
        VStack(spacing: 16) {
            DSButton("Normal",   variant: .primary) { }
            DSButton("Loading",  variant: .primary, isLoading: true) { }
            DSButton("Disabled", variant: .primary, isDisabled: true) { }
            DSButton("Outline – Normal",   variant: .outline) { }
            DSButton("Outline – Loading",  variant: .outline, isLoading: true) { }
            DSButton("Outline – Disabled", variant: .outline, isDisabled: true) { }
        }
        .padding()
        .background(Color(.systemBackground))
    }

    // MARK: Icon showcase

    static var iconPreview: some View {
        VStack(spacing: 16) {
            DSButton(
                "Download",
                variant: .primary,
                leadingIcon: Image(systemName: "arrow.down.circle.fill")
            ) { }
            DSButton(
                "Continue",
                variant: .outline,
                trailingIcon: Image(systemName: "arrow.right")
            ) { }
            DSButton(
                "Share",
                variant: .secondary,
                leadingIcon: Image(systemName: "square.and.arrow.up")
            ) { }
        }
        .padding()
        .background(Color(.systemBackground))
    }
}
#endif
