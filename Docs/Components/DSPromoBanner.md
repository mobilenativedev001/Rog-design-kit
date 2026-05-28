# DSPromoBanner

Short-form promotional and status strip for high-contrast messaging across offer cards, confirmations, and campaign surfaces. Matches Figma node 128:60 exactly: sharp rectangular corners, deep brand-purple background, white TedNext-Bold label, and optional SF Symbol icon.

---

## Component Summary

| Field | Value |
|---|---|
| Module | `Components` |
| UIKit support | `DSPromoBannerHostingController`, `DSPromoBannerView`, `DSPromoBannerFactory` in `UIKitCompat` |
| Figma | Offer strip: node 128:60 |
| Default height | 33 pt minimum |

---

## When to Use It

- Use `DSPromoBanner` for short, high-priority single-line messaging that should appear above or beside content.
- Use the `.offer` preset at the top of a plan or subscription card.
- Use `.success` after a completed action, `.warning` for caution states, `.info` for neutral contextual alerts.
- Use `.custom` when brand-approved colors are not covered by the built-in variants.

**Avoid** `DSPromoBanner` for:
- Multi-line or dismissible in-app alerts
- Long instructional copy
- Interaction-heavy containers (buttons, inputs)
- Decorative dividers or background color blocks

---

## API and Companion Types

### DSPromoBanner — Initialisers

```swift
// Built-in factory preset (Figma-exact node 128:60)
DSPromoBanner(configuration: .specialOffer())

// Inline convenience
DSPromoBanner(text: "Special Offer for you", iconName: "tag.fill", variant: .offer)

// Status message
DSPromoBanner(
    text: "Payment due in 3 days",
    iconName: "exclamationmark.triangle.fill",
    variant: .warning
)

// Custom brand colors
DSPromoBanner(
    text: "Limited time: Free activation",
    variant: .custom(background: Color(hex: "#1A1A2E"), foreground: .white)
)
```

### DSPromoBannerConfiguration

Value-type data model passed to both the SwiftUI component and the UIKit compat layer.

```swift
public struct DSPromoBannerConfiguration {
    var text: String
    var iconName: String?         // default: "tag.fill" — set nil to hide icon
    var variant: DSPromoBannerVariant  // default: .offer
    var minHeight: CGFloat        // default: 33
    var horizontalPadding: CGFloat // default: 10
    var iconTextSpacing: CGFloat  // default: 6
}
```

**Factory presets:**

| Method | Variant | Icon |
|---|---|---|
| `.specialOffer(text:)` | `.offer` | `tag.fill` |
| `.successBanner(text:)` | `.success` | `checkmark.circle.fill` |
| `.warningBanner(text:)` | `.warning` | `exclamationmark.triangle.fill` |
| `.infoBanner(text:)` | `.info` | `info.circle.fill` |

### DSPromoBannerVariant

| Value | Background | Foreground | Use |
|---|---|---|---|
| `.offer` | Deep brand purple `#55228A` | White | Offer strips (Figma default) |
| `.success` | Semantic green | White | Confirmation states |
| `.warning` | Semantic amber | Near-black (primary) | Caution states |
| `.info` | Brand primary blue | White | Neutral contextual info |
| `.custom(background:foreground:)` | Caller-supplied | Caller-supplied | Brand-approved deviations |

---

## Variants, States, and Behaviors

- Rectangle shape — no rounded corners (matches Figma).
- Optional SF Symbol icon left of the label (10 pt leading, 6 pt icon-text gap by default).
- Content: TedNext-Bold 12 pt, white (label token style from `RDSToken.Typography`).
- Icon: 12 pt, same foreground color as the label.
- Both icon and text are always horizontally centered vertically within the 33 pt min-height.
- `minHeight` can be increased for taller strip needs; width fills 100% of the parent.

---

## Accessibility Notes

- The entire banner is a single static text element for VoiceOver.
- The leading icon is marked decorative (hidden from accessibility tree).
- `accessibilityLabel` defaults to the `text` value — override if the icon adds meaningful context.

---

## SwiftUI Examples

### Offer strip (Figma node 128:60)

```swift
DSPromoBanner(configuration: .specialOffer())
```

### Plan card header

```swift
VStack(spacing: 0) {
    DSPromoBanner(configuration: .specialOffer())
    VStack(alignment: .leading, spacing: 8) {
        DSLabel("Rogers Infinite+", style: RDSToken.Typography.title4)
        DSLabel("Unlimited data · 5G", color: .secondary)
        DSButton("Select plan", variant: .primary) { selectPlan() }
    }
    .padding(16)
}
.background(Color(RDSToken.Color.surface))
.cornerRadius(12)
```

### Success confirmation strip

```swift
DSPromoBanner(configuration: .successBanner(text: "Plan activated successfully"))
```

### Warning strip above an overdue balance

```swift
DSPromoBanner(configuration: .warningBanner(text: "Payment overdue — action required"))
```

### Custom brand banner

```swift
DSPromoBanner(
    text: "Limited time: Free activation",
    iconName: "star.fill",
    variant: .custom(background: Color(red: 0.1, green: 0.1, blue: 0.18), foreground: .white)
)
```

---

## UIKit Integration

### DSPromoBannerHostingController

```swift
let vc = DSPromoBannerHostingController(configuration: .specialOffer())
vc.embed(in: cardView, below: nil, controller: self)
```

### DSPromoBannerView

Drop-in `UIView` wrapper for cells and stack views.

```swift
let bannerView = DSPromoBannerView(configuration: .specialOffer())
stackView.addArrangedSubview(bannerView)
```

### DSPromoBannerFactory

Static presets for quick UIKit construction without hosting controller overhead.

```swift
let banner = DSPromoBannerFactory.makeOfferBanner()
view.addSubview(banner)
```

Update without re-creating:

```swift
bannerVC.update(configuration: .warningBanner(text: "Bill due tomorrow"))
```

---

## Screen Composition Guidance

### Where DSPromoBanner sits in the screen hierarchy

- **Above** `DSPageHeader` on offer / marketing screens — the banner is the first element in the scroll content area, pinned flush to the top below the navigation bar.
- **Above** the first content block on plan or subscription cards — inside the card `VStack` before the plan title.
- **Below** `DSPageHeader` and **above** form inputs when the banner signals a status or alert relevant to the form.

### Focused composition recipes

**Marketing offer screen (top-of-screen)**
```swift
ScrollView {
    VStack(spacing: 0) {
        DSPromoBanner(configuration: .specialOffer(text: "Limited time: 3 months free"))
        DSPageHeader(title: "Upgrade your plan")
            .padding(.horizontal, 24)
            .padding(.top, 24)
        // plan cards below
    }
}
```

**Plan selection card**
```swift
VStack(spacing: 0) {
    DSPromoBanner(configuration: .specialOffer())
    VStack(alignment: .leading, spacing: 12) {
        DSLabel("Rogers Infinite+", style: RDSToken.Typography.title4)
        DSLabel("Unlimited · 5G · Canada-wide", color: .secondary)
        DSButton("Select", variant: .primary) { select() }
    }
    .padding(16)
}
```

**Status feedback above a form**
```swift
VStack(spacing: 16) {
    DSPromoBanner(configuration: .warningBanner(text: "Session expired — sign in again"))
    DSTextField("Email", placeholder: "you@rogers.com", text: $email)
    DSTextField("Password", isSecure: true, text: $password)
    DSButton("Sign in", variant: .primary) { signIn() }
}
.padding(24)
```

---

## Related Components

| Related Component | Relationship | When to Pair |
|---|---|---|
| `DSPageHeader` | Content below the banner | Always pair on offer screens |
| `DSButton` | CTA following a promotional offer | Plan upgrade, activation flows |
| `DSLabel` | Body copy after the banner | Detailed plan descriptions |
| `DSTabBar` | App shell navigation — independent | App shell above screen content |

---

## Constraints and Caveats

- Banner text should remain short (one line at the default 33 pt height); long strings wrap and increase height but may look unbalanced.
- No interaction support — the banner is display-only; do not add tap handlers expecting button-like behavior.
- `DSPromoBannerVariant.custom` bypasses the semantic token system; use only for brand-approved custom colors.
- Icon size is fixed at 12 pt and cannot be changed without modifying `DSPromoBannerConfiguration`.
    DSPromoBanner(configuration: .specialOffer())

    VStack(alignment: .leading, spacing: 12) {
        DSLabel("Rogers Infinite+", style: .title4, color: .primary)
        DSButton("Get this plan", variant: .primary) {}
    }
    .padding()
}
```

## UIKit Integration

- `DSPromoBannerHostingController`
- `DSPromoBannerView`
- `DSPromoBannerFactory`

Example:

```swift
let banner = DSPromoBannerFactory.makeOfferBanner(
    text: "Special Offer for you"
)
```

## Screen Composition Guidance

- Common placement: very top of cards, top of stacked marketing modules, or under a navigation/header region.
- Pairs most often with: `DSLabel`, `DSHeroText`, `DSButton`.
- Recommended order: promo strip -> headline/content -> CTA.

## Related Components

| Related Component | Relationship | When to Pair |
| --- | --- | --- |
| `DSHeroText` | Adds large supporting message below strip | Campaign and promo areas |
| `DSButton` | Converts promo into action | Offer cards and plan surfaces |
| `DSLabel` | Provides body details under strip | Pricing and plan descriptions |

## Constraints And Caveats

- This component is intentionally compact and not a general alert framework.
- Message length should stay short to preserve the strip pattern.