---
name: component-creator
description: 'Create or evolve reusable iOS design-system components from a Figma URL or Figma JSON using SwiftUI-first architecture, token-driven styling, UIKit compatibility, accessibility, and backward-compatible patterns.'
argument-hint: 'Provide the component name and either a Figma URL or Figma JSON, plus expected variants/states and output scope (new component or update existing).'
---

# Component Creator

## Purpose

This skill creates or updates reusable design-system components that match enterprise iOS platform standards.

The implementation must be:

- SwiftUI-first
- token-driven only
- dark-mode compatible
- accessibility compliant
- UIKit compatible
- backward compatible whenever feasible

This skill accepts component requirements from either:

- a Figma URL, or
- Figma JSON payload

## Use This Skill When

- You need a new reusable component in `Sources/Components`
- You need to extend an existing component with new variants, sizes, or states
- You need to translate Figma specs into design-system code while preserving existing architecture
- You need SwiftUI API plus UIKit compatibility wrappers

## Architecture Rules (Mandatory)

1. SwiftUI-first implementation is required.
2. UIKit compatibility is required via `Sources/UIKitCompat`.
3. Token-driven styling only:
	- no hardcoded colors
	- no hardcoded typography
	- no hardcoded spacing values
4. Dark mode support is mandatory through semantic tokens/theme behavior.
5. Accessibility is mandatory:
	- VoiceOver labels/traits/hints as needed
	- Dynamic Type behavior where applicable
	- adequate contrast through token choices
6. Reusable component architecture only:
	- no screen-specific logic
	- no feature-flow coupling
7. Preserve backward compatibility:
	- additive API changes preferred
	- avoid initializer breaks unless explicitly requested
8. Reuse existing tokens/themes/components before creating new ones.

## Required Project Analysis (Before Coding)

Analyze existing project structure first and modify only what is required.

Read these areas before implementation:

1. `README.md` for module boundaries
2. `Docs/Core.md` for design-system principles
3. `Docs/Tokens.md` and `Sources/Tokens` for token contracts
4. `Sources/Components` for current API patterns and configuration style
5. `Sources/UIKitCompat` for wrapper conventions
6. `Tests/SnapshotTests` for visual coverage style
7. Existing docs in `Docs/Components` for naming and documentation format

## Input Handling

### If Input Is a Figma URL

1. Extract component intent, variants, states, and interaction behavior.
2. Resolve design values into existing semantic tokens.
3. If direct token mapping is unclear, choose nearest existing semantic token and document the mapping rationale.

### If Input Is Figma JSON

1. Parse nodes relevant to the requested component only.
2. Build a normalized model:
	- structure/layout
	- variants
	- states
	- typography intents
	- color intents
	- spacing/radius/border/shadow intents
3. Map all visual values to existing tokens first.

## Implementation Workflow

1. Discover existing component reuse opportunities.
	- Check whether the component already exists or can be extended.
	- Prefer extension over duplication.

2. Define or evolve the public API.
	- Keep API small, explicit, and reusable.
	- Prefer value-type configuration models where existing patterns do.
	- Preserve existing call sites.

3. Implement SwiftUI component.
	- Add or update files in `Sources/Components`.
	- Use token references for color, typography, spacing, corner radius, etc.
	- Implement all required states and variants from the design input.

4. Implement UIKit compatibility.
	- Add or update thin wrappers in `Sources/UIKitCompat`.
	- Keep wrappers minimal and aligned with SwiftUI API behavior.

5. Validate dark mode and accessibility behavior.
	- Ensure semantic tokens adapt correctly.
	- Add accessibility labels/traits/actions where relevant.
	- Ensure component semantics are clear for assistive technologies.

6. Add or update tests and docs as needed.
	- Snapshot tests in `Tests/SnapshotTests` for key states.
	- Component docs in `Docs/Components/<ComponentName>.md` only when behavior/API changed materially.

7. Minimize change surface.
	- Modify only required files.
	- Avoid unrelated refactors.

## File Placement Rules

- SwiftUI component code: `Sources/Components`
- UIKit bridge code: `Sources/UIKitCompat`
- Token definitions (only if truly missing and approved): `Sources/Tokens`
- Snapshot tests: `Tests/SnapshotTests`
- Component documentation: `Docs/Components`

## Reuse and Duplication Rules

- Reuse existing tokens/themes/components before introducing anything new.
- Do not duplicate a component if an existing one can be extended safely.
- If a new token is unavoidable, add the minimal semantic token and keep naming consistent with existing token system.

### Subview Reuse (Mandatory)

When creating a new component, evaluate each subview against existing design-system controls.

- If a subview matches the style and purpose of an existing component, reuse that existing component instead of raw SwiftUI primitives.
- Prefer composition of existing controls over rebuilding equivalent UI from `Text`, `Button`, or custom ad-hoc view code.
- Only use raw SwiftUI primitives when no existing design-system component semantically fits.

Required substitutions (when style and purpose match):

- Use `DSLabel` instead of raw SwiftUI `Text`.
- Use `DSButton` instead of raw SwiftUI `Button` for CTA/action controls.

Decision rule for exceptions:

- If `DSLabel` or `DSButton` cannot satisfy the requirement, document why and add the smallest compatible extension to existing components before introducing a new primitive-based implementation.

## Backward Compatibility Rules

- Prefer additive changes:
  - new overloads
  - new configuration fields with safe defaults
  - new variants that do not alter existing defaults
- Avoid renaming/removing public APIs unless explicitly requested.
- Keep old behavior as default unless migration is explicitly required.

## Accessibility Checklist

For every component created or changed, verify:

- meaningful accessibility label/value/hint where applicable
- proper accessibility traits for interactive elements
- support for Dynamic Type where text is displayed
- touch target sizing follows platform expectations
- no state is conveyed by color alone

## Dark Mode Checklist

For every component created or changed, verify:

- all foreground/background/border states are token-based
- token choices remain legible in light and dark appearances
- disabled/error/focus/selected states remain distinguishable in both modes

## Output Expectations

When this skill is executed, produce:

1. Brief mapping summary from Figma to component API and tokens
2. Minimal required code changes only
3. SwiftUI implementation plus UIKit compatibility
4. Tests for critical visual or behavior states
5. Notes about compatibility impact (if any)

## Usage Help

Use this skill with a structured request so implementation scope is unambiguous.

### Recommended Input Format

```text
Use component-creator

Component: <ComponentName>
Input Type: <Figma URL | Figma JSON>
Input: <paste URL or JSON>

Goal: <new component | extend existing>

Required Variants:
- <primary>
- <secondary>

Required States:
- <default>
- <pressed>
- <disabled>
- <error>

Accessibility Requirements:
- VoiceOver: <labels/traits/hints>
- Dynamic Type: <expected behavior>

Compatibility Requirements:
- SwiftUI-first required
- UIKit compatibility required
- Preserve backward compatibility unless explicitly approved

Constraints:
- token-driven styling only
- no hardcoded colors/fonts/spacing
- dark mode mandatory
- reusable only, no screen-specific logic
- reuse existing tokens/themes/components first

Output Required:
- files changed
- token mapping summary
- API changes and compatibility impact
- tests added or updated
```

### Quick Examples

#### Example A: Figma URL

```text
Use component-creator

Component: DSChip
Input Type: Figma URL
Input: https://www.figma.com/file/abc123/DesignSystem?node-id=1200-450
Goal: new component

Required Variants:
- filled
- outlined

Required States:
- default
- selected
- disabled

Accessibility Requirements:
- VoiceOver label includes title and selected state
- Supports Dynamic Type up to accessibility sizes
```

#### Example B: Figma JSON

```text
Use component-creator

Component: DSInlineAlert
Input Type: Figma JSON
Input: { ...figma-json... }
Goal: extend existing

Required Variants:
- info
- warning
- error

Required States:
- default
- with action button

Compatibility Requirements:
- keep current initializer behavior as default
- add new behavior via configuration field
```

### Tips For Better Results

- Always specify both variants and states.
- Call out any must-keep existing API behavior.
- Include accessibility expectations instead of assuming defaults.
- If token mapping is strict, name preferred semantic tokens in the request.

## Refusal and Scope Rules

- Do not introduce screen-level flows or app-specific business logic.
- Do not hardcode style constants that belong to tokens.
- Do not create duplicate components when extension is feasible.
- Do not perform broad refactors beyond the requested component scope.
- Do not introduce raw `Text` or `Button` subviews when equivalent `DSLabel` or `DSButton` usage is valid for the same style and intent.

## Quality Gate Before Finalizing

Confirm all of the following:

- SwiftUI-first component exists/updated in `Sources/Components`
- UIKit compatibility exists/updated in `Sources/UIKitCompat`
- no hardcoded styling values were introduced
- dark mode behavior verified through tokens
- accessibility coverage added for meaningful semantics
- only required files were modified
- existing API usage remains valid unless explicitly changed
- subviews reuse existing controls where style/purpose match (for example, `DSLabel` over `Text`, `DSButton` over `Button`)



