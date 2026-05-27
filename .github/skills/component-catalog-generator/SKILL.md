---
name: component-catalog-generator
description: 'Generate a full or per-component catalog for the Rogers iOS Design System. Use when you need component documentation, screen-building guidance, SwiftUI/UIKit usage examples, UI composition rules, or a focused catalog for a single component or control while creating iOS screens.'
argument-hint: 'Which component/control or screen domain should the catalog target, and where should it be written?'
---

# Component Catalog Generator

## What This Skill Produces

This skill generates markdown component catalogs that explain how to use the design-system components when building iOS UI screens.

The skill supports two output modes:

1. Full catalog mode for the whole design-system surface.
2. Single-component mode for one component or control at a time.

The catalog should help product engineers and designers answer four questions quickly:

1. What component should I use?
2. How do I configure it?
3. When should I combine it with other components in a screen?
4. Is there a UIKit integration path if the screen is not pure SwiftUI?

Default output targets:

- Full catalog: `Docs/COMPONENT_CATALOG.md`
- Single-component catalog: `Docs/Components/<ComponentName>.md`

## Use This Skill When

- You need a catalog of available components in `Sources/Components`
- You need a standalone usage guide for one component or control
- You need usage guidance for assembling full screens from the design system
- You want SwiftUI-first examples plus UIKit compatibility notes
- You want a reusable markdown artifact for onboarding, implementation, or design handoff
- You need to refresh the catalog after adding or changing components

## Required Sources

Read the code and docs before writing the catalog. Prioritize these locations:

1. `README.md` for package structure and module boundaries
2. `Docs/ARCHITECTURE.md` and `Docs/TOKENS.md` for system-level guidance
3. `Sources/Components` for public SwiftUI components, configuration types, variants, states, and previews
4. `Sources/UIKitCompat` for UIKit wrappers and embedding guidance
5. `Sources/Tokens` for typography, color, and semantic token names that clarify intended use
6. `Tests/SnapshotTests` for supported states and expected visual coverage

## Procedure

1. Identify the public components.
   Build a component list from public types in `Sources/Components`.
   Include companion configuration or variant types when they materially affect usage.

2. Resolve the requested scope.
   Decide whether the request is for:
   - the full catalog covering all public components, or
   - a focused catalog for one named component or control

   If a single component is requested, narrow all further reading and output to that component, its companion types, its UIKit bridge, its previews, and the tokens that explain its usage.

3. Extract the usage surface.
   For each in-scope component, capture:
   - primary purpose
   - public initializer or configuration entry points
   - supported variants, sizes, and states
   - accessibility or behavioral constraints
   - notable preview scenarios that demonstrate intended usage

4. Map screen-building roles.
   Classify each in-scope component by screen role, such as:
   - page structure
   - text and headings
   - form input
   - primary and secondary actions
   - navigation or tab selection
   - status, feedback, or promotional messaging

5. Add composition guidance.
   Explain how components work together in common screen sections, such as:
   - page header + text field + primary button for sign-in
   - promo banner + body text + CTA for marketing surfaces
   - tab bar + page header + content body for multi-section screens

   If the request is for a single component, focus this section on:
   - what it pairs with most often
   - where it should sit in the screen hierarchy
   - what nearby controls usually precede or follow it

6. Include implementation examples.
   Prefer compact examples that can be pasted into app code.
   Provide SwiftUI examples first.
   If a UIKit compat type exists, add a UIKit usage note or snippet.

   In single-component mode, include more than one example when the component has materially different use cases, such as primary vs secondary actions, auth vs validation, or app shell vs embedded use.

7. Connect to design tokens.
   Reference token-backed typography, spacing, and color concepts when they explain why a component should be used a certain way.
   Do not duplicate raw token dumps unless they help component selection.

8. Write the catalog in a stable structure.
   Use the output structure defined below so the catalog stays scannable and comparable across updates.

   In full-catalog mode, include the full selection matrix and all in-scope component entries.
   In single-component mode, omit unrelated component inventory and instead center the output on the requested component.

9. Validate against the source.
   Re-check every component entry against the current public API and previews.
   Remove guesses, stale names, and undocumented claims.

## Decision Rules

- If a type is a screen-level composition helper, document it as a component when it is public and reusable.
- If a type is only an implementation detail, do not list it as a standalone catalog entry.
- If a UIKit wrapper exists, document SwiftUI as the primary path and UIKit as the integration path.
- If previews demonstrate canonical layouts, treat them as stronger evidence than speculative composition advice.
- If multiple components solve adjacent needs, explain the distinction explicitly instead of leaving overlap unresolved.
- If the request names one component or control, produce a focused catalog for that single component instead of padding the result with unrelated entries.
- If a requested component has companion types such as configuration, validator, variant, size, or badge models, document them inside the same focused catalog rather than splitting them into separate standalone catalogs.
- If the requested name is ambiguous, resolve it to the nearest public component type before writing the catalog.

## Output Structure

Write the catalog as markdown using one of these structures.

### Full Catalog Structure

1. Title and short purpose statement
2. How to read the catalog
3. Component selection matrix
4. Detailed component entries
5. Common screen recipes
6. UIKit integration notes
7. Gaps or components not yet covered

### Single-Component Catalog Structure

1. Title and short purpose statement
2. Component summary
3. When to use it
4. API and companion types
5. Variants, states, and behaviors
6. SwiftUI examples
7. UIKit integration
8. Screen composition guidance
9. Related components
10. Known gaps or constraints

Use this template for each component entry in full-catalog mode:

### Component Name

- Module
- Purpose
- Use when
- Avoid when
- Key API
- Variants and states
- Accessibility notes
- SwiftUI example
- UIKit integration
- Works well with
- Screen-building notes

Use this template in single-component mode:

### Component Name

- Module
- Purpose
- Use when
- Avoid when
- Key API
- Companion types
- Variants and states
- Accessibility notes
- SwiftUI examples
- UIKit integration
- Works well with
- Screen placement guidance
- Constraints and caveats

## Component Selection Matrix

In full-catalog mode, start with a table like this:

| Component | Role | Best For | Key Variants/States | UIKit Support |
| --- | --- | --- | --- | --- |

In single-component mode, replace the full matrix with a short related-components table like this:

| Related Component | Relationship | When to Pair |
| --- | --- | --- |

## Common Screen Recipes

In full-catalog mode, include at least three recipes when the repo supports them. Favor recipes grounded in actual previews or component documentation.

Suggested recipes for this repository:

- Sign-in screen
- Marketing or offer surface
- Tab-based application shell
- Form entry screen with validation

For each recipe, include:

- goal of the screen section
- recommended component stack
- brief rationale for the order and hierarchy
- a compact example snippet

In single-component mode, include one to three focused composition recipes for that component only.
Examples:

- `DSButton` as a primary CTA in auth
- `DSTextField` in validation-heavy forms
- `DSPromoBanner` at the top of a plan card

## Quality Checks

Before finalizing the catalog, verify that:

- every documented component exists in the current repo
- public names, variants, and configuration types match the source exactly
- examples use the current API shape
- UIKit notes only mention wrappers that actually exist in `Sources/UIKitCompat`
- screen recipes are derived from current components, not hypothetical ones
- the catalog is practical for someone composing a real screen, not just reading API inventory
- single-component catalogs stay tightly scoped to the requested control and its direct companion types
- per-component output paths use a stable, component-specific filename when one is not provided explicitly

## Output Constraints

- Prefer concise guidance over exhaustive prose
- Favor actionable examples over architectural narration
- Preserve Swift and iOS terminology from the codebase
- Keep the catalog implementation-facing, not marketing-facing
- Call out missing building blocks plainly when a screen pattern cannot yet be assembled cleanly
- Do not force a full-system overview when the user asked for one component only