# DSButton Component Catalog

`DSButton` is the design-system action control for primary, secondary, outline, destructive, and low-emphasis button patterns in SwiftUI, with UIKit bridge support when screens are not fully SwiftUI.

## Component Summary

- Module: `Components`
- Purpose: Standardize action presentation, sizing, state handling, and accessibility for tappable controls.
- Best fit: Auth CTAs, plan selection, destructive confirmation, inline secondary actions.

## When To Use It

- Use `DSButton` for screen and section actions that must follow design-system spacing, token colors, and accessibility behavior.
- Use `.primary` for the main action in a section.
- Use `.outline` or `.ghost` for alternate or tertiary actions.
- Use `.destructive` only for irreversible flows.

Avoid it when the control is really navigation shell selection, passive text, or a custom compound interaction that is not button-shaped.

## API And Companion Types

Primary APIs:

```swift
DSButton("Sign in", variant: .primary) {
    handleSignIn()
}

let configuration = DSButtonConfiguration(
    title: "Delete account",
    variant: .destructive,
    size: .medium,
    accessibilityHint: "Deletes this account permanently"
)

DSButton(configuration: configuration) {
    handleDelete()
}
```

Companion types:

- `DSButtonConfiguration`: Value-type configuration for shared button state.
- `DSButtonVariant`: `primary`, `secondary`, `outline`, `destructive`, `ghost`.
- `DSButtonSize`: `small`, `medium`, `large`.
- `DSButtonStyle`: SwiftUI `ButtonStyle` that resolves token-driven visuals.

## Variants, States, And Behaviors

- Variants: `primary`, `secondary`, `outline`, `destructive`, `ghost`.
- Sizes: `small`, `medium`, `large`.
- Visual states: normal, pressed, loading, disabled, focused.
- Layout behavior: size tier controls padding, icon size, font size, and minimum tap target.
- Interaction behavior: loading blocks taps without presenting the same visual treatment as disabled.

## Accessibility Notes

- Applies button traits automatically.
- Supports accessibility label, hint, and identifier overrides.
- Exposes loading state as an accessibility value.
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