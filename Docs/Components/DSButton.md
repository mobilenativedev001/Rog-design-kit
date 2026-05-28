# DSButton

Token-driven, enterprise-grade button component for SwiftUI. Covers primary calls-to-action through low-emphasis ghost actions with full state management, Dynamic Type scaling, and WCAG tap-target compliance.

---

## Component Summary

| Field | Value |
|---|---|
| Module | `Components` |
| UIKit support | `DSButtonHostingController`, `DSButtonView` in `UIKitCompat` |
| Figma | Primary: node 5:486 · Outline: node 126:210 |
| Min tap target | 44 pt (small), 48 pt (medium), 56 pt (large) |

---

## When to Use It

- Use `DSButton` whenever a tappable action must carry design-system tokens (color, spacing, font).
- Use `.primary` for the single most important action on a screen or section.
- Use `.secondary` for equally available but lower-emphasis alternatives.
- Use `.outline` for bordered actions alongside a solid primary button.
- Use `.ghost` for in-line or tertiary actions where visual weight should be minimal.
- Use `.destructive` only for irreversible actions that require explicit user commitment.

**Avoid** `DSButton` when the control is:
- A tab selection (use `DSTabBar`)
- Passive text that links somewhere (use `DSLabel` with a `TapGesture`)
- A compound custom interaction not button-shaped

---

## API and Companion Types

### DSButton — Initialisers

```swift
// Inline convenience
DSButton("Sign in", variant: .primary) { handleSignIn() }

// With size, loading, icon
DSButton(
    "Continue",
    variant: .primary,
    size: .large,
    isLoading: isSubmitting,
    trailingIcon: Image(systemName: "arrow.right"),
    action: { handleContinue() }
)

// Configuration-based (for stored / reusable state)
let config = DSButtonConfiguration(
    title: "Delete account",
    variant: .destructive,
    size: .medium,
    accessibilityHint: "Deletes this account permanently"
)
DSButton(configuration: config) { handleDelete() }
```

### DSButtonConfiguration

Value-type aggregate that decouples call sites from the rendering layer.

```swift
public struct DSButtonConfiguration {
    var title: String
    var variant: DSButtonVariant   // default: .primary
    var size: DSButtonSize         // default: .medium
    var isLoading: Bool            // default: false
    var isDisabled: Bool           // default: false
    var leadingIcon: Image?
    var trailingIcon: Image?
    var accessibilityLabel: String?
    var accessibilityHint: String?
    var accessibilityIdentifier: String?
}
```

### DSButtonVariant

| Value | Fill | Use |
|---|---|---|
| `.primary` | Rogers brand purple (`#542E91`) | Main CTA |
| `.secondary` | Brand teal | Secondary action |
| `.outline` | Transparent + colored border | Alongside primary |
| `.destructive` | Semantic error red | Irreversible actions |
| `.ghost` | None | Tertiary / in-context |

### DSButtonSize

| Value | Min height | Vertical padding | Font size | Icon size |
|---|---|---|---|---|
| `.small` | 44 pt | 8 pt | 14 pt | 16 pt |
| `.medium` | 48 pt | 12 pt | 16 pt | 20 pt |
| `.large` | 56 pt | 16 pt | 18 pt | 22 pt |

### DSButtonStyle

Applied automatically by `DSButton`. Can be used stand-alone on a native `Button`:

```swift
Button("Retry") { retry() }
    .buttonStyle(DSButtonStyle(variant: .outline, size: .medium))
```

---

## Variants, States, and Behaviors

**States:** `normal` · `pressed` · `loading` · `disabled` · `focused`

- **loading**: spinner replaces label; tap is silently ignored; label stays invisible but retains layout width to prevent resize jank.
- **disabled**: muted gray tokens (`buttonDisabledBackground`, `buttonDisabledForeground`); no tap delivery.
- **focused**: visible focus ring (iPad / external keyboard, iOS 14+).
- **pressed**: slightly darkened fill derived from pressed-variant tokens.
- Light, dark, and high-contrast appearances handled automatically via `RDSToken.Color` dynamic `UIColor`.

---

## Accessibility Notes

- Minimum tap target is never below 44 pt (WCAG 2.5.5).
- `accessibilityLabel` defaults to `title`; override for icon-only buttons.
- `accessibilityHint` describes the outcome, not the action (e.g., "Signs you in to My Chatr").
- Loading state is announced via `accessibilityValue` update.
- `accessibilityIdentifier` is forwarded for UI testing.

---

## SwiftUI Examples

### Primary CTA on a sign-in screen

```swift
DSButton("Sign in", variant: .primary, size: .large) {
    viewModel.signIn()
}
.frame(maxWidth: .infinity)
```

### Loading state during async work

```swift
DSButton("Submit", variant: .primary, isLoading: viewModel.isSubmitting) {
    viewModel.submit()
}
```

### Outline + Ghost pair beneath a primary button

```swift
VStack(spacing: 12) {
    DSButton("Create account", variant: .primary) { createAccount() }
    DSButton("Sign in instead", variant: .ghost) { navigateToSignIn() }
}
```

### Destructive action with accessibility hint

```swift
DSButton(
    "Remove plan",
    variant: .destructive,
    accessibilityHint: "Permanently removes the selected plan from your account",
    action: { viewModel.removePlan() }
)
```

### Toolbar button (small size)

```swift
DSButton("Edit", variant: .outline, size: .small) { startEditing() }
```

---

## UIKit Integration

Use `DSButtonHostingController` for lifecycle-correct embedding inside `UIViewController`.

```swift
// Embed in viewDidLoad
let buttonVC = DSButtonHostingController(
    configuration: DSButtonConfiguration(title: "Sign in", variant: .primary),
    action: { self.handleSignIn() }
)
addChild(buttonVC)
view.addSubview(buttonVC.view)
NSLayoutConstraint.activate([
    buttonVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
    buttonVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
    buttonVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
])
buttonVC.didMove(toParent: self)
```

Use `DSButtonView` when only a `UIView` parent is available (cells, stack views):

```swift
let buttonView = DSButtonView(
    configuration: DSButtonConfiguration(title: "Add to cart"),
    action: { addItem() }
)
stackView.addArrangedSubview(buttonView)
```

Update without re-creating:

```swift
buttonVC.update(
    configuration: DSButtonConfiguration(title: "Retry", variant: .destructive),
    action: { retry() }
)
```

`RDSButtonFactory.makePrimaryButton(title:target:action:)` in `UIKitCompat` provides a plain `UIButton` with basic Rogers brand styling for legacy screens not ready for the hosting approach.

---

## Screen Composition Guidance

### Where DSButton sits in the screen hierarchy

- **Auth screens**: Full-width `.primary` pinned to the bottom safe area, above a `.ghost` link.
- **Form screens**: `.primary` at the bottom of the form stack, disabled until validation passes.
- **Detail / card**: `.outline` or `.secondary` inline within a card footer.
- **Destructive flows**: `.destructive` in an action sheet or confirmation sheet; never the first option.
- **Toolbar / navigation bar**: `.small` `.outline` or `.ghost`.

### Focused composition recipes

**Sign-in form**
```swift
VStack(spacing: 16) {
    DSPageHeader(title: "Sign in", subtitle: "With your My Chatr credentials")
    DSTextField("Email", placeholder: "you@rogers.com", text: $email)
    DSTextField("Password", isSecure: true, text: $password)
    DSButton("Sign in", variant: .primary, size: .large, isLoading: isLoading) {
        viewModel.signIn()
    }
    .frame(maxWidth: .infinity)
    DSButton("Forgot password?", variant: .ghost) { navigateToReset() }
}
.padding(24)
```

**Confirmation sheet**
```swift
VStack(spacing: 12) {
    DSLabel("Are you sure?", style: RDSToken.Typography.title4, color: .primary)
    DSLabel("This will permanently remove your plan.", color: .secondary)
    DSButton("Remove plan", variant: .destructive) { confirmRemoval() }
    DSButton("Cancel", variant: .ghost) { dismiss() }
}
.padding(24)
```

---

## Related Components

| Related Component | Relationship | When to Pair |
|---|---|---|
| `DSTextField` | Form input that precedes a submit button | Auth, registration, and search forms |
| `DSPageHeader` | Page context above the primary CTA | Every auth and onboarding screen |
| `DSPromoBanner` | Banner that frames the intent of the action | Plan upgrade and offer screens |
| `DSTabBar` | Navigation shell — does not replace buttons | App shell above screen content |
| `DSLabel` | Explanatory text below or beside a button | Secondary instruction or legal copy |

---

## Constraints and Caveats

- `DSButton` does not support multi-line labels; keep button text to a single short phrase.
- `isLoading` and `isDisabled` are mutually independent; set both if the form has not validated and the call is in flight.
- Icon images are decorative; do not rely on them to convey meaning without a label.
- `DSButtonStyle` can be applied to a native `Button` but styling accuracy depends on the host not overriding font or padding via the environment.
- Maintains a minimum interactive height of at least 44 pt.

## SwiftUI Examples

Primary CTA in auth:

```swift
DSButton("Sign in", variant: .primary) {
    handleSignIn()
}
```

Primary and alternate actions together:

```swift
VStack(spacing: 12) {
    DSButton("Continue", variant: .primary) {}
    DSButton("Create account", variant: .outline) {}
    DSButton("Skip", variant: .ghost) {}
}
```

Icon-bearing action:

```swift
DSButton(
    "Share",
    variant: .secondary,
    leadingIcon: Image(systemName: "square.and.arrow.up")
) {}
```

## UIKit Integration

- `DSButtonHostingController`: preferred embedding path in a `UIViewController` hierarchy.
- `DSButtonView`: `UIView` wrapper for cells and stack-view-based layouts.
- `RDSButtonFactory` extensions: convenience builders for primary, secondary, and destructive DS-backed buttons.

Example:

```swift
let buttonVC = DSButtonHostingController(
    configuration: DSButtonConfiguration(title: "Sign in"),
    action: handleSignIn
)
```

## Screen Composition Guidance

- Common placement: below form fields, below plan summaries, or at the bottom of a modal section.
- Pairs most often with: `DSPageHeader`, `DSTextField`, `DSLabel`, `DSPromoBanner`.
- Auth recipe: `DSPageHeader` -> `DSTextField` stack -> primary `DSButton` -> ghost action.
- Marketing recipe: plan text block -> primary `DSButton` under promotional summary.

## Related Components

| Related Component | Relationship | When to Pair |
| --- | --- | --- |
| `DSTextField` | Precedes submit actions | Forms, auth, account updates |
| `DSPageHeader` | Sets screen hierarchy above action | Sign-in, profile, settings |
| `DSPromoBanner` | Adds message context above CTA | Offers, plan cards |

## Constraints And Caveats

- This component covers button use cases only; do not use it as a tab selector or segmented control substitute.
- There is no built-in full-width layout wrapper; width is determined by the parent layout.
- Snapshot coverage is indirect through previews and composed examples rather than a dedicated `DSButtonSnapshotTests` file.