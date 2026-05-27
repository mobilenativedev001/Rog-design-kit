# DSLabel Component Catalog

`DSLabel` is the base text primitive for the Rogers iOS Design System. It applies semantic color roles and the shared typography scale without requiring raw token usage at call sites.

## Component Summary

- Module: `Components`
- Purpose: Render token-driven text styles for body copy, captions, labels, and utility text.
- Best fit: Supporting content inside forms, cards, promos, and screen sections.

## When To Use It

- Use `DSLabel` when you need design-system text styling but not a higher-level text composition.
- Use it for body copy, captions, overlines, status labels, and custom text blocks.
- Prefer it over raw `Text` when the text belongs to the design-system surface.

Avoid it when the screen needs a reusable heading pair or hero treatment that already exists as `DSPageHeader` or `DSHeroText`.

## API And Companion Types

```swift
DSLabel("With your My Chatr credentials")

DSLabel(
    "Featured plan",
    style: RDSToken.Typography.overline,
    color: .secondary
)
```

Companion types:

- `DSTextColor`: semantic text roles like `primary`, `secondary`, `brand`, `inverse`, `error`, `success`, `warning`, `disabled`.
- `DSTextStyle`: typography tokens sourced from `RDSToken.Typography`.

## Variants, States, And Behaviors

- Main variation comes from style and semantic color.
- Supports leading, center, and trailing alignment.
- Supports explicit line limits with `numberOfLines`.
- Uses the token type scale including `title3`, `title4`, `bodyRegular`, `bodyBold`, `caption`, `label`, and `overline`.

## Accessibility Notes

- Inherits standard SwiftUI text semantics.
- Supports multiline content without custom accessibility wiring.

## SwiftUI Examples

Body and supporting copy:

```swift
VStack(alignment: .leading, spacing: 8) {
    DSLabel("Rogers Infinite+", style: .title4, color: .primary)
    DSLabel("Unlimited Canada-wide data", style: .bodyRegular, color: .secondary)
}
```

Utility text:

```swift
DSLabel("featured", style: .overline, color: .secondary)
```

## UIKit Integration

- `DSLabelFactory` builds attributed `UILabel` instances.
- `DSLabelView` hosts SwiftUI label content inside UIKit.
- `UILabel.apply(style:textColor:)` applies token styling to an existing label.

Example:

```swift
let label = DSLabelFactory.makeBodyLabel(
    text: "With your My Chatr credentials",
    textColor: .primary
)
```

## Screen Composition Guidance

- Common placement: within cards, under headers, around fields, and inside plan summaries.
- Pairs most often with: every component in the design system.
- Use `DSLabel` for supporting content, not as the first-choice screen header.

## Related Components

| Related Component | Relationship | When to Pair |
| --- | --- | --- |
| `DSPageHeader` | Higher-level title composition | Screen starts and section intros |
| `DSHeroText` | High-emphasis alternative | Marketing and branded surfaces |
| `DSPromoBanner` | Messaging complement | Offer or status surfaces |

## Constraints And Caveats

- `DSLabel` is intentionally low-level; it does not own spacing, section hierarchy, or screen layout.
- Choosing the wrong typography token can create inconsistent hierarchy, so prefer existing preview patterns when possible.