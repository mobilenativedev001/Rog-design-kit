# Rogers iOS Design System Component Catalog

This catalog describes how to use the current Rogers iOS Design System components to build production iOS screens in SwiftUI first, with UIKit integration paths where the repo provides them.

## How to Read This Catalog

- Start with the selection matrix to choose the right component for a screen role.
- Use the detailed entries for API shape, variants, states, accessibility behavior, and composition guidance.
- Treat `Sources/Components` as the source of truth for SwiftUI APIs.
- Treat `Sources/UIKitCompat` as the source of truth for UIKit bridges.
- Treat token references as intent guidance, not as a reason to bypass components and style screens manually.

## Component Selection Matrix

| Component | Role | Best For | Key Variants/States | UIKit Support |
| --- | --- | --- | --- | --- |
| DSButton | Primary and secondary actions | CTAs, destructive actions, inline secondary actions | Variants: `primary`, `secondary`, `outline`, `destructive`, `ghost`; Sizes: `small`, `medium`, `large`; States: normal, loading, disabled, focused | Yes |
| DSLabel | Base text primitive | Body copy, captions, overlines, token-driven text styling | Typography from `RDSToken.Typography`; semantic text colors via `DSTextColor` | Yes |
| DSPageHeader | Screen header composition | Screen titles with optional subtitle | Title-only or title-plus-subtitle; leading, center, trailing alignment | Yes |
| DSHeroText | High-emphasis marketing text | Hero areas on dark or branded surfaces | Inverse by default; multiline marketing copy | Yes |
| DSTextField | Form input | Auth, profile, checkout, search, code entry | Variants: `outlined`, `filled`, `underlined`; States: idle, focused, valid, invalid, disabled; secure and icon modes | Yes |
| DSPromoBanner | Promotional or status strip | Offer messaging, plan cards, short inline notices | Variants: `offer`, `success`, `warning`, `info`, `custom`; icon optional | Yes |
| DSTabBar | App-shell navigation | Persistent bottom navigation with 3-5 destinations | Badge: none, dot, count; selected, unselected, disabled items | Yes |

## Detailed Component Entries

### DSButton

- Module: `Components`
- Purpose: Token-driven button for primary, secondary, outline, destructive, and low-emphasis actions.
- Use when: The screen needs a tappable action with consistent sizing, variants, accessibility labels, and loading behavior.
- Avoid when: The interaction is navigation shell selection, passive text, or a custom control that is not a button.
- Key API:

```swift
DSButton("Sign in", variant: .primary) {
    handleSignIn()
}

let configuration = DSButtonConfiguration(
    title: "Delete account",
    variant: .destructive,
    isDisabled: false,
    accessibilityHint: "Deletes this account permanently"
)

DSButton(configuration: configuration) {
    handleDelete()
}
```

- Variants and states: Five variants through `DSButtonVariant`, three size tiers through `DSButtonSize`, and built-in handling for loading, disabled, pressed, and focused rendering.
- Accessibility notes: Uses button traits, exposes loading as an accessibility value, supports label, hint, and identifier overrides, and maintains a minimum tappable height of at least 44 pt.
- SwiftUI example:

```swift
VStack(spacing: 12) {
    DSButton("Continue", variant: .primary) {}
    DSButton("Create account", variant: .outline) {}
    DSButton("Skip", variant: .ghost) {}
}
```

- UIKit integration: `DSButtonHostingController` for view-controller embedding, `DSButtonView` for plain `UIView` embedding, and convenience builders on `RDSButtonFactory`.
- Works well with: `DSPageHeader`, `DSTextField`, `DSPromoBanner`, `DSLabel`.
- Screen-building notes: Default to `.primary` for the main CTA, use `.outline` for an alternate action in the same section, and reserve `.ghost` for tertiary actions like “Forgot password?”.

### DSLabel

- Module: `Components`
- Purpose: Base text view that applies `RDSToken.Typography` and semantic `DSTextColor` roles without forcing callers to hand-style text.
- Use when: You need body text, captions, overlines, helper copy, or token-driven typography inside a custom layout.
- Avoid when: The screen needs a reusable heading composition or a hero treatment that already exists as `DSPageHeader` or `DSHeroText`.
- Key API:

```swift
DSLabel("With your My Chatr credentials")

DSLabel(
    "Featured plan",
    style: RDSToken.Typography.overline,
    color: .secondary
)
```

- Variants and states: The main variation comes from `DSTextStyle` and `DSTextColor`. Notable typography tokens in active use are `title3`, `title4`, `bodyRegular`, `bodyBold`, `caption`, `label`, and `overline`.
- Accessibility notes: Inherits SwiftUI text accessibility semantics and supports multiline layouts through `numberOfLines`.
- SwiftUI example:

```swift
VStack(alignment: .leading, spacing: 8) {
    DSLabel("Rogers Infinite+", style: .title4, color: .primary)
    DSLabel("Unlimited Canada-wide data", style: .bodyRegular, color: .secondary)
    DSLabel("Featured", style: .overline, color: .secondary)
}
```

- UIKit integration: `DSLabelFactory` builds attributed `UILabel` instances, `DSLabelView` hosts SwiftUI label content, and `UILabel.apply(style:textColor:)` applies token styling to an existing label.
- Works well with: Every other component, especially `DSPageHeader`, `DSPromoBanner`, and `DSTabBar` labels.
- Screen-building notes: Prefer this over raw `Text` whenever the text is part of the design-system surface and should stay on the token scale.

### DSPageHeader

- Module: `Components`
- Purpose: Title plus optional subtitle pair for page starts, sign-in flows, and screen sections that need a clear hierarchy.
- Use when: The screen begins with a main heading and optional supporting line.
- Avoid when: The layout is too dense for a large title, or when the content belongs inside a card or hero banner rather than at the screen header level.
- Key API:

```swift
DSPageHeader(
    title: "Sign in",
    subtitle: "With your My Chatr credentials"
)
```

- Variants and states: Optional subtitle, configurable title and subtitle colors, and configurable alignment.
- Accessibility notes: Combines title and subtitle into a single accessible heading and applies the header trait.
- SwiftUI example:

```swift
DSPageHeader(
    title: "Manage your account",
    subtitle: "Billing, usage, and plan settings",
    alignment: .leading
)
```

- UIKit integration: `DSPageHeaderView` reproduces the same structure using `UILabel` instances styled by `DSLabelFactory`.
- Works well with: `DSTextField`, `DSButton`, `DSTabBar` content regions.
- Screen-building notes: This is the preferred entry-point heading for auth and settings screens because the repo already previews it in the sign-in composition.

### DSHeroText

- Module: `Components`
- Purpose: Bold multiline text for marketing, splash, or hero areas shown on branded or dark backgrounds.
- Use when: You need high-emphasis text over color blocks, image areas, or promotional surfaces.
- Avoid when: The text sits on a plain surface or should read like ordinary body copy.
- Key API:

```swift
DSHeroText("Now you make the call\nSign in to manage your account.")
```

- Variants and states: Inverse text by default, configurable color and alignment, backed by `RDSToken.Typography.heroBody`.
- Accessibility notes: Inherits text semantics and supports multiline content without manual truncation.
- SwiftUI example:

```swift
ZStack(alignment: .bottomLeading) {
    RoundedRectangle(cornerRadius: 16)
        .fill(Color(RDSToken.Color.buttonPrimaryBackground))
        .frame(height: 200)

    DSHeroText("Unlimited Canada-wide data.")
        .padding(24)
}
```

- UIKit integration: `DSLabelFactory.makeHeroLabel` creates the equivalent attributed `UILabel`, and `DSLabelView` can host the SwiftUI view when needed.
- Works well with: `DSPromoBanner`, `DSButton`, `DSLabel` supporting copy.
- Screen-building notes: Use it sparingly and only where the surrounding surface justifies its 16/36 hero rhythm.

### DSTextField

- Module: `Components`
- Purpose: Token-driven single-line text input for auth, profile, search, promo code, and structured form entry.
- Use when: The screen needs a labeled form field with validation, helper copy, secure entry, icons, and external validation overrides.
- Avoid when: You need multiline input, a text editor, or an interaction model that is not a standard form field.
- Key API:

```swift
@State private var email = ""

DSTextField(configuration: .email(), text: $email)
```

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

- Variants and states: Frame styles `outlined`, `filled`, and `underlined`; states idle, focused, valid, invalid, and disabled; optional secure-entry toggle; optional prefix and suffix icons.
- Accessibility notes: Exposes label or placeholder as the accessibility label, reports validation state through accessibility value, and surfaces helper or error messaging.
- SwiftUI example:

```swift
VStack(spacing: 16) {
    DSTextField(configuration: .email(), text: $email)
    DSTextField(configuration: .password(), text: $password)
}
```

- UIKit integration: `DSTextFieldHostingController` for controller-based embedding and callbacks, plus `DSTextFieldView` for plain `UIView` embedding.
- Works well with: `DSPageHeader`, `DSButton`, `DSLabel` helper copy.
- Screen-building notes: Use configuration factories like `.email()`, `.password()`, and `.phone()` whenever they match the use case; they already encode keyboard, content type, and validation defaults.

Supporting validation surface:

- `DSValidationResult` models `idle`, `valid`, and `invalid(message:)`.
- Built-in validators include `DSRequiredValidator`, `DSMinLengthValidator`, `DSMaxLengthValidator`, `DSEmailValidator`, `DSPhoneValidator`, `DSPostalCodeValidator`, `DSRegexValidator`, and `DSCustomValidator`.
- `dsRunValidators` runs validators in order and returns the first failure.

### DSPromoBanner

- Module: `Components`
- Purpose: Full-width rectangular strip for short promotional or status messaging.
- Use when: The screen needs a short, high-contrast message at the top of a card, section, or screen.
- Avoid when: The content is dismissible, multiline, action-heavy, or better expressed as a full card.
- Key API:

```swift
DSPromoBanner(configuration: .specialOffer())

DSPromoBanner(
    text: "Payment due in 3 days",
    iconName: "exclamationmark.triangle.fill",
    variant: .warning
)
```

- Variants and states: `offer`, `success`, `warning`, `info`, and `custom(background:foreground:)`; optional icon through `iconName`; preset factories on `DSPromoBannerConfiguration`.
- Accessibility notes: Exposed as a single static text element so the icon stays decorative.
- SwiftUI example:

```swift
VStack(spacing: 0) {
    DSPromoBanner(configuration: .specialOffer())

    VStack(alignment: .leading, spacing: 12) {
        DSLabel("Rogers Infinite+", style: .title4, color: .primary)
        DSButton("Get this plan", variant: .primary) {}
    }
    .padding()
}
```

- UIKit integration: `DSPromoBannerHostingController`, `DSPromoBannerView`, and `DSPromoBannerFactory` cover controller embedding, `UIView` usage, and common presets.
- Works well with: `DSLabel`, `DSButton`, `DSHeroText`.
- Screen-building notes: Keep the copy short enough to fit a single line and use it as a strip, not as a generic notification container.

### DSTabBar

- Module: `Components`
- Purpose: Persistent bottom navigation bar for app shells and embedded multi-section flows.
- Use when: The screen set has a small, stable set of top-level destinations that should remain visible across navigation.
- Avoid when: The flow has many destinations, temporary steps, or hierarchical navigation that belongs in a stack.
- Key API:

```swift
enum AppTab: String, Hashable {
    case home
    case plans
    case support
    case profile
}

@State private var selectedTab: AppTab = .home

DSTabBar(
    items: [
        DSTabBarItem(id: .home, title: "Home", iconName: "house", selectedIconName: "house.fill"),
        DSTabBarItem(id: .plans, title: "Plans", iconName: "simcard", selectedIconName: "simcard.fill", badge: .count(2)),
        DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
        DSTabBarItem(id: .profile, title: "Profile", iconName: "person", selectedIconName: "person.fill")
    ],
    selection: $selectedTab
)
```

- Variants and states: `DSTabBarBadge` supports `none`, `dot`, and `count(Int)`; items can be enabled or disabled; appearance is controlled through `DSTabBarConfiguration`.
- Accessibility notes: Announces selected state and badge count, supports label, hint, and identifier overrides per item, and keeps each target at least 44 pt tall.
- SwiftUI example:

```swift
VStack(spacing: 0) {
    content(for: selectedTab)
    Spacer()
    DSTabBar(items: tabItems, selection: $selectedTab)
}
```

- UIKit integration: `DSTabBarHostingController` and `DSTabBarView` provide controller and `UIView` wrappers.
- Works well with: `DSPageHeader`, `DSLabel`, screen body content containers.
- Screen-building notes: Use badges sparingly, reserve disabled items for temporary gating, and keep destination count tight enough that each label stays legible.

## Common Screen Recipes

### Sign-in Screen

- Goal of the screen section: Establish identity entry with a clear primary action and a low-emphasis recovery path.
- Recommended component stack: `DSPageHeader` -> `DSTextField.email()` -> `DSTextField.password()` -> primary `DSButton` -> ghost `DSButton`.
- Brief rationale: The repo already previews this composition in both `DSLabel` and `DSTextField` previews, so it is the strongest canonical screen recipe currently available.
- Compact example snippet:

```swift
struct SignInScreen: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            DSPageHeader(
                title: "Sign in",
                subtitle: "With your My Chatr credentials"
            )

            DSTextField(configuration: .email(), text: $email)
            DSTextField(configuration: .password(), text: $password)

            DSButton("Sign in", variant: .primary) {}
            DSButton("Forgot password?", variant: .ghost) {}
        }
        .padding(24)
    }
}
```

### Marketing Or Offer Surface

- Goal of the screen section: Surface a promotional message with immediate context and a clear call to action.
- Recommended component stack: `DSPromoBanner` -> hero or title text -> supporting `DSLabel` -> primary `DSButton`.
- Brief rationale: `DSPromoBanner` already previews an in-context plan card, and `DSHeroText` provides the high-emphasis copy treatment for branded surfaces.
- Compact example snippet:

```swift
VStack(spacing: 0) {
    DSPromoBanner(configuration: .specialOffer())

    VStack(alignment: .leading, spacing: 12) {
        DSLabel("Rogers Infinite+", style: .title4, color: .primary)
        DSLabel("$55/month • Unlimited Canada-wide data", style: .bodyRegular, color: .secondary)
        DSButton("Get this plan", variant: .primary) {}
    }
    .padding()
}
```

### Tab-Based Application Shell

- Goal of the screen section: Provide stable global navigation across a small set of primary destinations.
- Recommended component stack: `DSPageHeader` or screen body content -> spacer/content container -> `DSTabBar`.
- Brief rationale: `DSTabBar` is typed, token-driven, and already supports selected state, badges, and disabled destinations.
- Compact example snippet:

```swift
struct ShellView: View {
    enum Tab: String, Hashable { case home, plans, support, profile }

    @State private var selection: Tab = .home

    private var items: [DSTabBarItem<Tab>] {
        [
            DSTabBarItem(id: .home, title: "Home", iconName: "house", selectedIconName: "house.fill"),
            DSTabBarItem(id: .plans, title: "Plans", iconName: "simcard", selectedIconName: "simcard.fill", badge: .count(2)),
            DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
            DSTabBarItem(id: .profile, title: "Profile", iconName: "person", selectedIconName: "person.fill")
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            content
            Spacer(minLength: 0)
            DSTabBar(items: items, selection: $selection)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch selection {
        case .home:
            DSPageHeader(title: "Home")
        case .plans:
            DSPageHeader(title: "Plans")
        case .support:
            DSPageHeader(title: "Support")
        case .profile:
            DSPageHeader(title: "Profile")
        }
    }
}
```

### Form Entry Screen With Validation

- Goal of the screen section: Gather structured user input with immediate validation feedback and a clear completion action.
- Recommended component stack: `DSPageHeader` -> multiple `DSTextField` instances with validators -> helper copy as needed -> primary `DSButton`.
- Brief rationale: `DSTextField` is the component with the richest validation surface in the repo, including helper text, secure entry, phone/email presets, and external error injection.
- Compact example snippet:

```swift
struct AccountForm: View {
    @State private var email = ""
    @State private var phone = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            DSPageHeader(
                title: "Update contact info",
                subtitle: "Make sure we can reach you about your service"
            )

            DSTextField(configuration: .email(), text: $email)
            DSTextField(configuration: .phone(), text: $phone)

            DSButton("Save changes", variant: .primary) {}
        }
        .padding(24)
    }
}
```

## UIKit Integration Notes

- Buttons: Use `DSButtonHostingController` when you can embed a child controller; fall back to `DSButtonView` for cells or stack views.
- Text: Prefer `DSLabelFactory` when UIKit only needs a styled `UILabel`; use `DSPageHeaderView` for the full page-header composition.
- Text fields: Use `DSTextFieldHostingController` when UIKit needs callbacks for text and validation changes; use `DSTextFieldView` in simpler container contexts.
- Promo banners: `DSPromoBannerHostingController`, `DSPromoBannerView`, and `DSPromoBannerFactory` cover controller, view, and preset factory paths.
- Tab bars: Use `DSTabBarHostingController` or `DSTabBarView` when a UIKit screen shell needs the SwiftUI tab bar.
- General rule: The repo’s architecture is SwiftUI-first, so UIKit wrappers are intended as thin bridges rather than parallel component implementations.

## Gaps And Components Not Yet Covered

- There is no multiline text input component in the current public surface, so long-form entry still needs a separate component.
- There are no list, card, modal, toast, or segmented-control primitives yet, so full screen assembly still depends on app-level layout code around these components.
- `DSButton` currently has previews in source but no dedicated snapshot test file in `Tests/SnapshotTests`.
- Screen recipes in this catalog are strongest for auth, promotional surfaces, and tab shells because those are the flows explicitly previewed or tested in the repo.