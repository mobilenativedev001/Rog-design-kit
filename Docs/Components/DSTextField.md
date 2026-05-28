# DSTextField

Enterprise-grade, token-driven single-line text input for SwiftUI. Supports labeled fields, three visual frame variants, composable validation pipeline, secure entry, prefix/suffix icons, helper text, and external validation override. Matches Figma Chatr-POC node 5:481.

---

## Component Summary

| Field | Value |
|---|---|
| Module | `Components` |
| UIKit support | `DSTextFieldHostingController`, `DSTextFieldView` in `UIKitCompat` |
| Figma | Node 5:481 |
| Default variant | `.outlined` — 19.5 pt corner radius, 1 pt border |
| Min touch target | 44 pt (via 12 pt vertical padding + input font) |

---

## When to Use It

- Use `DSTextField` for all single-line free-text entry that must follow design-system styling.
- Use configuration factories (`.email()`, `.password()`, `.phone()`) when they match — they encode the correct keyboard type, validators, and accessibility defaults.
- Use `externalResult` to pipe server-side validation errors directly into the field's inline error state.
- Use `validateOnChange: true` only for permissive fields (character counts, length checks) not for email/password (too noisy on first keystroke).

**Avoid** `DSTextField` for:
- Multi-line entry — SwiftUI's `TextEditor` or a custom wrapper is appropriate
- Read-only display — use `DSLabel`
- Search bars with real-time filtering — consider a `searchable` modifier or a dedicated search component

---

## API and Companion Types

### DSTextField — Initialisers

```swift
// Inline convenience
@State private var email = ""
DSTextField("Email", placeholder: "you@rogers.com", text: $email)

// Full configuration inline
DSTextField(
    "Phone number",
    placeholder: "(416) 555-0100",
    helperText: "Canadian number, 10 digits",
    validators: [DSRequiredValidator(), DSPhoneValidator()],
    text: $phone
)

// Factory-based (recommended for common field types)
DSTextField(configuration: .email(), text: $email)
DSTextField(configuration: .password(), text: $password)

// External validation result (e.g. server error)
DSTextField(
    configuration: .email(),
    text: $email,
    externalResult: $serverError
)
```

### DSTextFieldConfiguration

Value-type aggregate for all field properties.

```swift
public struct DSTextFieldConfiguration {
    var label: String?
    var placeholder: String
    var helperText: String?
    var styleVariant: DSTextFieldStyleVariant   // default: .outlined
    var isSecure: Bool                           // default: false
    var isDisabled: Bool                         // default: false
    var keyboardType: UIKeyboardType             // default: .default
    var returnKeyType: UIReturnKeyType           // default: .default
    var autocapitalizationType: UITextAutocapitalizationType
    var prefixIcon: Image?
    var suffixIcon: Image?
    var onSuffixIconTap: (() -> Void)?
    var validators: [any DSTextFieldValidator]
    var validateOnChange: Bool
    var accessibilityLabel: String?
    var accessibilityHint: String?
    var accessibilityIdentifier: String?
}
```

**Built-in factory presets:**

```swift
DSTextFieldConfiguration.email()
DSTextFieldConfiguration.password()
DSTextFieldConfiguration.phone()
```

### DSTextFieldStyleVariant

| Value | Frame | Figma usage |
|---|---|---|
| `.outlined` | Full rounded border (19.5 pt radius) | Primary — node 5:481 |
| `.filled` | Filled bg + bottom separator, rounded top corners | Dense forms |
| `.underlined` | Bottom border only | Minimal / in-context |

### DSTextFieldMetrics

Canonical layout constants from Figma node 5:481:

| Constant | Value | Source |
|---|---|---|
| `cornerRadius` | 19.5 pt | Figma `rounded-[19.5px]` |
| `borderWidth` | 1.0 pt | Resting |
| `activeBorderWidth` | 1.5 pt | Focused / error |
| `verticalPadding` | 12 pt | ≥44 pt touch target |
| `leadingPadding` | 16 pt | Figma `pl-[25px]` approx |
| `trailingPadding` | 12 pt | |
| `iconSize` | 20 pt | |
| `inputFontSize` | 16 pt | `ds-body-r-font-size` |
| `labelFontSize` | 14 pt | Above-field label |
| `helperFontSize` | 12 pt | Below-field helper/error |

---

## Validation

### DSValidationResult

```swift
public enum DSValidationResult: Equatable {
    case idle              // not yet touched
    case valid             // all validators passed
    case invalid(message: String)  // shown as inline error text
}
```

Use `externalResult` binding to inject server-side errors:

```swift
@State private var serverError: DSValidationResult = .idle

DSTextField(
    configuration: .email(),
    text: $email,
    externalResult: $serverError
)

// After API call:
serverError = .invalid(message: "No account found for this email.")
```

### Built-in Validators

| Validator | Usage |
|---|---|
| `DSRequiredValidator(message:)` | Fails on empty / whitespace-only |
| `DSMinLengthValidator(minLength:message:)` | Fails below min character count |
| `DSMaxLengthValidator(maxLength:message:)` | Fails above max character count |
| `DSEmailValidator(message:)` | RFC 5322 simplified email format |
| `DSPhoneValidator(message:)` | 10–15 digit phone (non-digits ignored) |
| `DSPostalCodeValidator(message:)` | Canadian postal code (A1A 1A1 format) |
| `DSRegexValidator(pattern:message:)` | Custom regex full match |
| `DSCustomValidator { text in ... }` | Closure-based ad-hoc rule |

Compose multiple validators in order — the first failure stops evaluation:

```swift
DSTextField(
    "Email",
    validators: [DSRequiredValidator(), DSEmailValidator()],
    text: $email
)
```

---

## Variants, States, and Behaviors

**Field states:**

| State | Border color | Background |
|---|---|---|
| Idle | `fieldBorderDefault` (gray) | `fieldBackground` (white) |
| Focused | `fieldBorderFocused` (purple `#6E339E`) | `fieldBackground` |
| Valid | Idle border (returns to resting) | `fieldBackground` |
| Invalid | `errorColor` (red) | `fieldBackground` |
| Disabled | Muted border | `fieldBackgroundDisabled` (gray-50) |

- Border transitions animate with `.easeInOut(duration: 0.2)`.
- Secure fields show a show/hide toggle (eye icon) on the trailing side automatically.
- `externalResult` overrides `localResult` when non-idle.

---

## Accessibility Notes

- The entire field (label, input, helper/error) is a single accessibility container.
- Label text provides context for VoiceOver users.
- Error messages are announced inline when validation state changes.
- `accessibilityIdentifier` propagates to the container for UI testing.
- `isSecure` adds a standard show/hide toggle that VoiceOver announces as "Show password" / "Hide password".

---

## SwiftUI Examples

### Simple email field

```swift
@State private var email = ""
DSTextField(configuration: .email(), text: $email)
```

### Password field with secure entry

```swift
@State private var password = ""
DSTextField(configuration: .password(), text: $password)
```

### Phone number with helper text

```swift
DSTextField(
    "Phone number",
    placeholder: "(416) 555-0100",
    helperText: "10-digit Canadian number",
    validators: [DSRequiredValidator(), DSPhoneValidator()],
    text: $phone
)
```

### Promo code with QR scan action

```swift
DSTextField(
    "Promo code",
    placeholder: "Enter or scan code",
    suffixIcon: Image(systemName: "qrcode.viewfinder"),
    onSuffixIconTap: { viewModel.openScanner() },
    text: $promoCode
)
```

### Filled variant (dense form layout)

```swift
DSTextField(
    "First name",
    styleVariant: .filled,
    text: $firstName
)
```

### External server-error injection

```swift
@State private var serverError: DSValidationResult = .idle

DSTextField(configuration: .email(), text: $email, externalResult: $serverError)

// After failed sign-in API call:
// serverError = .invalid(message: "Incorrect email or password.")
```

---

## UIKit Integration

### DSTextFieldHostingController

```swift
let fieldVC = DSTextFieldHostingController(
    configuration: .email(),
    onTextChange: { [weak self] text in self?.email = text },
    onValidationResultChange: { result in print(result) }
)
DSTextFieldHostingController.embed(in: self, below: headerLabel, controller: fieldVC)
```

### DSTextFieldView

Drop-in `UIView` wrapper for cells and stack views.

```swift
let fieldView = DSTextFieldView(
    configuration: .phone(),
    onTextChange: { [weak self] in self?.phone = $0 }
)
formStack.addArrangedSubview(fieldView)
```

---

## Screen Composition Guidance

### Where DSTextField sits in the screen hierarchy

- **Below** `DSPageHeader` or section headers.
- **Above** the primary `DSButton` CTA.
- Stacked vertically with 16 pt spacing between fields.
- Form area should have 24 pt horizontal padding.

### Composition recipes

**Sign-in form**
```swift
VStack(alignment: .leading, spacing: 16) {
    DSPageHeader(title: "Sign in", subtitle: "With your My Chatr credentials")
    DSTextField(configuration: .email(), text: $email)
    DSTextField(configuration: .password(), text: $password)
    DSButton("Sign in", variant: .primary, size: .large) { signIn() }
        .frame(maxWidth: .infinity)
    DSButton("Forgot password?", variant: .ghost) { resetPassword() }
}
.padding(24)
```

**Registration form with validation**
```swift
VStack(spacing: 16) {
    DSTextField("First name", placeholder: "Jane",
                validators: [DSRequiredValidator()], text: $firstName)
    DSTextField("Email", placeholder: "you@rogers.com",
                validators: [DSRequiredValidator(), DSEmailValidator()],
                text: $email)
    DSTextField("Phone", placeholder: "(416) 555-0100",
                validators: [DSRequiredValidator(), DSPhoneValidator()],
                text: $phone)
    DSTextField(configuration: .password(), text: $password)
    DSButton("Create account", variant: .primary,
             isDisabled: !formIsValid) { register() }
        .frame(maxWidth: .infinity)
}
.padding(24)
```

**Support form**
```swift
VStack(spacing: 16) {
    DSPageHeader(title: "Contact Support")
    DSTextField("Account number", validators: [DSRequiredValidator()], text: $accountNumber)
    DSTextField("Postal code", validators: [DSPostalCodeValidator()], text: $postalCode)
    DSButton("Submit", variant: .primary) { submitRequest() }
}
.padding(24)
```

---

## Related Components

| Related Component | Relationship | When to Pair |
|---|---|---|
| `DSButton` | Submit action after input | Every form with a completion action |
| `DSPageHeader` | Section context above the form | Auth, registration, account screens |
| `DSLabel` | Error/status messages alongside fields | When validation detail exceeds helper text |
| `DSPromoBanner` | Status or alert above the form | Expired session, locked account |

---

## Constraints and Caveats

- `DSTextField` is single-line only — use `TextEditor` or a custom wrapper for multi-line needs.
- Validators run in order; the first `.invalid` result stops the chain and shows its message.
- `validateOnChange: true` triggers on every keystroke — suitable for length counters, unsuitable for email/password on first entry.
- `externalResult` takes precedence over local validation when non-`.idle`; reset it to `.idle` after the user starts editing.
- `isSecure` and `prefixIcon` can coexist but the show/hide toggle always occupies the trailing position.
- The `.underlined` variant does not fully enclose the input area — avoid it for secure fields where visual containment reinforces privacy.

- Exposes label or placeholder as the accessibility label.
- Announces validation state through accessibility value.
- Includes helper and error messaging in accessibility output.

## SwiftUI Examples

Auth fields:

```swift
VStack(spacing: 16) {
    DSTextField(configuration: .email(), text: $email)
    DSTextField(configuration: .password(), text: $password)
}
```

Validation-heavy input:

```swift
DSTextField(
    "Email",
    placeholder: "you@rogers.com",
    helperText: "We'll never share your email.",
    validators: [DSRequiredValidator(), DSEmailValidator()],
    validateOnChange: true,
    text: $email
)
```

Accessory-driven input:

```swift
DSTextField(
    "Search",
    placeholder: "Search channels...",
    prefixIcon: Image(systemName: "magnifyingglass"),
    text: $query
)
```

## UIKit Integration

- `DSTextFieldHostingController`: preferred bridge when UIKit needs text and validation callbacks.
- `DSTextFieldView`: `UIView` wrapper for simpler embed cases.

Example:

```swift
let fieldVC = DSTextFieldHostingController(
    configuration: .email(),
    onTextChange: { text in print(text) }
)
```

## Screen Composition Guidance

- Common placement: under `DSPageHeader`, inside account forms, in auth stacks, or above primary submission actions.
- Pairs most often with: `DSPageHeader`, `DSButton`, `DSLabel` supporting copy.
- Recommended order: explanatory header -> input fields -> primary action.

## Related Components

| Related Component | Relationship | When to Pair |
| --- | --- | --- |
| `DSPageHeader` | Establishes context above field stack | Sign-in and settings forms |
| `DSButton` | Submits or advances after input | Auth, contact, account flows |
| `DSLabel` | Adds helper or surrounding text | Long-form explanation around fields |

## Constraints And Caveats

- The public component is single-line only.
- There is no dedicated multiline text area companion in the current repo.
- The repo strongly supports common auth and validation flows; less common enterprise input patterns may still need additional controls.