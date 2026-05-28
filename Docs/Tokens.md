# Tokens Module

The `Tokens` module is the single source of truth for all design-system colors, typography, and spacing values. Every component in `Sources/Components` derives its visual properties exclusively from these tokens.

---

## Module Summary

| Field | Value |
|---|---|
| Module | `Tokens` |
| Sources | `Sources/Tokens/Colors.swift`, `Sources/Tokens/Typography.swift`, `Sources/Tokens/Tokens.swift` |
| Dependencies | `Foundation`, `UIKit`, `SwiftUI` |
| Purpose | Dynamic colors, type scale, spacing constants |

---

## Color Tokens — `RDSToken.Color`

All color tokens are `UIColor` with dynamic trait-collection support (light, dark, high-contrast light, high-contrast dark). SwiftUI `Color` convenience properties are provided alongside each semantic `UIColor`.

### Semantic UIColor tokens

| Token | UIKit | SwiftUI | Notes |
|---|---|---|---|
| `primary` | `RDSToken.Color.primary` | `RDSToken.Color.primaryColor` | Brand blue — general interactive states |
| `secondary` | `RDSToken.Color.secondary` | — | Brand teal |
| `success` | `RDSToken.Color.success` | `RDSToken.Color.successColor` | Semantic green |
| `warning` | `RDSToken.Color.warning` | `RDSToken.Color.warningColor` | Semantic amber |
| `error` | `RDSToken.Color.error` | `RDSToken.Color.errorColor` | Semantic red |
| `background` | `RDSToken.Color.background` | `RDSToken.Color.backgroundColor` | Page background |
| `surface` | `RDSToken.Color.surface` | — | Card / panel surface |
| `border` | `RDSToken.Color.border` | `RDSToken.Color.borderColor` | Default border |
| `textPrimary` | `RDSToken.Color.textPrimary` | `RDSToken.Color.textPrimaryColor` | Main content text |
| `textSecondary` | `RDSToken.Color.textSecondary` | `RDSToken.Color.textSecondaryColor` | Supporting text |
| `textDisabled` | `RDSToken.Color.textDisabled` | `RDSToken.Color.textDisabledColor` | Non-interactive text |
| `brandText` | `RDSToken.Color.brandText` | `RDSToken.Color.brandTextColor` | Rogers purple `#5D2894` |
| `inverseText` | `RDSToken.Color.inverseText` | `RDSToken.Color.inverseTextColor` | White (on dark/colored bg) |

### Component-specific tokens

#### Text field

| Token | Purpose |
|---|---|
| `RDSToken.Color.fieldBorderFocusedColor` | Focused/active border — purple `#6E339E` |
| `RDSToken.Color.fieldBorderDefaultColor` | Resting border (alias of `borderColor`) |
| `RDSToken.Color.fieldBackgroundColor` | Field container fill (alias of `surface`) |
| `RDSToken.Color.fieldBackgroundDisabledColor` | Disabled field fill — gray-50 |

#### Button

| Token | Purpose |
|---|---|
| `RDSToken.Color.buttonPrimaryBackgroundColor` | Primary CTA — Rogers purple `#542E91` |
| `RDSToken.Color.buttonPrimaryPressedBackgroundColor` | Primary pressed state |
| `RDSToken.Color.buttonSecondaryBackgroundColor` | Secondary fill — brand teal |
| `RDSToken.Color.buttonSecondaryPressedBackgroundColor` | Secondary pressed |
| `RDSToken.Color.buttonDestructivePressedBackgroundColor` | Destructive pressed |
| `RDSToken.Color.buttonDisabledBackgroundColor` | Disabled fill — gray-200 |
| `RDSToken.Color.buttonDisabledForegroundColor` | Disabled label — `textDisabledColor` |

#### Promo banner

| Token | Purpose |
|---|---|
| `RDSToken.Color.promoBannerBackgroundColor` | Deep brand purple `#55228A` |
| `RDSToken.Color.promoBannerForegroundColor` | Always white |

### How dynamic colors work

All `UIColor` tokens are constructed with `dynamicColor(light:dark:highContrastLight:highContrastDark:)` — a private factory that returns a `UIColor` with a trait-collection closure. When the device switches between light, dark, or increased-contrast modes, the token automatically delivers the correct palette step.

The palette lives in `private enum Palette` and should not be referenced directly outside this module.

---

## Spacing Tokens — `RDSToken.Spacing`

Simple `CGFloat` constants for consistent layout.

| Token | Value | Use |
|---|---|---|
| `RDSToken.Spacing.small` | 8 pt | Icon gaps, tight stacks |
| `RDSToken.Spacing.medium` | 16 pt | Section padding, tab bar horizontal padding |
| `RDSToken.Spacing.large` | 24 pt | Screen edge padding |

---

## Typography Tokens — `RDSToken.Typography`

All entries are `DSTextStyle` values that carry the PostScript font name, design size, line height, letter spacing, and a `UIFont.TextStyle` for Dynamic Type scaling. TedNext fonts fall back to equivalent system weights when not registered.

### Complete type scale

| Token | Font | Size | Line height | UIFont.TextStyle | Notes |
|---|---|---|---|---|---|
| `display` | TedNext-Bold | 48 | 56 | `.largeTitle` | Splash / hero numbers |
| `title1` | TedNext-Bold | 36 | 44 | `.largeTitle` | |
| `title2` | TedNext-Bold | 32 | 40 | `.title1` | |
| `title3` | TedNext-Bold | 30 | 36 | `.title2` | Figma default page title |
| `title4` | TedNext-Bold | 24 | 32 | `.title3` | Card and section titles |
| `bodyLarge` | TedNext-Medium | 18 | 28 | `.body` | Prominent body |
| `bodyRegular` | TedNext-Medium | 16 | 24 | `.body` | Default body (Figma `--ds-body-r-*`) |
| `bodyBold` | TedNext-Bold | 16 | 24 | `.body` | Emphasized body |
| `heroBody` | TedNext-Bold | 16 | 36 | `.body` | Hero / splash copy on dark backgrounds |
| `bodySmall` | TedNext-Medium | 14 | 20 | `.subheadline` | Compact body |
| `caption` | TedNext-Medium | 12 | 16 | `.caption1` | Hints, timestamps, badges |
| `label` | TedNext-Bold | 12 | 16 | `.caption1` | Tab labels, tag chips |
| `overline` | TedNext-Bold | 10 | 16 +0.8 tracking · uppercase | `.caption2` | Section identifiers |

### DSTextStyle API

```swift
// SwiftUI
Text("Sign in").font(RDSToken.Typography.title3.font)

// UIKit — Dynamic Type scaled UIFont
label.font = RDSToken.Typography.title3.scaledUIFont

// UIKit — attributed string with correct line height
label.attributedText = RDSToken.Typography.heroBody
    .attributedString("Now you make the call…", textColor: RDSToken.Color.inverseText)
```

Key properties:

| Property | Type | Purpose |
|---|---|---|
| `font` | `Font` | Dynamic-Type SwiftUI `Font` |
| `scaledUIFont` | `UIFont` | Dynamic-Type-scaled `UIFont` |
| `baseUIFont` | `UIFont` | Unscaled base `UIFont` |
| `swiftUILineSpacing` | `CGFloat` | Value for `.lineSpacing()` modifier |
| `attributedString(_:textColor:alignment:lineBreakMode:)` | `NSAttributedString` | Pixel-correct attributed string for UIKit |

---

## Using Tokens in Components

**SwiftUI:**
```swift
DSLabel("Sign in", style: RDSToken.Typography.title3, color: .brand)
```

**UIKit:**
```swift
let label = DSLabelFactory.makeLabel(
    text: "Sign in",
    style: RDSToken.Typography.title3,
    textColor: .brand
)
```

**Direct UIKit (legacy or custom views):**
```swift
view.backgroundColor = RDSToken.Color.surface
titleLabel.font = RDSToken.Typography.title3.scaledUIFont
titleLabel.textColor = RDSToken.Color.brandText
```

---

## Adding New Tokens

1. Add a new palette step to `private enum Palette` in `Colors.swift` if the color is truly new.
2. Add a new semantic property to `RDSToken.Color` using `dynamicColor(light:dark:...)`.
3. Provide a matching SwiftUI `Color` property using `swiftUIColor(fromUIColor:)`.
4. Document it in this file.
5. Do not reference `Palette` values directly from call sites outside this file.

For a new type style: add a `static let` to `RDSToken.Typography` using the `DSTextStyle` initializer.

---

## Known Gaps

- Spacing tokens cover only three tiers (small / medium / large); component-specific metrics (border radii, icon sizes) live in each component's own `Metrics` enum rather than here.
- `RDSToken.Spacing` does not yet include `xSmall` or `xLarge` variants.
- No motion / animation tokens are defined; components use hardcoded `easeInOut(duration: 0.2)` durations.
