# DSPageHeader Component Catalog

`DSPageHeader` is the screen-heading composition for title-first pages, pairing a large branded title with an optional subtitle.

## Component Summary

- Module: `Components`
- Purpose: Provide a reusable title-plus-subtitle composition for screen starts.
- Best fit: Sign-in, account, settings, and other page-level entry sections.

## When To Use It

- Use `DSPageHeader` at the top of a screen or section that needs a clear heading hierarchy.
- Use subtitle text when the heading needs brief context.
- Use custom colors when the header sits on a dark or branded surface.

Avoid it for dense card titles, hero copy, or lightweight inline headings.

## API And Companion Types

```swift
DSPageHeader(
    title: "Sign in",
    subtitle: "With your My Chatr credentials"
)
```

Companion types:

- `DSTextColor` for title and subtitle roles.
- `DSLabel`, which the component composes internally.

## Variants, States, And Behaviors

- Optional subtitle.
- Configurable title and subtitle colors.
- Configurable alignment.
- Token-backed typography: title uses `title3`, subtitle uses `bodyRegular`.

## Accessibility Notes

- Combines title and subtitle into one accessibility element.
- Applies the header accessibility trait.

## SwiftUI Examples

Default auth header:

```swift
DSPageHeader(
    title: "Sign in",
    subtitle: "With your My Chatr credentials"
)
```

Centered variant:

```swift
DSPageHeader(
    title: "Welcome back",
    subtitle: "Chatr wireless services",
    alignment: .center
)
```

Inverse variant on branded background:

```swift
DSPageHeader(
    title: "Your Rogers Plan",
    subtitle: "Unlimited everything",
    titleColor: .inverse,
    subtitleColor: .inverse
)
```

## UIKit Integration

- `DSPageHeaderView` provides the UIKit composition.
- `DSLabelFactory` supplies the matching title and subtitle labels.

## Screen Composition Guidance

- Common placement: top of auth, profile, account, and settings screens.
- Typical ordering: `DSPageHeader` first, then form fields or primary content blocks.
- Pairs most often with: `DSTextField`, `DSButton`, `DSLabel`.

## Related Components

| Related Component | Relationship | When to Pair |
| --- | --- | --- |
| `DSTextField` | Usually follows the header | Sign-in and account forms |
| `DSButton` | Primary action under content | Auth and settings flows |
| `DSHeroText` | Alternative headline treatment | Marketing rather than form-first screens |

## Constraints And Caveats

- This component is intentionally page-level; avoid using it for every card or sub-section.
- Subtitle copy should stay concise so the hierarchy remains clear.