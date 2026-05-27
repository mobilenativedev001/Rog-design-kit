# DSPromoBanner Component Catalog

`DSPromoBanner` is the short-form promotional and status strip for high-contrast messaging across cards, offers, and inline campaign surfaces.

## Component Summary

- Module: `Components`
- Purpose: Render a full-width rectangular banner with a short message and optional icon.
- Best fit: Offer strips, confirmation/status strips, and plan card headers.

## When To Use It

- Use `DSPromoBanner` for short, high-priority messaging that should sit above content.
- Use built-in presets when the use case matches offer, success, warning, or info messaging.

Avoid it for multiline alerts, dismissible notices, or interaction-heavy containers.

## API And Companion Types

```swift
DSPromoBanner(configuration: .specialOffer())
```

```swift
DSPromoBanner(
    text: "Payment due in 3 days",
    iconName: "exclamationmark.triangle.fill",
    variant: .warning
)
```

Companion types:

- `DSPromoBannerConfiguration`
- `DSPromoBannerVariant`: `offer`, `success`, `warning`, `info`, `custom(background:foreground:)`

## Variants, States, And Behaviors

- Variants: offer, success, warning, info, custom.
- Optional icon through `iconName`.
- Default minimum height of 33 pt with rectangular corners.
- Best when copy remains short enough for single-line display.

## Accessibility Notes

- Exposed as a single static text element.
- Decorative icon is hidden from accessibility.

## SwiftUI Examples

Offer strip:

```swift
DSPromoBanner(configuration: .specialOffer())
```

Plan-card header:

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