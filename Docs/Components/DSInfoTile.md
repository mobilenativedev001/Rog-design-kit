# DSInfoTile

Promotional product tile composing a top offer banner (`DSPromoBanner`), a media/image area, brand name, product title, description, and an optional secondary action button. Derived from Figma node 128:209 (Frame 27).

---

## Component Summary

| Field | Value |
|---|---|
| Module | `Components` |
| UIKit support | `DSInfoTileHostingController`, `DSInfoTileView`, `DSInfoTileFactory` in `UIKitCompat` |
| Composes | `DSPromoBanner` (`.offer` variant) internally |
| Figma | Node 128:209 (Frame 27) |

---

## When to Use It

- Use `DSInfoTile` when a campaign or promotional card needs a branded header strip + image + structured product copy, with an optional "Shop now" style secondary action.
- Use the `.specialOffer()` preset for the Figma-aligned product promotion card.

**Avoid** `DSInfoTile` when:
- The content is a service status/feature toggle — use `DSActionTile`
- A compact metric with progress is needed — use `DSCompactTile`
- Only a full-width alert strip is needed — use `DSPromoBanner` directly

---

## API and Companion Types

### DSInfoTile — Initialisers

```swift
// Figma-exact preset
DSInfoTile(configuration: .specialOffer())

// With secondary action
DSInfoTile(
    configuration: .specialOffer(secondaryButtonTitle: "Shop now"),
    onSecondaryButtonTap: { navigateToShop() }
)

// Fully custom
DSInfoTile(
    configuration: DSInfoTileConfiguration(
        badgeText: "Special Offer for you",
        badgeIconSystemName: "tag.fill",
        brandText: "Apple",
        titleText: "iPhone 17 Pro Max",
        descriptionText: "Save up to $1,000 when you trade in your eligible device",
        secondaryButtonTitle: "Shop now",
        image: productImage,
        imageAccessibilityLabel: "iPhone 17 Pro Max"
    ),
    onSecondaryButtonTap: { navigateToShop() }
)
```

### DSInfoTileConfiguration

```swift
public struct DSInfoTileConfiguration {
    var badgeText: String                       // Offer banner label, e.g. "Special Offer for you"
    var badgeIconSystemName: String?            // SF Symbol for badge, e.g. "tag.fill"
    var brandText: String                       // Brand label above title, e.g. "Apple"
    var titleText: String                       // Product title, e.g. "iPhone 17 Pro Max"
    var descriptionText: String                 // Supporting copy
    var secondaryButtonTitle: String?           // When non-nil, shows an outline button
    var image: Image?                           // Product/campaign image; nil shows placeholder
    var imageAccessibilityLabel: String?        // VoiceOver label for image
    var accessibilityLabel: String?
    var accessibilityHint: String?
    var accessibilityIdentifier: String?
}
```

**Factory preset:**

```swift
DSInfoTileConfiguration.specialOffer(
    badgeText: "Special Offer for you",
    brandText: "Apple",
    titleText: "iPhone 17 Pro Max",
    descriptionText: "Save up to $1,000 on any iPhone when you trade in your eligible device",
    secondaryButtonTitle: nil,           // Omit button by default
    image: nil
)
```

---

## Variants, States, and Behaviors

- **Badge/offer strip:** always `.offer` variant of `DSPromoBanner` (brand purple background).
- **Image area:** shows `image` if non-nil; falls back to a placeholder fill.
- **Secondary button:** rendered only when `secondaryButtonTitle` is non-nil; uses `DSButton` with `.outline` style and `.medium` size.
- There is no explicit loading or disabled state for the tile itself — disable the secondary button externally if needed.

**Token mapping:**

| Visual element | Token |
|---|---|
| Offer banner | `DSPromoBanner` `.offer` variant tokens |
| Brand text | `RDSToken.Typography.bodyRegular` |
| Product title | `RDSToken.Typography.bodyBold` |
| Description | `RDSToken.Typography.bodyRegular` |
| Secondary button | `DSButton` outline style tokens |
| Image placeholder bg | `RDSToken.Color.backgroundColor` |
| Image placeholder icon | `RDSToken.Color.textSecondaryColor` |

---

## Accessibility Notes

- The entire tile is a single combined accessibility element by default.
- When a secondary button is configured, the tile exposes contained accessibility elements so the button is reachable as a separate interactive control.
- `imageAccessibilityLabel` supplies VoiceOver context for the image area.
- `accessibilityLabel`, `accessibilityHint`, and `accessibilityIdentifier` are supported.

---

## SwiftUI Examples

### Figma-exact special offer (no button)

```swift
DSInfoTile(configuration: .specialOffer())
    .padding(16)
```

### With secondary action

```swift
DSInfoTile(
    configuration: .specialOffer(secondaryButtonTitle: "Shop now"),
    onSecondaryButtonTap: { navigateToDeviceShop() }
)
.padding(.horizontal, 16)
```

### Fully custom product tile

```swift
DSInfoTile(
    configuration: DSInfoTileConfiguration(
        badgeText: "Limited Time Deal",
        badgeIconSystemName: "bolt.fill",
        brandText: "Samsung",
        titleText: "Galaxy S25 Ultra",
        descriptionText: "Trade in your old device and save up to $800",
        secondaryButtonTitle: "View offer",
        image: Image("samsung_s25"),
        imageAccessibilityLabel: "Samsung Galaxy S25 Ultra"
    ),
    onSecondaryButtonTap: { navigateToOffer() }
)
```

---

## UIKit Integration

### DSInfoTileHostingController

```swift
let tileVC = DSInfoTileHostingController(
    configuration: .specialOffer(secondaryButtonTitle: "Shop now"),
    onSecondaryButtonTap: { navigateToShop() }
)
addChild(tileVC)
view.addSubview(tileVC.view)
tileVC.view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    tileVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    tileVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    tileVC.view.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24)
])
tileVC.didMove(toParent: self)
```

### DSInfoTileView

Drop-in `UIView` wrapper for cells and scroll stack views.

```swift
let tileView = DSInfoTileView(
    configuration: .specialOffer(),
    onSecondaryButtonTap: nil
)
scrollStack.addArrangedSubview(tileView)
```

### DSInfoTileFactory

Quick construction of the standard special-offer tile:

```swift
let tile = DSInfoTileFactory.makeSpecialOfferTile(
    secondaryButtonTitle: "Shop now",
    onSecondaryButtonTap: { navigateToShop() }
)
containerView.addSubview(tile)
```

---

## Screen Composition Guidance

### Where DSInfoTile sits in the screen hierarchy

- Typically a full-width (minus standard 16 pt horizontal insets) card near the top of a plans or promotions screen.
- Pairs with a scrollable list of plan options or `DSActionTile` service tiles below it.
- Can appear in a horizontal scroll carousel on a home dashboard for multiple active offers.

### Promotions screen recipe

```swift
ScrollView {
    VStack(alignment: .leading, spacing: 24) {
        DSPageHeader(title: "Exclusive Offers")
            .padding(.horizontal, 24)

        DSInfoTile(
            configuration: .specialOffer(secondaryButtonTitle: "Shop now"),
            onSecondaryButtonTap: { navigateToDeviceShop() }
        )
        .padding(.horizontal, 16)

        DSLabel("More Plans", style: RDSToken.Typography.title4, color: .primary)
            .padding(.horizontal, 24)

        // Additional plan cards…
    }
    .padding(.vertical, 20)
}
```

---

## Related Components

| Related Component | Relationship | When to Pair |
|---|---|---|
| `DSPromoBanner` | Composed internally for the offer strip | Use `DSPromoBanner` alone for simpler full-width alert strips |
| `DSActionTile` | Complementary status/service card | When service tiles follow a promotional card on the same screen |
| `DSCompactTile` | Complementary metric card | When usage metrics appear alongside promotional content |
| `DSButton` | Used internally for secondary action | Customise via `secondaryButtonTitle` only; don't add a separate button outside the tile |
| `DSPageHeader` | Section context above the tile | Plans or promotions screen header |

---

## Known Gaps and Constraints

- Only one optional secondary action button is supported; multi-action layouts are not possible.
- The offer badge variant is hardcoded to `.offer` (brand purple); no other banner variant is available through `DSInfoTileConfiguration`.
- The tile width is unconstrained by the component — always apply `.padding(.horizontal, 16)` or equivalent at the call site.
- `DSInfoTileFactory.makeSpecialOfferTile()` returns a `DSInfoTileView` UIKit wrapper only. Use `DSInfoTileHostingController` when embedding in a `UIViewController`.
