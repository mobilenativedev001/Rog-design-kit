# DSTabBar Component Catalog

`DSTabBar` is the typed, token-driven bottom navigation control for app shells and embedded multi-destination flows.

## Component Summary

- Module: `Components`
- Purpose: Provide persistent destination switching with consistent icon, label, badge, and accessibility behavior.
- Best fit: App shells with a small set of top-level destinations.

## When To Use It

- Use `DSTabBar` for 3-5 stable destinations that should remain available across the experience.
- Use badges for lightweight status signals such as unread counts.

Avoid it for wizard steps, large destination sets, or hierarchical navigation.

## API And Companion Types

```swift
enum AppTab: String, Hashable {
    case home, plans, support, profile
}

@State private var selectedTab: AppTab = .home

DSTabBar(
    items: [
        DSTabBarItem(id: .home, title: "Home", iconName: "house", selectedIconName: "house.fill"),
        DSTabBarItem(id: .plans, title: "Plans", iconName: "simcard", selectedIconName: "simcard.fill", badge: .count(2)),
        DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
        DSTabBarItem(id: .profile, title: "Profile", iconName: "person", selectedIconName: "person.fill")
    ],
    selection: $selectedTab
)
```

Companion types:

- `DSTabBarItem<Selection>`
- `DSTabBarBadge`: `none`, `dot`, `count(Int)`
- `DSTabBarConfiguration`

## Variants, States, And Behaviors

- Item states: selected, unselected, disabled.
- Badge states: none, dot, count.
- Uses selected and unselected icon names when provided.
- Supports custom configuration for padding, indicator, divider, colors, and shadow.

## Accessibility Notes

- Announces selected state.
- Announces badge count or dot presence.
- Supports per-item label, hint, and identifier overrides.

## SwiftUI Examples

Basic shell:

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