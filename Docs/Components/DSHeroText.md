# DSHeroText Component Catalog

`DSHeroText` is the high-emphasis text treatment for branded or dark promotional surfaces.

## Component Summary

- Module: `Components`
- Purpose: Render bold multiline marketing or hero copy using the design-system hero text token.
- Best fit: Splash surfaces, campaign cards, and large branded containers.

## When To Use It

- Use `DSHeroText` on purple, dark, or image-backed surfaces where standard body styles are too quiet.
- Use it for short marketing statements or strong value propositions.

Avoid it for standard form instructions, long paragraphs, or dense information layouts.

## API And Companion Types

```swift
DSHeroText("Now you make the call\nSign in to manage your account.")
```

Companion types:

- `DSTextColor` for inverse or custom text color.
- `RDSToken.Typography.heroBody` for the 16/36 hero style.

## Variants, States, And Behaviors

- Default color is `.inverse`.
- Supports alignment changes.
- Multiline by design.
- Uses the hero text line-height treatment rather than standard body rhythm.

## Accessibility Notes

- Inherits text semantics.
- Best when copy remains short and scannable.

## SwiftUI Examples

On a branded hero block:

```swift
ZStack(alignment: .bottomLeading) {
    RoundedRectangle(cornerRadius: 16)
        .fill(Color(RDSToken.Color.buttonPrimaryBackground))
        .frame(height: 200)

    DSHeroText("Unlimited Canada-wide data.")
        .padding(24)
}
```

## UIKit Integration

- `DSLabelFactory.makeHeroLabel` creates the matching UIKit label.
- `DSLabelView` can host the SwiftUI hero text when needed.

## Screen Composition Guidance

- Common placement: top half of hero cards, splash banners, or promotional modules.
- Pairs most often with: `DSPromoBanner`, `DSButton`, `DSLabel` supporting copy.
- Recommended order: hero copy first, then supporting text, then CTA.

## Related Components

| Related Component | Relationship | When to Pair |
| --- | --- | --- |
| `DSPromoBanner` | Adds short offer strip above or beside hero | Campaign and offer surfaces |
| `DSButton` | CTA below hero message | Promotional landing sections |
| `DSLabel` | Supporting copy under hero | Extended explanation |

## Constraints And Caveats

- This is not a general page-heading replacement.
- Use it only where the surrounding visual surface supports a hero treatment.