# DSLabel · DSPageHeader · DSHeroText

Text components for the Rogers iOS Design System. `DSLabel` is the base text primitive; `DSPageHeader` composes a title+subtitle pair; `DSHeroText` renders bold inverse copy for coloured or image backgrounds.

---

## Component Summary

| Component | Module | Purpose |
|---|---|---|
| `DSLabel` | `Components` | Token-driven text for all body, utility, and semantic roles |
| `DSPageHeader` | `Components` | Title + optional subtitle pair (Figma node 5:448) |
| `DSHeroText` | `Components` | Bold white multi-line text for hero / splash sections |

UIKit support: `DSLabelFactory`, `DSPageHeaderView`, `DSLabelView` in `UIKitCompat`.

---

## When to Use Each

**`DSLabel`** — Use for any text that belongs to the design-system surface: body copy, captions, overlines, badge labels, error messages, status text. Prefer it over raw `Text` when semantic color or token typography is required.

**`DSPageHeader`** — Use at the top of every screen that has a clear page title. It produces the exact Figma node 5:448 layout (TedNext-Bold 30/36 brand purple + TedNext-Medium 16/24 primary). Do not hand-roll a `VStack` of `DSLabel` instances when this component covers the need.

**`DSHeroText`** — Use for multi-line marketing copy displayed on a coloured or dark background. Matches the UILabel snippet spec (TedNext-Bold 16/36, white). Do not use it for body text on white surfaces.

**Avoid** all three when:
- The content is a tappable action → use `DSButton`
- The content is a full promo strip with icon → use `DSPromoBanner`
- The content requires custom rich-text markup not covered by `DSTextStyle`

---

## API and Companion Types

### DSLabel

```swift
// Default: bodyRegular + primary color
DSLabel("With your My Chatr credentials")

// Explicit style + brand color (Figma title 5:441)
DSLabel("Sign in", style: RDSToken.Typography.title3, color: .brand)

// Capped line count, secondary color
DSLabel("Long description text…", style: .caption, color: .secondary, numberOfLines: 2)

// Custom color escape hatch
DSLabel("Custom text", color: .custom(Color.orange))
```

**Initialiser parameters:**

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `text` | `String` | required | Display string |
| `style` | `DSTextStyle` | `RDSToken.Typography.bodyRegular` | Typography token |
| `color` | `DSTextColor` | `.primary` | Semantic color role |
| `alignment` | `TextAlignment` | `.leading` | Horizontal alignment |
| `numberOfLines` | `Int` | `0` (unlimited) | Line cap |

### DSPageHeader

```swift
// Standard usage (Figma node 5:448)
DSPageHeader(title: "Sign in", subtitle: "With your My Chatr credentials")

// Title-only
DSPageHeader(title: "Welcome")

// Inverse title for dark backgrounds
DSPageHeader(title: "Welcome", titleColor: .inverse)

// Center-aligned
DSPageHeader(title: "Choose your plan", alignment: .center)
```

**Initialiser parameters:**

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `title` | `String` | required | TedNext-Bold 30/36 |
| `subtitle` | `String?` | `nil` | TedNext-Medium 16/24 |
| `titleColor` | `DSTextColor` | `.brand` | Rogers purple default |
| `subtitleColor` | `DSTextColor` | `.primary` | |
| `alignment` | `TextAlignment` | `.leading` | Applies to both lines |

### DSHeroText

```swift
// Default: white, leading
DSHeroText("Now you make the call\nSign in to manage your account.")

// Centered on a splash screen
DSHeroText("Your Rogers account, all in one place.", alignment: .center)
```

**Initialiser parameters:**

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `text` | `String` | required | Supports `\n` |
| `color` | `DSTextColor` | `.inverse` | White for dark bg |
| `alignment` | `TextAlignment` | `.leading` | |

### DSTextColor

Semantic color roles — all adapt automatically to light, dark, and high-contrast.

| Value | Usage |
|---|---|
| `.primary` | Main content text |
| `.secondary` | Supporting / muted text |
| `.brand` | Rogers brand purple (`#5D2894`) — titles, accented labels |
| `.inverse` | White — for text on dark or coloured backgrounds |
| `.error` | Inline validation errors |
| `.success` | Confirmation / success messages |
| `.warning` | Cautionary states |
| `.disabled` | Non-interactive text |
| `.custom(Color)` | Arbitrary color when tokens don't cover the need |

---

## Variants, States, and Behaviors

**`DSLabel` style variants** (from `RDSToken.Typography`):

| Token | Font / Size / Line height | Use |
|---|---|---|
| `display` | TedNext-Bold 48/56 | Splash hero numbers |
| `title1` | TedNext-Bold 36/44 | Large section headers |
| `title2` | TedNext-Bold 32/40 | Section titles |
| `title3` | TedNext-Bold 30/36 | Page title (Figma default) |
| `title4` | TedNext-Bold 24/32 | Card or subsection title |
| `bodyLarge` | TedNext-Medium 18/28 | Prominent body |
| `bodyRegular` | TedNext-Medium 16/24 | Default body copy |
| `bodyBold` | TedNext-Bold 16/24 | Emphasized body |
| `heroBody` | TedNext-Bold 16/36 | Hero/splash copy on dark bg |
| `bodySmall` | TedNext-Medium 14/20 | Compact body |
| `caption` | TedNext-Medium 12/16 | Hints, timestamps, badges |
| `label` | TedNext-Bold 12/16 | Tab bar labels, tags |
| `overline` | TedNext-Bold 10/16 ·+0.8 tracking · uppercase | Section identifiers |

- All styles scale with Dynamic Type via `UIFontMetrics`.
- `overline` auto-uppercases via `isUppercased = true`; no manual `.uppercased()` needed.

---

## Accessibility Notes

- `DSLabel` inherits SwiftUI text semantics automatically.
- `DSPageHeader` uses `.accessibilityElement(children: .combine)` and `.accessibilityAddTraits(.isHeader)` to announce title and subtitle as a single header element.
- `DSHeroText` inherits standard text traits; add `.accessibilityLabel` in the parent view if the text is decorative.
- All styles respect the user's Dynamic Type preference.

---

## SwiftUI Examples

### Type scale preview

```swift
VStack(alignment: .leading, spacing: 12) {
    DSLabel("Page title",     style: RDSToken.Typography.title3,    color: .brand)
    DSLabel("Section header", style: RDSToken.Typography.title4,    color: .primary)
    DSLabel("Body copy",      style: RDSToken.Typography.bodyRegular, color: .primary)
    DSLabel("Helper text",    style: RDSToken.Typography.caption,    color: .secondary)
    DSLabel("OVERLINE",       style: RDSToken.Typography.overline,   color: .secondary)
}
```

### Plan card

```swift
VStack(alignment: .leading, spacing: 4) {
    DSLabel("MOST POPULAR", style: RDSToken.Typography.overline, color: .secondary)
    DSLabel("Rogers Infinite+", style: RDSToken.Typography.title4, color: .primary)
    DSLabel("Unlimited Canada-wide data · 5G", style: RDSToken.Typography.bodyRegular, color: .secondary)
}
```

### Standard sign-in header

```swift
DSPageHeader(
    title: "Sign in",
    subtitle: "With your My Chatr credentials"
)
```

### Hero splash section

```swift
ZStack {
    Color(RDSToken.Color.buttonPrimaryBackground)
    DSHeroText(
        "Now you make the call\nSign in to manage your account.",
        alignment: .leading
    )
    .padding(24)
}
```

### Error / status labels

```swift
DSLabel("This field is required.", style: RDSToken.Typography.caption, color: .error)
DSLabel("Plan activated.", style: RDSToken.Typography.bodySmall, color: .success)
```

---

## UIKit Integration

### DSLabelFactory

Returns a fully attributed `UILabel` from any `DSTextStyle` + `DSTextColor` combination.

```swift
// Generic factory (works for all styles)
let titleLabel = DSLabelFactory.makeLabel(
    text: "Sign in",
    style: RDSToken.Typography.title3,
    textColor: .brand
)

// Hero label (matches UILabel export snippet)
let heroLabel = DSLabelFactory.makeLabel(
    text: "Now you make the call\nSign in to manage your account.",
    style: RDSToken.Typography.heroBody,
    textColor: .inverse,
    numberOfLines: 0
)
```

All `UILabel` instances returned:
- Apply `UIFontMetrics`-scaled fonts.
- Use `minimumLineHeight` / `maximumLineHeight` (not `lineHeightMultiple`) for pixel-correct Figma line heights.
- Apply `baselineOffset` to vertically center glyphs.
- Auto-uppercase `overline` text.

### DSPageHeaderView

UIView subclass reproducing Figma node 5:448.

```swift
let header = DSPageHeaderView(title: "Sign in", subtitle: "With your My Chatr credentials")
stackView.addArrangedSubview(header)
```

### DSLabelView

Generic UIHostingController wrapper for any `DSLabel`.

```swift
let labelVC = DSLabelView(
    text: "Rogers Infinite+",
    style: RDSToken.Typography.title4,
    color: .primary
)
addChild(labelVC)
view.addSubview(labelVC.view)
```

---

## Screen Composition Guidance

### Where these components sit in the screen hierarchy

- `DSPageHeader` — always the topmost text element in a screen content area, below the navigation bar.
- `DSLabel` — within cards, form fields (via `DSTextField`), list rows, and any text body area.
- `DSHeroText` — inside a colored `ZStack` or over an image; never on a plain white background.

### Composition recipes

**Sign-in screen header block**
```swift
VStack(alignment: .leading, spacing: 0) {
    DSPromoBanner(configuration: .specialOffer())
    DSPageHeader(
        title: "Sign in",
        subtitle: "With your My Chatr credentials"
    )
    .padding(.horizontal, 24)
    .padding(.top, 24)
}
```

**Plan card body**
```swift
VStack(alignment: .leading, spacing: 6) {
    DSLabel("RECOMMENDED", style: RDSToken.Typography.overline, color: .brand)
    DSLabel("Rogers Infinite+", style: RDSToken.Typography.title4)
    DSLabel("Unlimited data · 5G", color: .secondary)
    DSLabel("$65/mo", style: RDSToken.Typography.bodyBold)
}
.padding(16)
```

**Marketing hero strip**
```swift
ZStack(alignment: .bottomLeading) {
    Image("hero-bg").resizable().scaledToFill()
    DSHeroText("Now you make the call\nSign in to manage your account.")
        .padding(24)
}
```

---

## Related Components

| Related Component | Relationship | When to Pair |
|---|---|---|
| `DSButton` | Action that follows explanatory text | Auth, confirmation, plan selection |
| `DSTextField` | Form input with label above it | Sign-in, registration, search |
| `DSPromoBanner` | Banner above the page header | Offer and marketing screens |
| `DSTabBar` | Navigation shell surrounding screen text | App shell tab sections |

---

## Constraints and Caveats

- `DSPageHeader` uses a fixed `spacing: 4` between title and subtitle; it cannot be customized at the call site.
- `DSHeroText` is a semantic wrapper around `DSLabel` with `heroBody` style and `.inverse` color; no additional layout structure is provided.
- `DSTextColor.custom` bypasses the token system — use only when design approval covers the deviation.
- `overline` style is always uppercase regardless of the input casing; no transformation is needed at call sites.
- Font fallback is TedNextBold → `UIFont.systemFont(weight: .bold)` and TedNextMedium → `UIFont.systemFont(weight: .medium)` when the custom font is not registered. Call `RDSCore.registerFontsIfNeeded()` early in the app lifecycle.

- Common placement: within cards, under headers, around fields, and inside plan summaries.
- Pairs most often with: every component in the design system.
- Use `DSLabel` for supporting content, not as the first-choice screen header.

## Related Components

| Related Component | Relationship | When to Pair |
| --- | --- | --- |
| `DSPageHeader` | Higher-level title composition | Screen starts and section intros |
| `DSHeroText` | High-emphasis alternative | Marketing and branded surfaces |
| `DSPromoBanner` | Messaging complement | Offer or status surfaces |

## Constraints And Caveats

- `DSLabel` is intentionally low-level; it does not own spacing, section hierarchy, or screen layout.
- Choosing the wrong typography token can create inconsistent hierarchy, so prefer existing preview patterns when possible.