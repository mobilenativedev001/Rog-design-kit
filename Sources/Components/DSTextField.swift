// DSTextField.swift
// Rogers iOS Design System
//
// Enterprise-grade, token-driven text field component for SwiftUI.
//
// Figma reference: https://www.figma.com/design/xcGZSaCf2gcFMmzzZmAxrn/Chatr-POC?node-id=5-481
//
// Design spec (extracted from Figma node 5:481):
//   • Background   : white (surface token)
//   • Border       : 1 pt #6E339E focused (ds-br-feedback-callout), gray at rest
//   • Border radius: 19.5 pt (pill-like rounded rectangle)
//   • Leading pad  : 16 pt  (Figma pl-25px approximated to even token)
//   • Vertical pad : 12 pt  (Figma py-7/8px scaled for 44 pt touch target)
//   • Font         : TedNext-Medium 16 pt → UIFontMetrics scaled for Dynamic Type
//   • Text colour  : #1F1F1F → RDSToken.Color.textPrimary
//
// States:
//   idle · focused · valid · invalid · disabled
//
// Usage — simple:
//   @State private var email = ""
//   DSTextField("Email", placeholder: "you@rogers.com", text: $email)
//
// Usage — full configuration:
//   DSTextField(configuration: .email(), text: $email)
//
// Usage — with explicit validation trigger:
//   DSTextField(.email(), text: $email, externalResult: $serverError)

import SwiftUI
import Tokens

// MARK: - DSTextField

public struct DSTextField: View {

    // MARK: Stored properties

    private let configuration: DSTextFieldConfiguration
    @Binding private var text: String

    /// Override validation result from an external source (e.g. server response).
    /// When non-nil and not `.idle`, it supersedes the locally computed result.
    @Binding private var externalResult: DSValidationResult

    // MARK: Internal state

    @State private var isFocused:            Bool = false
    @State private var isSecureTextVisible:  Bool = false
    @State private var localResult:          DSValidationResult = .idle

    // MARK: Computed effective result

    private var effectiveResult: DSValidationResult {
        // External result (server error, etc.) takes precedence over local.
        if externalResult != .idle { return externalResult }
        return localResult
    }

    // MARK: Initialisers

    /// Convenience initialiser — label and placeholder as positional strings.
    ///
    /// - Parameters:
    ///   - label:          Optional label displayed above the field.
    ///   - placeholder:    Placeholder shown when field is empty.
    ///   - helperText:     Hint shown below field (replaced by error when invalid).
    ///   - styleVariant:   Visual frame treatment (default: `.outlined`).
    ///   - isSecure:       Masks text and shows show/hide toggle.
    ///   - isDisabled:     Non-interactive muted state.
    ///   - validators:     Ordered validation pipeline.
    ///   - validateOnChange: Validate on every keystroke.
    ///   - prefixIcon:     Left icon (decorative).
    ///   - suffixIcon:     Right icon (tappable when `onSuffixIconTap` is set).
    ///   - onSuffixIconTap: Action for tappable suffix icon.
    ///   - text:           Two-way binding for the input string.
    ///   - externalResult: Two-way binding for an externally supplied validation result.
    public init(
        _ label: String? = nil,
        placeholder: String = "",
        helperText: String? = nil,
        styleVariant: DSTextFieldStyleVariant = .outlined,
        isSecure: Bool = false,
        isDisabled: Bool = false,
        validators: [any DSTextFieldValidator] = [],
        validateOnChange: Bool = false,
        prefixIcon: Image? = nil,
        suffixIcon: Image? = nil,
        onSuffixIconTap: (() -> Void)? = nil,
        text: Binding<String>,
        externalResult: Binding<DSValidationResult> = .constant(.idle)
    ) {
        self.configuration = DSTextFieldConfiguration(
            label: label,
            placeholder: placeholder,
            helperText: helperText,
            styleVariant: styleVariant,
            isSecure: isSecure,
            isDisabled: isDisabled,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            onSuffixIconTap: onSuffixIconTap,
            validators: validators,
            validateOnChange: validateOnChange
        )
        self._text           = text
        self._externalResult = externalResult
    }

    /// Configuration-based initialiser.
    ///
    ///     DSTextField(configuration: .email(), text: $email)
    public init(
        configuration: DSTextFieldConfiguration,
        text: Binding<String>,
        externalResult: Binding<DSValidationResult> = .constant(.idle)
    ) {
        self.configuration   = configuration
        self._text           = text
        self._externalResult = externalResult
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            labelView
            fieldContainer
                .padding(.top, configuration.label != nil
                    ? DSTextFieldMetrics.labelBottomSpacing : 0)
            helperRow
                .padding(.top, DSTextFieldMetrics.helperTextTopSpacing)
        }
        // Expose effective validation result and field state to VoiceOver
        .accessibilityElement(children: .contain)
        .optionalAccessibilityIdentifier(configuration.accessibilityIdentifier)
    }

    // MARK: - Label

    @ViewBuilder
    private var labelView: some View {
        if let label = configuration.label {
            Text(label)
                .font(scaledFont(size: DSTextFieldMetrics.labelFontSize, weight: .medium))
                .foregroundColor(labelTextColor)
                // Not hidden to VoiceOver — it provides context for the field
                .animation(.easeInOut(duration: 0.2), value: isFocused)
                .animation(.easeInOut(duration: 0.2), value: effectiveResult)
        }
    }

    // MARK: - Field container

    private var fieldContainer: some View {
        HStack(spacing: 8) {
            prefixIconView
            inputView
            stateIconView
            trailingActionView
        }
        .padding(.vertical, DSTextFieldMetrics.verticalPadding)
        .padding(.leading,  DSTextFieldMetrics.leadingPadding)
        .padding(.trailing, DSTextFieldMetrics.trailingPadding)
        .background(fieldBackgroundColor)
        .overlay(borderOverlay)
        .clipShape(RoundedRectangle(cornerRadius: DSTextFieldMetrics.cornerRadius,
                                   style: .continuous))
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: effectiveResult)
    }

    // MARK: - Border overlay

    @ViewBuilder
    private var borderOverlay: some View {
        let radius = DSTextFieldMetrics.cornerRadius
        let width  = activeBorderWidth

        switch configuration.styleVariant {
        case .outlined:
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(borderColor, lineWidth: width)

        case .filled:
            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .frame(height: width)
                    .foregroundColor(borderColor)
            }
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))

        case .underlined:
            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .frame(height: width)
                    .foregroundColor(borderColor)
            }
        }
    }

    // MARK: - Prefix icon

    @ViewBuilder
    private var prefixIconView: some View {
        if let icon = configuration.prefixIcon {
            icon
                .resizable()
                .scaledToFit()
                .frame(width: DSTextFieldMetrics.iconSize,
                       height: DSTextFieldMetrics.iconSize)
                .foregroundColor(iconTintColor)
                .accessibilityHidden(true)
        }
    }

    // MARK: - Input

    @ViewBuilder
    private var inputView: some View {
        Group {
            if configuration.isSecure && !isSecureTextVisible {
                // SecureField: focus change tracked via onSubmit only (iOS 13 limitation).
                // On iOS 15+, pair DSTextField with @FocusState for accurate focus tracking.
                SecureField(configuration.placeholder, text: $text)
                    .onSubmit {
                        isFocused = false
                        runValidation()
                    }
            } else {
                TextField(
                    configuration.placeholder,
                    text: $text,
                    onEditingChanged: { editing in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isFocused = editing
                        }
                        if !editing { runValidation() }
                    }
                )
            }
        }
        .font(scaledInputFont)
        .foregroundColor(inputTextColor)
        .accentColor(RDSToken.Color.fieldBorderFocusedColor)
        .disableAutocorrection(!configuration.autocorrection)
        // swiftlint:disable:next legacy_autocapitalization
        .autocapitalization(configuration.autocapitalizationType)
        .keyboardType(configuration.keyboardType)
        .textContentType(configuration.textContentType)
        .disabled(configuration.isDisabled)
        .onChange(of: text) { newValue in
            // Enforce character limit
            if let limit = configuration.characterLimit, newValue.count > limit {
                text = String(newValue.prefix(limit))
            }
            // Validate on change if configured
            if configuration.validateOnChange { runValidation() }
            // Reset external result when user edits
            if externalResult != .idle { externalResult = .idle }
        }
        .accessibilityLabel(configuration.accessibilityLabel
            ?? configuration.label
            ?? configuration.placeholder)
        .accessibilityHint(configuration.accessibilityHint ?? "")
        .accessibilityValue(accessibilityStateValue)
    }

    // MARK: - State icon (validation feedback)

    @ViewBuilder
    private var stateIconView: some View {
        switch effectiveResult {
        case .invalid:
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: DSTextFieldMetrics.iconSize,
                       height: DSTextFieldMetrics.iconSize)
                .foregroundColor(RDSToken.Color.errorColor)
                .transition(.opacity.combined(with: .scale))
                .accessibilityHidden(true)

        case .valid where !text.isEmpty:
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: DSTextFieldMetrics.iconSize,
                       height: DSTextFieldMetrics.iconSize)
                .foregroundColor(RDSToken.Color.successColor)
                .transition(.opacity.combined(with: .scale))
                .accessibilityHidden(true)

        default:
            EmptyView()
        }
    }

    // MARK: - Trailing action (show/hide toggle or tappable suffix icon)

    @ViewBuilder
    private var trailingActionView: some View {
        if configuration.isSecure {
            Button {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isSecureTextVisible.toggle()
                }
            } label: {
                Image(systemName: isSecureTextVisible ? "eye.slash.fill" : "eye.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: DSTextFieldMetrics.iconSize,
                           height: DSTextFieldMetrics.iconSize)
                    .foregroundColor(iconTintColor)
            }
            .accessibilityLabel(isSecureTextVisible ? "Hide password" : "Show password")

        } else if let icon = configuration.suffixIcon {
            let hasTap = configuration.onSuffixIconTap != nil
            Group {
                if hasTap {
                    Button { configuration.onSuffixIconTap?() } label: {
                        iconImage(icon)
                    }
                } else {
                    iconImage(icon).accessibilityHidden(true)
                }
            }
        }
    }

    private func iconImage(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: DSTextFieldMetrics.iconSize,
                   height: DSTextFieldMetrics.iconSize)
            .foregroundColor(iconTintColor)
    }

    // MARK: - Helper / error row

    @ViewBuilder
    private var helperRow: some View {
        let message = currentHelperMessage
        if let message = message {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                if case .invalid = effectiveResult {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: DSTextFieldMetrics.helperFontSize))
                        .foregroundColor(RDSToken.Color.errorColor)
                        .accessibilityHidden(true)
                }
                Text(message)
                    .font(scaledFont(size: DSTextFieldMetrics.helperFontSize))
                    .foregroundColor(helperTextColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel(helperAccessibilityLabel(message))

                if let limit = configuration.characterLimit {
                    Spacer()
                    Text("\(text.count)/\(limit)")
                        .font(scaledFont(size: DSTextFieldMetrics.helperFontSize))
                        .foregroundColor(RDSToken.Color.textSecondaryColor)
                        .monospacedDigit()
                }
            }
            .transition(.opacity.combined(with: .move(edge: .top)))
        } else if let limit = configuration.characterLimit {
            HStack {
                Spacer()
                Text("\(text.count)/\(limit)")
                    .font(scaledFont(size: DSTextFieldMetrics.helperFontSize))
                    .foregroundColor(RDSToken.Color.textSecondaryColor)
                    .monospacedDigit()
            }
        }
    }

    // MARK: - Validation

    private func runValidation() {
        guard !configuration.validators.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            localResult = dsRunValidators(text, validators: configuration.validators)
        }
    }

    // MARK: - Token-driven colour resolution

    private var borderColor: Color {
        if configuration.isDisabled { return RDSToken.Color.fieldBorderDefaultColor.opacity(0.4) }
        if case .invalid = effectiveResult { return RDSToken.Color.errorColor }
        if isFocused { return RDSToken.Color.fieldBorderFocusedColor }
        return RDSToken.Color.fieldBorderDefaultColor
    }

    private var activeBorderWidth: CGFloat {
        isFocused || effectiveResult != .idle
            ? DSTextFieldMetrics.activeBorderWidth
            : DSTextFieldMetrics.borderWidth
    }

    private var fieldBackgroundColor: Color {
        if configuration.isDisabled { return RDSToken.Color.fieldBackgroundDisabledColor }
        return RDSToken.Color.fieldBackgroundColor
    }

    private var inputTextColor: Color {
        configuration.isDisabled
            ? RDSToken.Color.textDisabledColor
            : RDSToken.Color.textPrimaryColor
    }

    private var labelTextColor: Color {
        if configuration.isDisabled { return RDSToken.Color.textDisabledColor }
        if case .invalid = effectiveResult { return RDSToken.Color.errorColor }
        if isFocused { return RDSToken.Color.fieldBorderFocusedColor }
        return RDSToken.Color.textSecondaryColor
    }

    private var helperTextColor: Color {
        if case .invalid = effectiveResult { return RDSToken.Color.errorColor }
        return RDSToken.Color.textSecondaryColor
    }

    private var iconTintColor: Color {
        if configuration.isDisabled { return RDSToken.Color.textDisabledColor }
        if case .invalid = effectiveResult { return RDSToken.Color.errorColor }
        if isFocused { return RDSToken.Color.fieldBorderFocusedColor }
        return RDSToken.Color.textSecondaryColor
    }

    // MARK: - Content helpers

    private var currentHelperMessage: String? {
        if let errorMsg = effectiveResult.errorMessage { return errorMsg }
        return configuration.helperText
    }

    // MARK: - Accessibility helpers

    private var accessibilityStateValue: String {
        switch effectiveResult {
        case .idle:               return ""
        case .valid:              return "Valid"
        case .invalid(let msg):   return "Error: \(msg)"
        }
    }

    private func helperAccessibilityLabel(_ message: String) -> String {
        switch effectiveResult {
        case .invalid: return "Error: \(message)"
        default:       return message
        }
    }

    // MARK: - Typography (Dynamic Type aware)

    /// Returns a font that uses the Rogers brand typeface when available,
    /// scaled with `UIFontMetrics` so it responds to the user's Dynamic Type setting.
    private func scaledFont(
        size: CGFloat,
        weight: Font.Weight = .regular,
        textStyle: UIFont.TextStyle = .body
    ) -> Font {
        if let baseFont = UIFont(name: "TedNext-Medium", size: size) {
            let scaled = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
            return Font(scaled)
        }
        return .system(size: size, weight: weight)
    }

    private var scaledInputFont: Font {
        scaledFont(size: DSTextFieldMetrics.inputFontSize, weight: .regular, textStyle: .body)
    }
}

// MARK: - View helper: conditional accessibility identifier

private extension View {
    @ViewBuilder
    func optionalAccessibilityIdentifier(_ id: String?) -> some View {
        if let id = id { self.accessibilityIdentifier(id) } else { self }
    }
}

// MARK: - Previews

#if DEBUG
struct DSTextField_Previews: PreviewProvider {

    // MARK: All states – light

    static var previews: some View {
        Group {
            statesPreview
                .preferredColorScheme(.light)
                .previewDisplayName("States – Light")

            statesPreview
                .preferredColorScheme(.dark)
                .previewDisplayName("States – Dark")

            variantsPreview
                .preferredColorScheme(.light)
                .previewDisplayName("Style Variants")

            validationPreview
                .preferredColorScheme(.light)
                .previewDisplayName("Validation & Helper")

            iconsPreview
                .preferredColorScheme(.light)
                .previewDisplayName("Prefix / Suffix Icons")

            securePreview
                .preferredColorScheme(.light)
                .previewDisplayName("Secure Input")

            formPreview
                .preferredColorScheme(.light)
                .previewDisplayName("Sign-in Form")
        }
    }

    // MARK: – States

    static var statesPreview: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Idle
                DSTextField(
                    "Username",
                    placeholder: "Enter username",
                    text: .constant("")
                )

                // Focused (simulated with a pre-filled value)
                DSTextField(
                    "Email (focused look)",
                    placeholder: "you@rogers.com",
                    text: .constant("user@rogers.com")
                )

                // Valid
                DSTextField(
                    "Email (valid)",
                    placeholder: "you@rogers.com",
                    validators: [DSEmailValidator()],
                    text: .constant("user@rogers.com"),
                    externalResult: .constant(.valid)
                )

                // Error
                DSTextField(
                    "Email (error)",
                    placeholder: "you@rogers.com",
                    text: .constant("not-an-email"),
                    externalResult: .constant(.invalid(message: "Please enter a valid email address."))
                )

                // Disabled
                DSTextField(
                    "Username (disabled)",
                    placeholder: "Unavailable",
                    isDisabled: true,
                    text: .constant("jsmith")
                )
            }
            .padding()
            .background(Color(.systemBackground))
        }
    }

    // MARK: – Style Variants

    static var variantsPreview: some View {
        VStack(spacing: 20) {
            DSTextField(
                "Outlined (default)",
                placeholder: "Figma node 5:481",
                styleVariant: .outlined,
                text: .constant("")
            )
            DSTextField(
                "Filled",
                placeholder: "Filled variant",
                styleVariant: .filled,
                text: .constant("")
            )
            DSTextField(
                "Underlined",
                placeholder: "Underlined variant",
                styleVariant: .underlined,
                text: .constant("")
            )
        }
        .padding()
        .background(Color(.systemBackground))
    }

    // MARK: – Validation

    static var validationPreview: some View {
        VStack(spacing: 20) {
            DSTextField(
                "Email",
                placeholder: "you@rogers.com",
                helperText: "We'll never share your email.",
                validators: [DSRequiredValidator(), DSEmailValidator()],
                validateOnChange: true,
                text: .constant("bad-input")
            )
            DSTextField(
                "Password",
                placeholder: "Enter password",
                helperText: "Minimum 8 characters.",
                isSecure: false,  // shown for preview legibility
                validators: [DSRequiredValidator(), DSMinLengthValidator(minLength: 8)],
                text: .constant("short"),
                externalResult: .constant(.invalid(message: "Must be at least 8 characters."))
            )
            DSTextField(
                "Postal code",
                placeholder: "A1A 1A1",
                helperText: "Canadian postal code.",
                validators: [DSRequiredValidator(), DSPostalCodeValidator()],
                text: .constant("M5V 3A8"),
                externalResult: .constant(.valid)
            )
        }
        .padding()
        .background(Color(.systemBackground))
    }

    // MARK: – Icons

    static var iconsPreview: some View {
        VStack(spacing: 20) {
            DSTextField(
                "Search",
                placeholder: "Search channels...",
                prefixIcon: Image(systemName: "magnifyingglass"),
                text: .constant("")
            )
            DSTextField(
                "Phone number",
                placeholder: "+1 (416) 555-0100",
                prefixIcon: Image(systemName: "phone"),
                text: .constant("")
            )
            DSTextField(
                "Promo code",
                placeholder: "Enter code",
                suffixIcon: Image(systemName: "qrcode.viewfinder"),
                onSuffixIconTap: { },
                text: .constant("")
            )
        }
        .padding()
        .background(Color(.systemBackground))
    }

    // MARK: – Secure input

    static var securePreview: some View {
        VStack(spacing: 20) {
            DSTextField(
                "Password",
                placeholder: "Enter password",
                isSecure: true,
                validators: [DSRequiredValidator(), DSMinLengthValidator(minLength: 8)],
                text: .constant("s3cr3tP@ss")
            )
            DSTextField(
                "Confirm password",
                placeholder: "Re-enter password",
                isSecure: true,
                text: .constant("")
            )
        }
        .padding()
        .background(Color(.systemBackground))
    }

    // MARK: – Realistic form

    static var formPreview: some View {
        VStack(spacing: 20) {
            Text("Sign in to Chatr")
                .font(.title2.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            DSTextField(configuration: .email(), text: .constant(""))
            DSTextField(configuration: .password(), text: .constant(""))

            DSButton("Sign in", variant: .primary) { }
            DSButton("Forgot password?", variant: .ghost) { }
        }
        .padding(24)
        .background(Color(.systemBackground))
    }
}
#endif
