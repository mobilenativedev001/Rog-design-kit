# DSTextField Component Catalog

`DSTextField` is the design-system input control for single-line entry, validation, secure text, and token-driven form styling.

## Component Summary

- Module: `Components`
- Purpose: Standardize labeled input, validation feedback, helper text, and accessory icons.
- Best fit: Auth, contact forms, promo code entry, search, and structured data capture.

## When To Use It

- Use `DSTextField` for most single-line user input in SwiftUI.
- Use configuration factories like `.email()`, `.password()`, and `.phone()` when they match the screen need.
- Use validators and helper text for guided entry and inline feedback.

Avoid it for multiline text entry or large freeform content.

## API And Companion Types

Simple form:

```swift
@State private var email = ""

DSTextField(configuration: .email(), text: $email)
```

Custom input:

```swift
@State private var promoCode = ""

DSTextField(
    "Promo code",
    placeholder: "Enter code",
    suffixIcon: Image(systemName: "qrcode.viewfinder"),
    onSuffixIconTap: { scanCode() },
    text: $promoCode
)
```

Companion types:

- `DSTextFieldConfiguration`
- `DSTextFieldStyleVariant`: `outlined`, `filled`, `underlined`
- `DSTextFieldMetrics`
- `DSValidationResult`
- Validators: `DSRequiredValidator`, `DSMinLengthValidator`, `DSMaxLengthValidator`, `DSEmailValidator`, `DSPhoneValidator`, `DSPostalCodeValidator`, `DSRegexValidator`, `DSCustomValidator`
- `dsRunValidators`

## Variants, States, And Behaviors

- Style variants: `outlined`, `filled`, `underlined`.
- States: idle, focused, valid, invalid, disabled.
- Behavior options: secure entry, prefix icon, suffix icon, helper text, character limits, external validation override.
- Validation can run on change or on blur depending on configuration.

## Accessibility Notes

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