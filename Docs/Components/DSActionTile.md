# DSActionTile Component Catalog

`DSActionTile` is a horizontal card component displaying an icon, title, status text, and optional action button. Designed for feature toggles, service status cards, and informational tiles with CTAs.

## Component Summary

- Module: `Components`
- Purpose: Present feature status, service information, or promotional offers with optional user action.
- Best fit: Settings screens, account management, feature activation flows, service status dashboards.
- Figma reference: Chatr-POC node 128:199 (Frame 29)

## When To Use It

- Use `DSActionTile` to display service or feature status with an optional action (e.g., "Roaming: Not Active" with "Activate now" button).
- Use for informational tiles where users need to see status at-a-glance and potentially take action.
- Use in lists or stacked layouts where multiple features/services need consistent presentation.

Avoid it when:
- The interaction is navigation-only (use navigation links instead).
- No status or action context is needed (use simpler components like `DSLabel` or `DSPageHeader`).
- The layout requires a vertical card design (this is horizontal-only).

## API And Companion Types

Primary APIs:

```swift
// Full configuration with button
DSActionTile(
    icon: Image(systemName: "airplane"),
    title: "Roaming",
    status: "Not Active",
    statusType: .inactive,
    buttonTitle: "Activate now"
) {
    activateRoaming()
}

// Display-only (no button)
DSActionTile(
    icon: Image(systemName: "checkmark.circle.fill"),
    title: "Data Plan",
    status: "Active",
    statusType: .active
)

// Configuration-based API
let config = DSActionTileConfiguration(
    icon: Image(systemName: "exclamationmark.triangle.fill"),
    title: "Payment",
    status: "Attention Required",
    statusType: .warning,
    buttonTitle: "Review"
)
DSActionTile(configuration: config) {
    reviewPayment()
}
```

Companion types:

- `DSActionTileConfiguration`: Value-type configuration for tile properties.
- `DSActionTileStatus`: Semantic status enum (`.active`, `.inactive`, `.warning`, `.error`, `.neutral`).

## Variants, States, And Behaviors

- **Status Types**: `.active` (success green), `.inactive` (error red), `.warning` (warning orange), `.error` (error red), `.neutral` (secondary gray).
- **Button Presence**: Optional. When `buttonTitle` is `nil`, the tile is display-only.
- **Visual States**: Status text color adapts to `statusType`. All colors support light/dark mode and high-contrast automatically.
- **Layout Behavior**: Horizontal layout with icon (24×24 pt), title/status stack, spacer, and optional button. Flexible width adapts to parent container.

## Accessibility Notes

- The entire tile is treated as a single accessibility element with combined children.
- Default accessibility label: "{title}, {status}".
- Override with custom `accessibilityLabel` and `accessibilityHint` as needed.
- Button interaction is handled separately by the embedded `DSButton` (when present).
- Minimum tap target size enforced by `DSButton` (44 pt min height).
- VoiceOver announces status type through color-coded status text.

## SwiftUI Examples

### Feature Toggle Tile

```swift
DSActionTile(
    icon: Image(systemName: "airplane"),
    title: "Roaming",
    status: "Not Active",
    statusType: .inactive,
    buttonTitle: "Activate now"
) {
    activateRoaming()
}
```

### Status Display (No Action)

```swift
DSActionTile(
    icon: Image(systemName: "checkmark.circle.fill"),
    title: "Unlimited Data",
    status: "Active",
    statusType: .active
)
```

### Multiple Tiles in VStack

```swift
VStack(spacing: 16) {
    DSActionTile(
        icon: Image(systemName: "checkmark.circle.fill"),
        title: "Data Plan",
        status: "Active",
        statusType: .active
    )
    
    DSActionTile(
        icon: Image(systemName: "airplane"),
        title: "Roaming",
        status: "Not Active",
        statusType: .inactive,
        buttonTitle: "Activate now"
    ) {
        activateRoaming()
    }
    
    DSActionTile(
        icon: Image(systemName: "exclamationmark.triangle.fill"),
        title: "Payment",
        status: "Attention Required",
        statusType: .warning,
        buttonTitle: "Review"
    ) {
        reviewPayment()
    }
}
.padding()
```

### Custom Accessibility

```swift
DSActionTile(
    icon: Image(systemName: "phone.fill"),
    title: "Voice Calls",
    status: "Unlimited Canada-wide",
    statusType: .neutral,
    accessibilityLabel: "Voice Calls feature, Unlimited Canada-wide calling",
    accessibilityHint: "Double tap to learn more about your calling plan"
)
```

## UIKit Integration

- `DSActionTileHostingController`: Preferred embedding path in a `UIViewController` hierarchy.
- `DSActionTileView`: `UIView` wrapper for cells and stack-view-based layouts.

### UIViewController Embedding

```swift
let tileVC = DSActionTileHostingController(
    configuration: DSActionTileConfiguration(
        icon: UIImage(systemName: "airplane")!.toSwiftUIImage(),
        title: "Roaming",
        status: "Not Active",
        statusType: .inactive,
        buttonTitle: "Activate now"
    ),
    action: { [weak self] in
        self?.activateRoaming()
    }
)

addChild(tileVC)
view.addSubview(tileVC.view)
tileVC.view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    tileVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
    tileVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
    tileVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
])
tileVC.didMove(toParent: self)
```

### Quick Embed Helper

```swift
DSActionTileHostingController.embed(
    in: self,
    configuration: DSActionTileConfiguration(
        icon: UIImage(systemName: "checkmark.circle.fill")!.toSwiftUIImage(),
        title: "Data Plan",
        status: "Active",
        statusType: .active
    )
)
```

### UIView Wrapper (UITableViewCell)

```swift
class FeatureTileCell: UITableViewCell {
    private var tileView: DSActionTileView?
    
    func configure(with feature: Feature) {
        tileView?.removeFromSuperview()
        
        let config = DSActionTileConfiguration(
            icon: feature.icon,
            title: feature.name,
            status: feature.status,
            statusType: feature.statusType,
            buttonTitle: feature.actionTitle
        )
        
        let tile = DSActionTileView(configuration: config) { [weak self] in
            self?.handleAction(for: feature)
        }
        
        contentView.addSubview(tile)
        tile.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tile.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tile.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tile.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            tile.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        self.tileView = tile
    }
}
```

## Screen Composition Guidance

- Common placement: Settings screens, account dashboards, feature lists.
- Pairs most often with: `DSPageHeader`, `DSLabel`, `DSPromoBanner`, `DSButton`.
- Account settings recipe: `DSPageHeader` → VStack of multiple `DSActionTile` → footer actions.
- Feature activation recipe: promotional context → `DSActionTile` with activation button → confirmation flow.

### Typical Layout Pattern

```swift
VStack(alignment: .leading, spacing: 24) {
    DSPageHeader(
        title: "Manage Services",
        subtitle: "Control your account features"
    )
    
    VStack(spacing: 16) {
        DSActionTile(
            icon: Image(systemName: "airplane"),
            title: "Roaming",
            status: "Not Active",
            statusType: .inactive,
            buttonTitle: "Activate now"
        ) {
            activateRoaming()
        }
        
        DSActionTile(
            icon: Image(systemName: "checkmark.circle.fill"),
            title: "Data Plan",
            status: "Active",
            statusType: .active,
            buttonTitle: "Manage"
        ) {
            manageDataPlan()
        }
    }
}
.padding()
```

## Related Components

| Related Component | Relationship | When to Pair |
| --- | --- | --- |
| `DSButton` | Embedded action control | Always used internally when `buttonTitle` is provided |
| `DSLabel` | Embedded text display | Always used internally for title and status |
| `DSPageHeader` | Section context above tiles | Settings screens, feature dashboards |
| `DSPromoBanner` | Promotional context | Marketing flows, offer activation |

## Token Mapping from Figma

The component was designed from Figma node 128:199 (Frame 29) with the following token mappings:

| Figma Property | Token | Value |
| --- | --- | --- |
| Container background | `RDSToken.Color.surface` | White/dark-gray adaptive |
| Border color | `RDSToken.Color.border` | Gray200/Gray700 adaptive |
| Corner radius | `RDSToken.Spacing.medium` | 16 pt |
| Title typography | `RDSToken.Typography.bodyBold` | TedNext-Bold 16/24 pt |
| Status typography | `RDSToken.Typography.bodySmall` | TedNext-Medium 14/20 pt |
| Icon size | Fixed | 24×24 pt |
| Status colors | Semantic tokens | `.success`, `.error`, `.warning`, `.secondary` |

## Constraints And Caveats

- This component is horizontal-only. For vertical card layouts, use a different component or compose manually.
- The icon must be 24×24 pt for visual consistency (recommendation, not enforced).
- Button reuses `DSButton` with `.outline` variant and `.medium` size (fixed, not configurable).
- Layout uses flexible spacing (Spacer) rather than fixed gap to accommodate dynamic content and accessibility sizing.
- No built-in full-width constraint; width is determined by parent layout.
- Snapshot coverage is provided through SwiftUI previews rather than dedicated test files.

## Implementation Notes

- **Reusable Components**: Uses `DSLabel` for all text and `DSButton` for actions, following the design system's composition-first architecture.
- **Token-Driven**: All colors, typography, spacing, and corner radius values use semantic tokens for dark mode and accessibility compliance.
- **Accessibility**: Combined accessibility element with custom label and hint support. Status semantics conveyed through color mapping.
- **UIKit Compatibility**: Full UIKit support through hosting controllers and view wrappers with proper lifecycle integration.
