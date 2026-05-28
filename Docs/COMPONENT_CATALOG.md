# Rogers iOS Design System — Component Catalog

This catalog covers every public component and module in the Rogers iOS Design System. Use it to choose the right component, understand its API and variants, and assemble screens correctly in SwiftUI first, with UIKit integration paths where the repo provides them.

---

## How to Read This Catalog

1. Start with the **Component Selection Matrix** to identify the right component for a screen role.
2. Consult the **Detailed Component Entries** for API shape, variants, states, accessibility, and composition guidance.
3. Use the **Common Screen Recipes** to wire components together for complete screen sections.
4. Check **UIKit Integration Notes** for the correct hosting approach when screens are not pure SwiftUI.
5. Per-component deep-dives live in `Docs/Components/<ComponentName>.md`.
6. Token documentation lives in `Docs/Tokens.md`. Module reference docs are in `Docs/Core.md` and `Docs/UIKitCompat.md`.

---

## Component Selection Matrix

| Component | Module | Role | Best For | Key Variants / States | UIKit Support |
|---|---|---|---|---|---|
| `DSButton` | `Components` | Primary and secondary actions | CTAs, form submission, destructive confirmation | `primary` · `secondary` · `outline` · `destructive` · `ghost`; sizes `small` / `medium` / `large`; states: normal, loading, disabled, focused | `DSButtonHostingController`, `DSButtonView` |
| `DSLabel` | `Components` | Base text primitive | Body copy, captions, overlines, status text | 13 typography tokens; 8 semantic `DSTextColor` values | `DSLabelFactory`, `DSLabelView` |
| `DSPageHeader` | `Components` | Screen title composition | Page headers on auth, settings, and content screens | Title + optional subtitle; leading / center / trailing alignment | `DSPageHeaderView` |
| `DSHeroText` | `Components` | High-emphasis marketing copy | Hero sections, splash screens, branded coloured backgrounds | `.inverse` (white) by default; `heroBody` style | `DSLabelFactory.makeHeroLabel` |
| `DSTextField` | `Components` | Single-line form input | Auth, registration, search, promo codes, structured data | `outlined` · `filled` · `underlined`; states: idle, focused, valid, invalid, disabled; secure, icon modes | `DSTextFieldHostingController`, `DSTextFieldView` |
| `DSPromoBanner` | `Components` | Promo / status strip | Offer cards, plan headers, status alerts | `offer` · `success` · `warning` · `info` · `custom`; icon optional | `DSPromoBannerHostingController`, `DSPromoBannerView` |
| `DSInfoTile` | `Components` | Promotional product tile | Campaign cards with promo banner + image + product copy | Banner icon optional; image optional placeholder; supports custom content text | `DSInfoTileHostingController`, `DSInfoTileView` |
| `DSTabBar` | `Components` | App-shell navigation | 3–5 destination persistent bottom navigation | `DSTabBarBadge`: none / dot / count; selected / unselected / disabled | `DSTabBarHostingController`, `DSTabBarView` |

---

## Detailed Component Entries

---

### DSButton

- **Module:** `Components`
- **Purpose:** Enterprise-grade, token-driven button for all tappable actions on screen. Covers primary calls-to-action through ghost in-line links with full variant, size, state, icon, loading, and accessibility surface.
- **Use when:**
  - The screen needs a primary CTA, secondary alternate action, or low-emphasis text link.
  - A loading spinner is needed to block repeat taps during async work.
  - An irreversible action requires the `.destructive` treatment.
- **Avoid when:** The control is tab navigation (`DSTabBar`), passive label text, or a custom compound interaction not shaped like a button.
- **Key API:**

```swift
// Inline
DSButton("Sign in", variant: .primary) { handleSignIn() }

// With size and loading
DSButton("Continue", variant: .primary, size: .large, isLoading: isSubmitting) {
    submit()
}

// Configuration-based
let config = DSButtonConfiguration(
    title: "Delete account",
    variant: .destructive,
    accessibilityHint: "Permanently deletes your account"
)
DSButton(configuration: config) { deleteAccount() }
```

- **Companion types:**
  - `DSButtonConfiguration` — value-type aggregate of all button properties
  - `DSButtonVariant` — `primary` · `secondary` · `outline` · `destructive` · `ghost`
  - `DSButtonSize` — `small` (44 pt) · `medium` (48 pt) · `large` (56 pt)
  - `DSButtonStyle` — `ButtonStyle` that can also be applied stand-alone on native `Button`

- **Variants and states:**

| Variant | Fill |
|---|---|
| `.primary` | Rogers brand purple `#542E91` |
| `.secondary` | Brand teal |
| `.outline` | Transparent + colored stroke |
| `.destructive` | Semantic error red |
| `.ghost` | None — text only |

States: `normal` · `pressed` · `loading` · `disabled` · `focused`

- **Accessibility notes:** Minimum 44 pt tap target. Supports `accessibilityLabel`, `accessibilityHint`, `accessibilityIdentifier`. Loading state announced via `accessibilityValue`.
- **SwiftUI example:**

```swift
VStack(spacing: 12) {
    DSButton("Sign in", variant: .primary, size: .large) { signIn() }
        .frame(maxWidth: .infinity)
    DSButton("Create account", variant: .outline) { createAccount() }
    DSButton("Forgot password?", variant: .ghost) { resetPassword() }
}
.padding(24)
```

- **UIKit integration:** `DSButtonHostingController` for `UIViewController` embedding; `DSButtonView` for `UIView`-only contexts. `RDSButtonFactory.makePrimaryButton` for legacy plain `UIButton`.
- **Works well with:** `DSPageHeader`, `DSTextField`, `DSPromoBanner`, `DSLabel`
- **Screen-building notes:** Default to `.primary` for the one main CTA per section. Use `.outline` for an alternate action alongside it. Reserve `.ghost` for tertiary recovery paths like "Forgot password?".

---

### DSLabel

- **Module:** `Components`
- **Purpose:** Token-driven text primitive that pairs `RDSToken.Typography` styles with semantic `DSTextColor` roles. The foundation for all text rendering in the design system.
- **Use when:**
  - You need any text that should stay on the token scale.
  - The use case is body copy, caption, overline, label, or status text.
  - A higher-level text component (`DSPageHeader`, `DSHeroText`) does not match the layout need.
- **Avoid when:** The layout needs a structured title+subtitle block (`DSPageHeader`) or bold marketing copy on a coloured background (`DSHeroText`).
- **Key API:**

```swift
DSLabel("With your My Chatr credentials")  // default: bodyRegular + primary

DSLabel("Sign in", style: RDSToken.Typography.title3, color: .brand)

DSLabel("MOST POPULAR", style: RDSToken.Typography.overline, color: .secondary)

DSLabel("Long description…", style: RDSToken.Typography.caption, numberOfLines: 2)
```

- **Companion types:**
  - `DSTextColor` — `primary` · `secondary` · `brand` · `inverse` · `error` · `success` · `warning` · `disabled` · `custom(Color)`
  - `DSTextStyle` — value type backing every `RDSToken.Typography` entry

- **Variants and states:** Driven entirely by `DSTextStyle` + `DSTextColor`. Notable styles: `display`, `title1–4`, `bodyLarge`, `bodyRegular`, `bodyBold`, `heroBody`, `bodySmall`, `caption`, `label`, `overline`.

- **Accessibility notes:** Inherits SwiftUI text accessibility. Supports `numberOfLines` for truncation. `overline` auto-uppercases.
- **SwiftUI example:**

```swift
VStack(alignment: .leading, spacing: 6) {
    DSLabel("RECOMMENDED", style: RDSToken.Typography.overline, color: .brand)
    DSLabel("Rogers Infinite+", style: RDSToken.Typography.title4)
    DSLabel("Unlimited · 5G · Canada-wide", color: .secondary)
    DSLabel("$65/month", style: RDSToken.Typography.bodyBold)
}
```

- **UIKit integration:** `DSLabelFactory.makeLabel(text:style:textColor:)`. Convenience builders: `makeHeroLabel`, `makeTitle3Label`, `makeBodyLabel`.
- **Works well with:** Every component that contains text.
- **Screen-building notes:** Prefer this over raw `Text` whenever the text belongs to the design-system surface.

---

### DSPageHeader

- **Module:** `Components`
- **Purpose:** Title + optional subtitle composition matching Figma node 5:448. TedNext-Bold 30/36 brand purple title, TedNext-Medium 16/24 primary subtitle, combined into a single accessible header element.
- **Use when:** The screen begins with a clear page title, optionally accompanied by a supporting descriptor line.
- **Avoid when:** The heading is inside a card or promotional container where a smaller title is more appropriate.
- **Key API:**

```swift
DSPageHeader(title: "Sign in", subtitle: "With your My Chatr credentials")
DSPageHeader(title: "Welcome")
DSPageHeader(title: "Your plan", titleColor: .inverse)  // dark background
DSPageHeader(title: "Choose a plan", alignment: .center)
```

- **Companion types:** Part of `DSLabel.swift` — uses `DSLabel` internally with `title3` and `bodyRegular` styles.

- **Variants and states:** Title-only or title + subtitle. Title color defaults to `.brand`; subtitle to `.primary`. Alignment applies to both lines.

- **Accessibility notes:** Uses `.accessibilityElement(children: .combine)` and `.accessibilityAddTraits(.isHeader)` to announce as a heading.
- **SwiftUI example:**

```swift
VStack(alignment: .leading, spacing: 0) {
    DSPromoBanner(configuration: .specialOffer())
    DSPageHeader(
        title: "Sign in",
        subtitle: "With your My Chatr credentials"
    )
    .padding(.horizontal, 24)
    .padding(.top, 24)
}
```

- **UIKit integration:** `DSPageHeaderView` UIView subclass.
- **Works well with:** `DSPromoBanner` (above), `DSTextField` (below), `DSButton` (at screen bottom).
- **Screen-building notes:** Every auth and settings screen should start with `DSPageHeader`.

---

### DSHeroText

- **Module:** `Components`
- **Purpose:** Bold multi-line text for hero sections on coloured or dark backgrounds. Matches UILabel export snippet spec: TedNext-Bold 16/36, white.
- **Use when:** High-emphasis marketing copy sits over a brand-colored block or background image.
- **Avoid when:** The text is on a white surface or the intent is body content — use `DSLabel` instead.
- **Key API:**

```swift
DSHeroText("Now you make the call\nSign in to manage your account.")
DSHeroText("Your Rogers account, all in one place.", alignment: .center)
```

- **Variants and states:** Color defaults to `.inverse` (white). Alignment is configurable. Backed by `RDSToken.Typography.heroBody`.
- **Accessibility notes:** Standard text accessibility. Add a parent `.accessibilityLabel` if the text is purely decorative.
- **SwiftUI example:**

```swift
ZStack(alignment: .bottomLeading) {
    RoundedRectangle(cornerRadius: 16)
        .fill(Color(RDSToken.Color.buttonPrimaryBackground))
        .frame(height: 200)
    DSHeroText("Now you make the call.")
        .padding(24)
}
```

- **UIKit integration:** `DSLabelFactory.makeHeroLabel(text:)`.
- **Works well with:** `DSPromoBanner`, `DSButton` (CTA below the hero), `DSLabel` (supporting copy alongside).
- **Screen-building notes:** Use sparingly — one hero block per screen section.

---

### DSTextField

- **Module:** `Components`
- **Purpose:** Single-line text input with label, placeholder, helper text, inline validation, secure entry, icon accessories, and external validation override. Matches Figma node 5:481.
- **Use when:** The screen needs any structured or free-form user text entry with design-system styling.
- **Avoid when:** Multi-line entry, read-only display, or a search bar with debounced results.
- **Key API:**

```swift
// Factory presets (recommended)
DSTextField(configuration: .email(), text: $email)
DSTextField(configuration: .password(), text: $password)
DSTextField(configuration: .phone(), text: $phone)

// Inline
DSTextField("Postal code", placeholder: "A1A 1A1",
            validators: [DSRequiredValidator(), DSPostalCodeValidator()],
            text: $postalCode)

// External validation (server error)
DSTextField(configuration: .email(), text: $email, externalResult: $serverError)
```

- **Companion types:**
  - `DSTextFieldConfiguration` — full configuration value type
  - `DSTextFieldStyleVariant` — `outlined` · `filled` · `underlined`
  - `DSTextFieldMetrics` — layout constants (corner radius 19.5 pt, border 1 pt, etc.)
  - `DSValidationResult` — `idle` · `valid` · `invalid(message:)`
  - Built-in validators: `DSRequiredValidator` · `DSMinLengthValidator` · `DSMaxLengthValidator` · `DSEmailValidator` · `DSPhoneValidator` · `DSPostalCodeValidator` · `DSRegexValidator` · `DSCustomValidator`

- **Variants and states:**

| State | Border | Background |
|---|---|---|
| Idle | Gray (`fieldBorderDefault`) | White (`fieldBackground`) |
| Focused | Purple `#6E339E` (`fieldBorderFocused`) | White |
| Invalid | Error red | White |
| Disabled | Muted | Gray-50 (`fieldBackgroundDisabled`) |

- **Accessibility notes:** Label provides VoiceOver context. Validation errors are announced. Secure-text show/hide toggle is labeled by VoiceOver.
- **SwiftUI example:**

```swift
VStack(spacing: 16) {
    DSTextField(configuration: .email(), text: $email)
    DSTextField(configuration: .password(), text: $password)
    DSButton("Sign in", variant: .primary, isDisabled: !isFormValid) { signIn() }
        .frame(maxWidth: .infinity)
}
.padding(24)
```

- **UIKit integration:** `DSTextFieldHostingController` (callbacks via closures); `DSTextFieldView` for `UIView`-only contexts.
- **Works well with:** `DSPageHeader`, `DSButton`, `DSLabel` (helper copy), `DSPromoBanner` (status above form).
- **Screen-building notes:** Use `.email()`, `.password()`, `.phone()` factories for standard fields. They pre-configure keyboard types, validators, and accessibility defaults.

---

### DSPromoBanner

- **Module:** `Components`
- **Purpose:** Full-width rectangular promotional or status strip. Matches Figma node 128:60: sharp corners, deep brand-purple background, white TedNext-Bold label, optional SF Symbol icon.
- **Use when:** A high-contrast single-line message should appear at the top of a card, section, or screen.
- **Avoid when:** The content is dismissible, multi-line, or an action-heavy container.
- **Key API:**

```swift
DSPromoBanner(configuration: .specialOffer())   // Figma node 128:60 exact
DSPromoBanner(configuration: .successBanner(text: "Plan activated"))
DSPromoBanner(configuration: .warningBanner(text: "Payment overdue"))
DSPromoBanner(configuration: .infoBanner(text: "New plans available"))

// Inline
DSPromoBanner(text: "Special Offer for you", iconName: "tag.fill", variant: .offer)
```

- **Companion types:**
  - `DSPromoBannerConfiguration` — `text`, `iconName`, `variant`, `minHeight`, paddings
  - `DSPromoBannerVariant` — `offer` · `success` · `warning` · `info` · `custom(background:foreground:)`
  - Factory presets: `.specialOffer()` · `.successBanner(text:)` · `.warningBanner(text:)` · `.infoBanner(text:)`

- **Variants and states:**

| Variant | Background | Foreground |
|---|---|---|
| `.offer` | Deep purple `#55228A` | White |
| `.success` | Semantic green | White |
| `.warning` | Semantic amber | Near-black |
| `.info` | Brand blue | White |
| `.custom` | Caller-supplied | Caller-supplied |

- **Accessibility notes:** Single static text element. Icon is decorative.
- **SwiftUI example:**

```swift
VStack(spacing: 0) {
    DSPromoBanner(configuration: .specialOffer())
    VStack(alignment: .leading, spacing: 12) {
        DSLabel("Rogers Infinite+", style: RDSToken.Typography.title4)
        DSLabel("$65/month · Unlimited · 5G", color: .secondary)
        DSButton("Select plan", variant: .primary) { select() }
    }
    .padding(16)
}
```

- **UIKit integration:** `DSPromoBannerHostingController`, `DSPromoBannerView`, `DSPromoBannerFactory`.
- **Works well with:** `DSPageHeader`, `DSButton`, `DSLabel`.
- **Screen-building notes:** Keep copy short for single-line display. Use as a strip above content, not as a standalone card.

---

### DSTabBar

- **Module:** `Components`
- **Purpose:** Typed, token-driven bottom navigation bar for app shells. Generic over `Hashable` selection. Supports animated indicator, badge overlays, top divider, and drop shadow.
- **Use when:** The app has 3–5 stable top-level destinations that should remain accessible from anywhere.
- **Avoid when:** The flow is sequential/wizard-style, has more than 5 destinations, or needs contextual navigation.
- **Key API:**

```swift
enum AppTab: String, Hashable { case home, plans, support, profile }

@State private var selectedTab: AppTab = .home

DSTabBar(
    items: [
        DSTabBarItem(id: .home,    title: "Home",    iconName: "house",   selectedIconName: "house.fill"),
        DSTabBarItem(id: .plans,   title: "Plans",   iconName: "simcard", selectedIconName: "simcard.fill", badge: .count(2)),
        DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
        DSTabBarItem(id: .profile, title: "Profile", iconName: "person",  selectedIconName: "person.fill")
    ],
    selection: $selectedTab
)
```

- **Companion types:**
  - `DSTabBarItem<Selection>` — `id`, `title`, `iconName`, `selectedIconName`, `badge`, `isEnabled`
  - `DSTabBarBadge` — `none` · `dot` · `count(Int)` (capped at "99+")
  - `DSTabBarConfiguration` — full layout and color customization

- **Variants and states:**

| State | Rendering |
|---|---|
| Selected | `selectedIconName` + indicator + `selectedColor` (brand purple) |
| Unselected | `iconName` + `unselectedColor` (secondary text) |
| Disabled | `disabledColor`, tap ignored |

- **Accessibility notes:** Announces selected state and badge value per item. Supports per-item `accessibilityLabel`, `accessibilityHint`, `accessibilityIdentifier`.
- **SwiftUI example:**

```swift
VStack(spacing: 0) {
    contentView(for: selectedTab)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    DSTabBar(items: tabItems, selection: $selectedTab)
}
.ignoresSafeArea(edges: .bottom)
```

- **UIKit integration:** `DSTabBarHostingController`, `DSTabBarView`.
- **Works well with:** `DSPageHeader` (content area), `DSPromoBanner` (Home tab banner), `DSButton` (CTAs within tab content).
- **Screen-building notes:** `DSTabBar` manages selection state only — wire `onSelectionChanged` or drive content from the binding. Place at the root shell level, not inside individual tab views.

---

## Common Screen Recipes

---

### Sign-In Screen

**Goal:** Establish identity entry with brand context, a single primary CTA, and a low-emphasis recovery path.

**Component stack:** `DSPageHeader` → `DSTextField.email()` → `DSTextField.password()` → `.primary` `DSButton` → `.ghost` `DSButton`

```swift
struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            DSPageHeader(
                title: "Sign in",
                subtitle: "With your My Chatr credentials"
            )
            .padding(.bottom, 8)

            DSTextField(configuration: .email(), text: $email)
            DSTextField(configuration: .password(), text: $password)

            DSButton("Sign in", variant: .primary, size: .large, isLoading: isLoading) {
                isLoading = true
                Task { await viewModel.signIn(email: email, password: password) }
            }
            .frame(maxWidth: .infinity)

            DSButton("Forgot password?", variant: .ghost) {
                navigateToPasswordReset()
            }
            .frame(maxWidth: .infinity)
        }
        .padding(24)
    }
}
```

---

### Marketing / Offer Surface

**Goal:** Surface a promotional message with brand impact and a clear acquisition CTA.

**Component stack:** `DSPromoBanner` → `DSLabel` title and price → `DSLabel` description → `.primary` `DSButton`

```swift
VStack(spacing: 0) {
    DSPromoBanner(configuration: .specialOffer(text: "Limited time: 3 months free"))

    VStack(alignment: .leading, spacing: 10) {
        DSLabel("MOST POPULAR", style: RDSToken.Typography.overline, color: .brand)
        DSLabel("Rogers Infinite+", style: RDSToken.Typography.title4)
        DSLabel("$55/month · Unlimited · 5G · Canada-wide", color: .secondary)

        DSButton("Get this plan", variant: .primary) { selectPlan() }
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
    }
    .padding(16)
}
.background(Color(RDSToken.Color.surface))
.cornerRadius(12)
```

---

### Tab-Based Application Shell

**Goal:** Provide persistent top-level navigation with clear destination identity and badge signals.

**Component stack:** Full-screen content `VStack` → `DSTabBar` pinned to bottom

```swift
struct AppShellView: View {
    enum AppTab: String, Hashable { case home, plans, support, profile }

    @State private var selectedTab: AppTab = .home

    private var tabItems: [DSTabBarItem<AppTab>] {[
        DSTabBarItem(id: .home,    title: "Home",    iconName: "house",   selectedIconName: "house.fill"),
        DSTabBarItem(id: .plans,   title: "Plans",   iconName: "simcard", selectedIconName: "simcard.fill", badge: .count(unreadCount)),
        DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
        DSTabBarItem(id: .profile, title: "Profile", iconName: "person",  selectedIconName: "person.fill")
    ]}

    var body: some View {
        VStack(spacing: 0) {
            tabContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            DSTabBar(items: tabItems, selection: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .home:    HomeView()
        case .plans:   PlansView()
        case .support: SupportView()
        case .profile: ProfileView()
        }
    }
}
```

---

### Form Entry Screen with Validation

**Goal:** Gather structured user input with inline validation feedback and a submit action that reflects form state.

**Component stack:** `DSPageHeader` → `DSTextField` stack with validators → disabled-until-valid `.primary` `DSButton`

```swift
struct ContactFormView: View {
    @State private var firstName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var postalCode = ""

    private var isFormValid: Bool {
        !firstName.isEmpty && !email.isEmpty && !phone.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                DSPageHeader(title: "Contact info",
                             subtitle: "So we can reach you about your service")

                DSTextField(
                    "First name",
                    placeholder: "Jane",
                    validators: [DSRequiredValidator()],
                    text: $firstName
                )
                DSTextField(configuration: .email(), text: $email)
                DSTextField(configuration: .phone(), text: $phone)
                DSTextField(
                    "Postal code",
                    validators: [DSPostalCodeValidator()],
                    text: $postalCode
                )

                DSButton("Save changes", variant: .primary, isDisabled: !isFormValid) {
                    saveContact()
                }
                .frame(maxWidth: .infinity)
            }
            .padding(24)
        }
    }
}
```

---

## UIKit Integration Notes

All UIKit wrappers follow the same two-surface pattern:

| Surface | Best For | Usage |
|---|---|---|
| `*HostingController` | Screens with a `UIViewController` parent | `addChild` + `didMove(toParent:)` lifecycle |
| `*View` | Cells, stack views, UIView-only contexts | `addSubview` with Auto Layout |

**Key guidelines:**
- Always call `addChild` + `didMove(toParent:)` with hosting controllers for correct trait-collection propagation.
- Set `hostController.view.backgroundColor = .clear` to prevent white fill on colored backgrounds.
- Use `embed(in:below:...)` helpers when available — they handle all boilerplate.
- `RDSButtonFactory.makePrimaryButton` provides a plain `UIButton` for legacy screens only; prefer `DSButtonHostingController` for new code.

**Per-component UIKit entry points:**

| Component | HostingController | UIView wrapper | Factory / Extra |
|---|---|---|---|
| `DSButton` | `DSButtonHostingController` | `DSButtonView` | `RDSButtonFactory` |
| `DSLabel` | `DSLabelView` | — | `DSLabelFactory` |
| `DSPageHeader` | — | `DSPageHeaderView` | `DSLabelFactory.makeTitle3Label` / `makeBodyLabel` |
| `DSHeroText` | — | — | `DSLabelFactory.makeHeroLabel` |
| `DSTextField` | `DSTextFieldHostingController` | `DSTextFieldView` | — |
| `DSPromoBanner` | `DSPromoBannerHostingController` | `DSPromoBannerView` | `DSPromoBannerFactory` |
| `DSTabBar` | `DSTabBarHostingController` | `DSTabBarView` | — |

Full UIKit reference: `Docs/UIKitCompat.md`.

---

## Gaps and Components Not Yet Covered

- **No multi-line text input** — `DSTextField` is single-line only. Long-form entry needs a custom `TextEditor` wrapper.
- **No list / table primitive** — Row, cell, and list container layouts are app-level responsibility.
- **No card container** — The promo banner recipe shows card-like framing, but there is no `DSCard` component.
- **No modal / sheet** — Bottom sheets, dialogs, and toasts are not yet covered.
- **No segmented control** — Section-level toggle selection is not yet in the design system.
- **No image / avatar component** — Profile and content images are assembled at app level.
- **No DSButton snapshot test** — `DSButton` has SwiftUI previews but no dedicated entry in `Tests/SnapshotTests`.
- **No motion tokens** — Components use hardcoded `easeInOut(duration: 0.2)` durations; no shared animation token is defined yet.
- Screen recipes are strongest for auth, promotional, and tab-shell patterns because those are the flows explicitly previewed or snapshot-tested in the current repo.
