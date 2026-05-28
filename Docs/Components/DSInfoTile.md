# DSInfoTile

## Purpose

`DSInfoTile` is a reusable promotional content tile composed of:

- a top offer banner row powered by `DSPromoBanner`
- a media preview area
- brand/title/description text content
- an optional secondary action button (`DSButton` with configurable label)

It is derived from Figma JSON node `128:209` (Frame 27) and designed for product or campaign highlights.

## SwiftUI Usage

```swift
import Components

DSInfoTile(configuration: .specialOffer())

DSInfoTile(
    configuration: DSInfoTileConfiguration(
        badgeText: "Special Offer for you",
        badgeIconSystemName: "tag.fill",
        brandText: "Apple",
        titleText: "iPhone 17 Pro Max",
        descriptionText: "Save up to $1,000 on any iphone when you trade in your eligible device",
        secondaryButtonTitle: "Shop now"
    )
)

DSInfoTile(
    configuration: .specialOffer(secondaryButtonTitle: "Learn more"),
    onSecondaryButtonTap: {
        // handle action
    }
)
```

## UIKit Usage

```swift
import UIKitCompat

let tile = DSInfoTileFactory.makeSpecialOfferTile()
stackView.addArrangedSubview(tile)

let tileWithActionLabel = DSInfoTileFactory.makeSpecialOfferTile(
    secondaryButtonTitle: "Shop now"
)
```

Or embed via hosting controller:

```swift
let host = DSInfoTileHostingController(configuration: .specialOffer())
addChild(host)
containerView.addSubview(host.view)
host.didMove(toParent: self)
```

## API Surface

- `DSInfoTile`
- `DSInfoTileConfiguration`
- `DSInfoTileHostingController`
- `DSInfoTileView`
- `DSInfoTileFactory`
- Optional secondary action input:
    - `DSInfoTileConfiguration.secondaryButtonTitle`
    - `DSInfoTile.init(configuration:onSecondaryButtonTap:)`

## Token Mapping

- Offer banner colors and icon styling: inherited from `DSPromoBanner` (`.offer` variant)
- Content text color: `DSTextColor.primary`
- Image placeholder background: `RDSToken.Color.backgroundColor`
- Image placeholder icon: `RDSToken.Color.textSecondaryColor`

Typography mapping:

- Offer banner text: `RDSToken.Typography.label` (via `DSPromoBanner`)
- Brand text: `RDSToken.Typography.bodyRegular`
- Product title: `RDSToken.Typography.bodyBold`
- Description text: `RDSToken.Typography.bodyRegular`
- Secondary button text: `DSButton` secondary style typography tokens

Spacing and sizing are derived from `RDSToken.Spacing` values only.

## Accessibility

- The tile is exposed as one combined accessibility element by default.
- When a secondary button is configured, the tile exposes contained accessibility
    elements so the button is reachable as a separate interactive control.
- Optional `accessibilityLabel`, `accessibilityHint`, and `accessibilityIdentifier` are supported.
- The image exposes `imageAccessibilityLabel` to provide meaningful context.