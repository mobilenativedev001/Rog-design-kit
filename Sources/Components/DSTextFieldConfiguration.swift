// DSTextFieldConfiguration.swift
// Rogers iOS Design System
//
// Figma reference: https://www.figma.com/design/xcGZSaCf2gcFMmzzZmAxrn/Chatr-POC?node-id=5-481
//
// Data layer + style variant definitions for DSTextField.
// All visual logic lives in DSTextField; this file is pure data.

import SwiftUI
import UIKit

// MARK: - DSTextFieldStyleVariant

/// Controls the visual frame treatment of the field container.
///
/// | Variant     | Frame                              | Figma usage          |
/// |-------------|------------------------------------|----------------------|
/// | outlined    | Full rounded border                | Primary (node 5:481) |
/// | filled      | Filled bg + bottom separator       | Dense forms          |
/// | underlined  | Bottom border only                 | Minimal / in-context |
public enum DSTextFieldStyleVariant: String, CaseIterable {
    /// Full rounded border — matches Figma Chatr-POC node 5:481.
    /// Border radius: 19.5 pt, border width: 1 pt.
    case outlined

    /// Filled background with a 1 pt bottom separator and no side borders.
    /// Corner radius applied only to the top two corners.
    case filled

    /// Bottom border only — minimal footprint for tight form layouts.
    case underlined
}

// MARK: - DSTextFieldMetrics

/// Canonical layout constants derived from Figma node 5:481 (366 × 39 px).
public enum DSTextFieldMetrics {
    /// Border-radius from Figma `rounded-[19.5px]`.
    public static let cornerRadius: CGFloat = 19.5
    /// Resting border width.
    public static let borderWidth: CGFloat = 1.0
    /// Focused / error border width (slightly thicker for emphasis).
    public static let activeBorderWidth: CGFloat = 1.5
    /// Vertical inset inside the field container — balances to ≥44 pt touch target.
    public static let verticalPadding: CGFloat = 12
    /// Horizontal inset — generous left side mirrors Figma `pl-[25px]`.
    public static let leadingPadding: CGFloat = 16
    public static let trailingPadding: CGFloat = 12
    /// Icon/suffix glyph bounding box.
    public static let iconSize: CGFloat = 20
    /// Gap between the field container bottom and helper/error text.
    public static let helperTextTopSpacing: CGFloat = 6
    /// Gap between the label and field container.
    public static let labelBottomSpacing: CGFloat = 6
    /// Font size for the input text (matches Figma `ds-body-r-font-size`).
    public static let inputFontSize: CGFloat = 16
    /// Font size for the floating label above the field.
    public static let labelFontSize: CGFloat = 14
    /// Font size for helper and error text below the field.
    public static let helperFontSize: CGFloat = 12
}

// MARK: - DSTextFieldConfiguration

/// A value-type aggregate of all properties that control a `DSTextField`'s
/// behaviour and appearance. Decouples the caller from the rendering layer.
public struct DSTextFieldConfiguration {

    // MARK: Content

    /// Optional label displayed above the field.
    public var label: String?

    /// Placeholder text shown when the field is empty.
    public var placeholder: String

    /// Secondary hint displayed below the field when there is no validation error.
    public var helperText: String?

    // MARK: Style

    /// Visual frame treatment for the field container.
    public var styleVariant: DSTextFieldStyleVariant

    // MARK: Input behaviour

    /// When `true`, text is masked and a show/hide toggle is rendered.
    public var isSecure: Bool

    /// When `true`, the field is non-interactive and rendered with muted tokens.
    public var isDisabled: Bool

    /// UIKit keyboard type forwarded to the underlying `TextField`.
    public var keyboardType: UIKeyboardType

    /// Return-key label shown on the software keyboard.
    public var returnKeyType: UIReturnKeyType

    /// Autocapitalization behaviour forwarded to the underlying `TextField`.
    public var autocapitalizationType: UITextAutocapitalizationType

    /// Whether autocorrect is enabled.
    public var autocorrection: Bool

    /// Semantic content type hint for AutoFill (e.g. `.emailAddress`, `.password`).
    public var textContentType: UITextContentType?

    /// Maximum number of characters allowed. `nil` means unlimited.
    public var characterLimit: Int?

    // MARK: Icons

    /// Icon rendered to the left of the input text.
    public var prefixIcon: Image?

    /// Icon rendered to the right of the input text (ignored when `isSecure` is `true`).
    public var suffixIcon: Image?

    /// Action invoked when the user taps `suffixIcon`. When `nil` the icon is decorative.
    public var onSuffixIconTap: (() -> Void)?

    // MARK: Validation

    /// Ordered list of validators run against the field text.
    public var validators: [any DSTextFieldValidator]

    /// Run validation on every keystroke (live feedback).
    public var validateOnChange: Bool

    /// Run validation when focus leaves the field (default, less intrusive).
    public var validateOnBlur: Bool

    // MARK: Accessibility

    /// VoiceOver label override (defaults to `label ?? placeholder`).
    public var accessibilityLabel: String?

    /// VoiceOver hint describing what happens when the field is activated.
    public var accessibilityHint: String?

    /// Identifier used by UI automation test frameworks (XCUITest / Espresso).
    public var accessibilityIdentifier: String?

    // MARK: Init

    public init(
        label: String? = nil,
        placeholder: String = "",
        helperText: String? = nil,
        styleVariant: DSTextFieldStyleVariant = .outlined,
        isSecure: Bool = false,
        isDisabled: Bool = false,
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        autocorrection: Bool = true,
        textContentType: UITextContentType? = nil,
        characterLimit: Int? = nil,
        prefixIcon: Image? = nil,
        suffixIcon: Image? = nil,
        onSuffixIconTap: (() -> Void)? = nil,
        validators: [any DSTextFieldValidator] = [],
        validateOnChange: Bool = false,
        validateOnBlur: Bool = true,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.label                  = label
        self.placeholder            = placeholder
        self.helperText             = helperText
        self.styleVariant           = styleVariant
        self.isSecure               = isSecure
        self.isDisabled             = isDisabled
        self.keyboardType           = keyboardType
        self.returnKeyType          = returnKeyType
        self.autocapitalizationType = autocapitalizationType
        self.autocorrection         = autocorrection
        self.textContentType        = textContentType
        self.characterLimit         = characterLimit
        self.prefixIcon             = prefixIcon
        self.suffixIcon             = suffixIcon
        self.onSuffixIconTap        = onSuffixIconTap
        self.validators             = validators
        self.validateOnChange       = validateOnChange
        self.validateOnBlur         = validateOnBlur
        self.accessibilityLabel     = accessibilityLabel
        self.accessibilityHint      = accessibilityHint
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

// MARK: - DSTextFieldConfiguration convenience factories

public extension DSTextFieldConfiguration {

    /// Pre-configured email field.
    static func email(label: String = "Email", placeholder: String = "you@example.com") -> DSTextFieldConfiguration {
        DSTextFieldConfiguration(
            label: label,
            placeholder: placeholder,
            keyboardType: .emailAddress,
            autocapitalizationType: .none,
            autocorrection: false,
            textContentType: .emailAddress,
            validators: [DSRequiredValidator(), DSEmailValidator()]
        )
    }

    /// Pre-configured password field (secure input + strength hint).
    static func password(
        label: String = "Password",
        placeholder: String = "Enter password",
        minLength: Int = 8
    ) -> DSTextFieldConfiguration {
        DSTextFieldConfiguration(
            label: label,
            placeholder: placeholder,
            helperText: "Must be at least \(minLength) characters.",
            isSecure: true,
            autocapitalizationType: .none,
            autocorrection: false,
            textContentType: .password,
            validators: [DSRequiredValidator(), DSMinLengthValidator(minLength: minLength)]
        )
    }

    /// Pre-configured phone number field.
    static func phone(
        label: String = "Phone number",
        placeholder: String = "e.g. 416-555-0100"
    ) -> DSTextFieldConfiguration {
        DSTextFieldConfiguration(
            label: label,
            placeholder: placeholder,
            keyboardType: .phonePad,
            textContentType: .telephoneNumber,
            validators: [DSRequiredValidator(), DSPhoneValidator()]
        )
    }
}
