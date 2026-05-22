// DSButtonStyle.swift
// Rogers iOS Design System
//
// A SwiftUI `ButtonStyle` implementation that translates DSButtonVariant,
// DSButtonSize, and interaction state into precise token-driven visual output.
//
// Design tokens come from `RDSToken.Color` (Colors.swift) which implements
// dynamic UIColor for automatic light/dark-mode and high-contrast support.
//
// Architecture:
//   DSButtonStyle (public ButtonStyle) ─► _DSButtonBody (private View)
//
// The inner _DSButtonBody view is necessary so that @Environment values
// (isEnabled, isFocused) are read at render time, not at ButtonStyle init time.

import SwiftUI
import Tokens

// MARK: - Internal button state

/// Resolved at render time from SwiftUI environment + configuration.
/// Drives all token lookups; avoids scattered if/else chains.
enum _DSButtonState {
    case normal
    case pressed
    case loading
    case disabled
    case focused   // iPad / external-keyboard focus ring (iOS 14+)
}

// MARK: - DSButtonStyle

/// Apply via `.buttonStyle(DSButtonStyle(variant:size:isLoading:))`.
///
/// ```swift
/// Button("Sign in") { signIn() }
///     .buttonStyle(DSButtonStyle(variant: .primary, size: .medium))
/// ```
public struct DSButtonStyle: ButtonStyle {

    public let variant: DSButtonVariant
    public let size: DSButtonSize
    public let isLoading: Bool

    public init(
        variant: DSButtonVariant = .primary,
        size: DSButtonSize = .medium,
        isLoading: Bool = false
    ) {
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
    }

    public func makeBody(configuration: Configuration) -> some View {
        _DSButtonBody(
            configuration: configuration,
            variant: variant,
            size: size,
            isLoading: isLoading
        )
    }
}

// MARK: - _DSButtonBody (internal rendering view)

struct _DSButtonBody: View {

    let configuration: ButtonStyleConfiguration
    let variant: DSButtonVariant
    let size: DSButtonSize
    let isLoading: Bool

    @Environment(\.isEnabled) private var isEnabled

    // MARK: State resolution

    private var buttonState: _DSButtonState {
        guard isEnabled else { return .disabled }
        if isLoading            { return .loading }
        if configuration.isPressed { return .pressed }
        return .normal
    }

    // MARK: Body

    var body: some View {
        ZStack {
            // Hidden label keeps the button the same width during loading
            labelContent
                .opacity(isLoading ? 0 : 1)
                .accessibility(hidden: isLoading)

            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(size.spinnerScale)
            }
        }
        .font(buttonFont)
        .foregroundColor(foregroundColor)
        .padding(.vertical, size.verticalPadding)
        .padding(.horizontal, size.horizontalPadding)
        .frame(maxWidth: .infinity, minHeight: size.minHeight)
        .background(buttonBackground)
        .overlay(borderOverlay)
        .clipShape(Capsule())
        .overlay(focusRingOverlay)          // iOS 14+ focus ring
        .scaleEffect(buttonState == .pressed ? 0.97 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        .animation(.easeInOut(duration: 0.1), value: isEnabled)
    }

    // MARK: - Sub-views

    @ViewBuilder
    private var labelContent: some View {
        configuration.label
    }

    @ViewBuilder
    private var buttonBackground: some View {
        switch variant {
        case .outline, .ghost:
            // Tinted fill only appears when pressed; stays clear otherwise
            backgroundColor
        default:
            backgroundColor
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        switch variant {
        case .outline:
            Capsule().strokeBorder(outlineBorderColor, lineWidth: 2)
        default:
            EmptyView()
        }
    }

    /// Focus ring using `@Environment(\.isFocused)` — requires iOS 14.
    @ViewBuilder
    private var focusRingOverlay: some View {
        if #available(iOS 14.0, *) {
            _FocusRingOverlay(color: focusRingColor)
        }
    }

    // MARK: - Token-driven color resolution

    /// Foreground (label + icon + spinner tint) color.
    var foregroundColor: Color {
        switch buttonState {
        case .disabled:
            return RDSToken.Color.buttonDisabledForegroundColor

        default:
            switch variant {
            case .primary, .secondary, .destructive:
                return Color.white
            case .outline, .ghost:
                return RDSToken.Color.buttonPrimaryBackgroundColor
            }
        }
    }

    /// Button fill color (clear for outline/ghost at rest).
    private var backgroundColor: Color {
        switch buttonState {
        case .disabled:
            switch variant {
            case .outline, .ghost: return Color.clear
            default: return RDSToken.Color.buttonDisabledBackgroundColor
            }

        case .pressed:
            switch variant {
            case .primary:
                return RDSToken.Color.buttonPrimaryPressedBackgroundColor
            case .secondary:
                return RDSToken.Color.buttonSecondaryPressedBackgroundColor
            case .destructive:
                return RDSToken.Color.buttonDestructivePressedBackgroundColor
            case .outline, .ghost:
                return RDSToken.Color.buttonPrimaryBackgroundColor.opacity(0.10)
            }

        case .loading, .normal, .focused:
            switch variant {
            case .primary:
                return RDSToken.Color.buttonPrimaryBackgroundColor
            case .secondary:
                return RDSToken.Color.buttonSecondaryBackgroundColor
            case .destructive:
                return RDSToken.Color.errorColor
            case .outline, .ghost:
                return Color.clear
            }
        }
    }

    /// Border stroke color used by the `outline` variant.
    private var outlineBorderColor: Color {
        switch buttonState {
        case .disabled:
            return RDSToken.Color.buttonDisabledBackgroundColor
        default:
            return RDSToken.Color.buttonPrimaryBackgroundColor
        }
    }

    /// Keyboard / accessibility focus ring color.
    private var focusRingColor: Color {
        switch variant {
        case .primary, .secondary, .destructive:
            return Color.white.opacity(0.6)
        case .outline, .ghost:
            return RDSToken.Color.buttonPrimaryBackgroundColor
        }
    }

    // MARK: - Typography

    /// Resolves the button font.
    /// Tries the Rogers brand font "TedNext-Medium" (registered via RDSCore);
    /// falls back to the system medium weight at the correct size.
    private var buttonFont: Font {
        if let uiFont = UIFont(name: "TedNext-Medium", size: size.fontSize) {
            return Font(uiFont)
        }
        return .system(size: size.fontSize, weight: .medium)
    }
}

// MARK: - Focus ring overlay (iOS 14+)

@available(iOS 14.0, *)
private struct _FocusRingOverlay: View {

    let color: Color
    @Environment(\.isFocused) private var isFocused

    var body: some View {
        if isFocused {
            Capsule()
                .strokeBorder(color, lineWidth: 3)
                .padding(-4)   // extends slightly beyond the button edge
        }
    }
}
