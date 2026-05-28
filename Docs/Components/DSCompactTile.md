# DSCompactTile

Compact, token-driven metric card for displaying a title, headline metric value, supporting detail text, and an animated horizontal progress bar. Derived from Figma node 128:177 (data usage tile).

---

## Component Summary

| Field | Value |
|---|---|
| Module | `Components` |
| UIKit support | `DSCompactTileHostingController`, `DSCompactTileView`, `DSCompactTileFactory` in `UIKitCompat` |
| Figma | Node 128:177 |
| Typical width | ~200 pt (constrained by parent layout) |

---

## When to Use It

- Use `DSCompactTile` when a numeric metric (percentage, ratio, or count) needs to be shown alongside a progress indicator in a compact footprint.
- Use the `.dataUsage()` preset for the standard Figma-aligned data usage tile.
- Pair tiles side by side in a horizontal scroll or 2-column grid for multi-metric dashboards.

**Avoid** `DSCompactTile` when:
- The content is a binary on/off service status — use `DSActionTile`
- No numeric metric or progress visualization is needed
- The design calls for a full-width card with a prominent CTA — use `DSActionTile` or `DSInfoTile`

---

## API and Companion Types

### DSCompactTile — Initialisers

```swift
// Configuration-based (preferred)
DSCompactTile(configuration: .dataUsage())

// Inline convenience
DSCompactTile(
    title: "Cloud Storage",
    valueText: "40%",
    detailText: "40 GB of 100 GB is used",
    progress: 0.4,
    leadingIconSystemName: "externaldrive.fill",
    actionIconSystemName: "chevron.right",
    showsActionButton: true,
    onActionTap: { navigateToStorage() }
)
```

### DSCompactTileConfiguration

Value-type aggregate for all tile properties.

```swift
public struct DSCompactTileConfiguration {
    var title: String                    // e.g. "Data Usage"
    var valueText: String                // e.g. "63%"
    var detailText: String               // e.g. "12.6 GB of 20 GB is used"
    var progress: Double                 // 0.0–1.0, clamped automatically
    var leadingIconSystemName: String?   // default: "antenna.radiowaves.left.and.right"
    var actionIconSystemName: String?    // default: "plus"
    var showsActionButton: Bool          // default: true
    var accessibilityLabel: String?
    var accessibilityHint: String?
    var accessibilityIdentifier: String?
}
```

**Factory preset:**

```swift
DSCompactTileConfiguration.dataUsage(
    title: "Data Usage",
    valueText: "63%",
    detailText: "12.6 GB of 20 GB is used",
    progress: 0.63
)
```

---

## Variants, States, and Behaviors

- **Progress bar**: full-width horizontal pill at the bottom of the tile; fill (`compactTileProgressFill`) expands left-to-right based on `progress`.
- **Action button**: optional circle icon in the header row (top trailing); only visible when `showsActionButton: true` and `actionIconSystemName` is non-nil.
- **Leading icon**: optional circle accessory in the header row (top leading).
- **`progress`** is clamped to `[0, 1]`; values outside this range are safe.
- All colors token-driven; light/dark mode adapts automatically.

**Token mapping:**

| Visual element | Token |
|---|---|
| Card background | `RDSToken.Color.compactTileBackgroundColor` |
| Card border | `RDSToken.Color.compactTileBorderColor` |
| Accessory fill | `RDSToken.Color.compactTileAccessoryBackgroundColor` |
| Accessory icon | `RDSToken.Color.compactTileAccessoryForegroundColor` |
| Progress track | `RDSToken.Color.compactTileProgressTrackColor` |
| Progress fill | `RDSToken.Color.compactTileProgressFillColor` |
| Title | `RDSToken.Typography.compactTileTitle` |
| Metric value | `RDSToken.Typography.compactTileMetric` |
| Detail | `RDSToken.Typography.compactTileDetail` |

---

## Accessibility Notes

- The entire tile is exposed as one combined accessibility element.
- Default accessibility label: `"{title}, {valueText}, {detailText}"`.
- `accessibilityValue` reports the progress as `"{N} percent"`.
- The action button (when tappable) exposes `.isButton` trait separately with label "Add" and hint "Performs compact tile action".
- The progress bar is `accessibilityHidden` — progress is already conveyed via `accessibilityValue`.

---

## SwiftUI Examples

### Standard data-usage tile (Figma node 128:177)

```swift
DSCompactTile(configuration: .dataUsage())
    .frame(width: 200)
```

### Custom storage metric

```swift
DSCompactTile(
    configuration: DSCompactTileConfiguration(
        title: "Cloud Storage",
        valueText: "40%",
        detailText: "40 GB of 100 GB is used",
        progress: 0.4,
        leadingIconSystemName: "externaldrive.fill",
        actionIconSystemName: "chevron.right",
        showsActionButton: true,
        accessibilityLabel: "Cloud Storage, 40%, 40 GB of 100 GB used"
    ),
    onActionTap: { navigateToStorage() }
)
.frame(width: 200)
```

### Side-by-side metrics grid

```swift
ScrollView(.horizontal, showsIndicators: false) {
    HStack(spacing: 12) {
        DSCompactTile(configuration: .dataUsage(progress: 0.63))
        DSCompactTile(
            title: "Talk Time",
            valueText: "40%",
            detailText: "120 of 300 min used",
            progress: 0.4,
            leadingIconSystemName: "phone.fill",
            showsActionButton: false
        )
        DSCompactTile(
            title: "Texts",
            valueText: "Unlimited",
            detailText: "No limit applied",
            progress: 0.0,
            leadingIconSystemName: "message.fill",
            showsActionButton: false
        )
    }
    .padding(.horizontal, 16)
}
```

---

## UIKit Integration

### DSCompactTileHostingController

```swift
let tileVC = DSCompactTileHostingController(
    configuration: .dataUsage(progress: 0.75),
    onActionTap: { navigateToDataAddOn() }
)
addChild(tileVC)
view.addSubview(tileVC.view)
tileVC.view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    tileVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
    tileVC.view.widthAnchor.constraint(equalToConstant: 200),
    tileVC.view.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16)
])
tileVC.didMove(toParent: self)

// Update later
tileVC.update(configuration: .dataUsage(progress: 0.9))
```

### DSCompactTileView

Drop-in `UIView` wrapper for cells and stack views.

```swift
let tileView = DSCompactTileView(
    configuration: .dataUsage(),
    onActionTap: { addMoreData() }
)
horizontalStack.addArrangedSubview(tileView)
```

### DSCompactTileFactory

Quick construction of the standard data-usage tile:

```swift
let tile = DSCompactTileFactory.makeDataUsageTile(
    progress: 0.63,
    onActionTap: { navigateToDataManagement() }
)
stackView.addArrangedSubview(tile)
```

---

## Screen Composition Guidance

### Where DSCompactTile sits in the screen hierarchy

- Typically in a horizontal scroll row or 2-column grid below a `DSPageHeader` on home or account screens.
- Can appear inside a plan card below the plan name and pricing copy.
- Do **not** use as the sole full-width content of a section — its compact footprint works best alongside other metric tiles or content blocks.

### Account overview recipe

```swift
ScrollView {
    VStack(alignment: .leading, spacing: 20) {
        DSPageHeader(title: "My Account")
            .padding(.horizontal, 24)

        DSLabel("Usage this period",
                style: RDSToken.Typography.title4,
                color: .primary)
            .padding(.horizontal, 24)

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                DSCompactTile(configuration: .dataUsage(progress: 0.63))
                DSCompactTile(
                    title: "Talk Time",
                    valueText: "40%",
                    detailText: "120 of 300 min",
                    progress: 0.4,
                    leadingIconSystemName: "phone.fill",
                    showsActionButton: false
                )
            }
            .padding(.horizontal, 16)
        }
    }
}
```

---

## Related Components

| Related Component | Relationship | When to Pair |
|---|---|---|
| `DSActionTile` | Complementary status card | When a service status or CTA belongs in the same dashboard |
| `DSPageHeader` | Section context above the metric row | Account and home screens |
| `DSLabel` | Surrounding explanatory or section copy | Metric context headings |
| `DSPromoBanner` | Status/alert message above the metric row | Data overage alerts |

---

## Known Gaps and Constraints

- `DSCompactTile` requires both `valueText` and `detailText` — there is no text-only or value-only mode.
- The progress bar height (`xxSmall` token) and tile-specific color tokens (`compactTileProgressFill`, `compactTileMetric`, etc.) are not documented in `Docs/Tokens.md`.
- `RDSToken.Spacing.xxSmall` is used internally but is not listed in the public spacing token documentation.
- Tile width is unconstrained by the component; always provide a width constraint at the call site (typically `.frame(width: 200)` or via parent layout).
- No built-in empty state or skeleton loader is provided.

