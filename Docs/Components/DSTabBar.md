# DSTabBar

Typed, token-driven bottom navigation bar for app shells and embedded multi-destination flows. State-driven via a generic `Hashable` selection binding. Supports badge overlays (dot or count), per-item enable/disable, animated indicator, top divider, and drop-shadow.

---

## Component Summary

| Field | Value |
|---|---|
| Module | `Components` |
| UIKit support | `DSTabBarHostingController`, `DSTabBarView` in `UIKitCompat` |
| Min bar height | 72 pt |
| Generic constraint | `Selection: Hashable` |

---

## When to Use It

- Use `DSTabBar` for 3–5 stable top-level destinations that should remain accessible from anywhere in the app.
- Use `.count` badges for unread counts, notifications, or action-required signals.
- Use `.dot` badges for "new content" signals where a count is not meaningful.
- Use per-item `isEnabled: false` to disable destinations based on entitlement.

**Avoid** `DSTabBar` for:
- Wizard or sequential step flows (use a progress indicator)
- More than 5 destinations (consider a side menu or separate navigation layer)
- Temporary or contextual navigation that applies only within one section

---

## API and Companion Types

### DSTabBar

```swift
enum AppTab: String, Hashable {
    case home, plans, support, profile
}

@State private var selectedTab: AppTab = .home

DSTabBar(
    items: [
        DSTabBarItem(id: .home,    title: "Home",    iconName: "house",    selectedIconName: "house.fill"),
        DSTabBarItem(id: .plans,   title: "Plans",   iconName: "simcard",  selectedIconName: "simcard.fill",  badge: .count(2)),
        DSTabBarItem(id: .support, title: "Support", iconName: "message",  selectedIconName: "message.fill"),
        DSTabBarItem(id: .profile, title: "Profile", iconName: "person",   selectedIconName: "person.fill")
    ],
    selection: $selectedTab
)
```

**Initialiser parameters:**

| Parameter | Type | Default | Notes |
|---|---|---|---|
| `items` | `[DSTabBarItem<Selection>]` | required | Ordered tab items |
| `selection` | `Binding<Selection>` | required | Two-way selected tab binding |
| `configuration` | `DSTabBarConfiguration` | `DSTabBarConfiguration()` | Layout and color overrides |
| `onSelectionChanged` | `((Selection) -> Void)?` | `nil` | Optional side-effect callback |

### DSTabBarItem

```swift
DSTabBarItem(
    id: AppTab.plans,
    title: "Plans",
    iconName: "simcard",
    selectedIconName: "simcard.fill",
    badge: .count(3),
    isEnabled: true,
    accessibilityLabel: "Plans tab",
    accessibilityHint: "Shows your current and available plans",
    accessibilityIdentifier: "tab_plans"
)
```

| Property | Type | Notes |
|---|---|---|
| `id` | `Selection` | Identifies the tab uniquely |
| `title` | `String` | Label below the icon |
| `iconName` | `String` | SF Symbol name (unselected state) |
| `selectedIconName` | `String?` | SF Symbol for selected state (optional) |
| `badge` | `DSTabBarBadge` | `.none`, `.dot`, or `.count(Int)` |
| `isEnabled` | `Bool` | Default `true` |
| `accessibilityLabel` | `String?` | Overrides default label |
| `accessibilityHint` | `String?` | Describes the destination |
| `accessibilityIdentifier` | `String?` | UI testing identifier |

### DSTabBarBadge

| Value | Rendering | Accessibility |
|---|---|---|
| `.none` | No badge | Silent |
| `.dot` | Red dot | Announces "New item" |
| `.count(Int)` | Red pill with count (99+ cap) | Announces "N notifications" |

Zero counts (`count(0)`) are hidden automatically.

### DSTabBarConfiguration

Controls all layout and color aspects of the bar. All values have defaults matching the design-system spec.

```swift
DSTabBarConfiguration(
    horizontalPadding: 16,  // default: RDSToken.Spacing.medium
    topPadding: 10,
    bottomPadding: 10,
    itemSpacing: 8,         // default: RDSToken.Spacing.small
    minHeight: 72,
    iconSize: 22,
    indicatorWidth: 28,
    indicatorHeight: 4,
    showsTopDivider: true,
    showsShadow: true,
    backgroundColor: Color(RDSToken.Color.surface),
    selectedColor: RDSToken.Color.buttonPrimaryBackgroundColor,   // Rogers purple
    unselectedColor: RDSToken.Color.textSecondaryColor,
    disabledColor: RDSToken.Color.textDisabledColor,
    badgeBackgroundColor: RDSToken.Color.errorColor,              // Red
    badgeForegroundColor: .white
)
```

---

## Variants, States, and Behaviors

**Item states:**

| State | Description |
|---|---|
| Selected | Icon uses `selectedIconName`, label and indicator colored `selectedColor` |
| Unselected | Icon uses `iconName`, colored `unselectedColor` |
| Disabled | Colored `disabledColor`, tap ignored |

- An animated indicator line (28 × 4 pt by default) slides above the active icon.
- A 1 pt top divider (`dividerColor`) separates the bar from screen content.
- Optional drop shadow using system shadow defaults.
- All icons + labels scale with Dynamic Type.

---

## Accessibility Notes

- Each tab item announces its `title` (or `accessibilityLabel` override) and selected state.
- Badge `.count` announces "N notifications"; `.dot` announces "New item".
- Disabled items are marked `.not(.isEnabled)` and skipped by VoiceOver by default.
- `accessibilityIdentifier` enables UI test targeting.

---

## SwiftUI Examples

### App shell with four tabs

```swift
struct AppShell: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        VStack(spacing: 0) {
            // Screen content driven by tab selection
            Group {
                switch selectedTab {
                case .home:    HomeView()
                case .plans:   PlansView()
                case .support: SupportView()
                case .profile: ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            DSTabBar(
                items: [
                    DSTabBarItem(id: .home,    title: "Home",    iconName: "house",   selectedIconName: "house.fill"),
                    DSTabBarItem(id: .plans,   title: "Plans",   iconName: "simcard", selectedIconName: "simcard.fill", badge: .count(unreadCount)),
                    DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
                    DSTabBarItem(id: .profile, title: "Profile", iconName: "person",  selectedIconName: "person.fill")
                ],
                selection: $selectedTab
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}
```

### Embedded tab bar with callback

```swift
DSTabBar(
    items: items,
    selection: $activeTab,
    onSelectionChanged: { tab in
        analytics.trackTabSelection(tab)
    }
)
```

### Custom configuration (no shadow, narrow indicator)

```swift
DSTabBar(
    items: items,
    selection: $activeTab,
    configuration: DSTabBarConfiguration(
        showsShadow: false,
        indicatorWidth: 40,
        selectedColor: RDSToken.Color.successColor
    )
)
```

---

## UIKit Integration

### DSTabBarHostingController

```swift
let tabBarVC = DSTabBarHostingController(
    items: [
        DSTabBarItem(id: AppTab.home, title: "Home", iconName: "house", selectedIconName: "house.fill"),
        DSTabBarItem(id: AppTab.plans, title: "Plans", iconName: "simcard", selectedIconName: "simcard.fill")
    ],
    selection: AppTab.home,
    onSelectionChanged: { [weak self] tab in
        self?.switchToTab(tab)
    }
)
addChild(tabBarVC)
view.addSubview(tabBarVC.view)
// Pin to bottom safe area
tabBarVC.didMove(toParent: self)
```

Update selection programmatically:

```swift
tabBarVC.update(selection: .plans)
```

Update badge without re-creating:

```swift
var updatedItems = tabBarVC.items
updatedItems[1] = DSTabBarItem(id: .plans, title: "Plans", iconName: "simcard", badge: .count(5))
tabBarVC.update(items: updatedItems)
```

### DSTabBarView

`UIView` subclass for contexts where only a `UIView` parent is available.

```swift
let barView = DSTabBarView(items: items, selection: .home)
view.addSubview(barView)
```

---

## Screen Composition Guidance

### Where DSTabBar sits in the screen hierarchy

- Pinned to the bottom of the root view controller, above the safe area.
- Screen content occupies the space above the bar; use `.ignoresSafeArea(edges: .bottom)` on the content area and let `DSTabBar` handle its own bottom padding.
- Do not place `DSTabBar` inside individual tab content views; it belongs at the shell level.

### App shell recipe

```swift
VStack(spacing: 0) {
    DSPromoBanner(configuration: .specialOffer())
        .opacity(selectedTab == .home ? 1 : 0)  // show only on Home

    contentView(for: selectedTab)
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    DSTabBar(items: tabItems, selection: $selectedTab)
}
.ignoresSafeArea(edges: .bottom)
```

---

## Related Components

| Related Component | Relationship | When to Pair |
|---|---|---|
| `DSPageHeader` | Header of each tab's content area | Every tab destination screen |
| `DSPromoBanner` | Optional status strip above content | Home tab or offer surfaces |
| `DSButton` | CTAs within tab content | Plan selection, sign-in |
| `DSTextField` | Forms within tab content | Support, profile edit |

---

## Constraints and Caveats

- `DSTabBar` does not manage screen routing — it only manages selection state. Wire up `onSelectionChanged` or drive content from the `selection` binding.
- Five items is the practical visual limit; beyond that, icon and label sizes become too small for comfortable tapping.
- Badge counts above 99 are displayed as "99+" automatically.
- `DSTabBarConfiguration.cornerRadius` defaults to `0`; the bar is flush rectangular by design.

```swift
VStack(spacing: 0) {
    content
    Spacer(minLength: 0)
    DSTabBar(items: items, selection: $selectedTab)
}
```

## UIKit Integration

- `DSTabBarHostingController<Selection>`
- `DSTabBarView<Selection>`

## Screen Composition Guidance

- Common placement: bottom edge of an app shell.
- Pairs most often with: `DSPageHeader` or main content containers above it.
- Recommended order: top content hierarchy first, tab bar last.

## Related Components

| Related Component | Relationship | When to Pair |
| --- | --- | --- |
| `DSPageHeader` | Sets page identity above shell content | Destination landing screens |
| `DSLabel` | Supports body content above tabs | Per-tab content areas |
| `DSPromoBanner` | Optional inline messaging in tab content | Home or plans screens |

## Constraints And Caveats

- Best results come from a small, stable destination set.
- This component does not replace navigation stacks or routing architecture; it only presents the tab control.