# DSCompactTile

## Purpose

`DSCompactTile` is a reusable compact metric card for displaying a title, a headline metric, supporting text, and a progress indicator.

Derived from Figma JSON node `128:177` (data usage tile).

## SwiftUI Usage

```swift
import Components

DSCompactTile(configuration: .dataUsage())

DSCompactTile(
    configuration: DSCompactTileConfiguration(
        title: "Cloud Storage",
        valueText: "40%",
        detailText: "40 GB of 100 GB is used",
        progress: 0.4,
        leadingIconSystemName: "externaldrive.fill",
        actionIconSystemName: "chevron.right",
        showsActionButton: true
    ),
    onActionTap: {
        // Handle action
    }
)
```

## UIKit Usage

```swift
import UIKitCompat

let tile = DSCompactTileFactory.makeDataUsageTile(
    progress: 0.63,
    onActionTap: {
        // Handle action
    }
)

stackView.addArrangedSubview(tile)
```

## API Surface

- `DSCompactTile`
- `DSCompactTileConfiguration`
- `DSCompactTileHostingController`
- `DSCompactTileView`
- `DSCompactTileFactory`

## Token Mapping

- Card background/border: `RDSToken.Color.compactTileBackground`, `RDSToken.Color.compactTileBorder`
- Accessory surfaces: `RDSToken.Color.compactTileAccessoryBackground`, `RDSToken.Color.compactTileAccessoryForeground`
- Progress: `RDSToken.Color.compactTileProgressTrack`, `RDSToken.Color.compactTileProgressFill`
- Title/metric/detail typography: `RDSToken.Typography.compactTileTitle`, `compactTileMetric`, `compactTileDetail`

## Accessibility

- The tile is exposed as one combined accessibility element with title, value, detail, and progress percentage.
- Optional action button exposes button traits when an action closure is provided.
