# UIKitCompat Module

The `UIKitCompat` module provides `UIViewController` and `UIView` wrappers that embed SwiftUI design-system components into UIKit view hierarchies. It also includes `DSLabelFactory` for producing correctly attributed `UILabel` instances and `RDSButtonFactory` for a plain `UIButton` shortcut.

All UIKit wrappers follow the same two-surface pattern: a **hosting controller** for lifecycle-correct embedding inside a `UIViewController`, and a **view wrapper** for drop-in use inside cells, stack views, and other `UIView`-only contexts.

---

## Module Summary

| Field | Value |
|---|---|
| Module | `UIKitCompat` |
| Sources | `Sources/UIKitCompat/` |
| Dependencies | `Components`, `Tokens`, `UIKit`, `SwiftUI`, `Combine` |
| Purpose | Bridge SwiftUI DS components into UIKit screens |

---

## Integration Pattern

### When to use the hosting controller

Use `*HostingController` when your call site is a `UIViewController` and you can use `addChild(_:)` / `didMove(toParent:)`. This is the correct lifecycle path for trait collection propagation, dark-mode updates, and VoiceOver.

### When to use the view wrapper

Use `*View` when your call site only has access to a `UIView` parent — typically `UITableViewCell`, `UICollectionViewCell`, or a `UIStackView` that doesn't have a clear parent controller at configuration time.

---

## DSButton UIKit

### DSButtonHostingController

```swift
// Embed in viewDidLoad
let buttonVC = DSButtonHostingController(
    configuration: DSButtonConfiguration(title: "Sign in", variant: .primary),
    action: { self.handleSignIn() }
)
addChild(buttonVC)
view.addSubview(buttonVC.view)
NSLayoutConstraint.activate([
    buttonVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
    buttonVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
    buttonVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
])
buttonVC.didMove(toParent: self)

// Quick-embed helper (pins below a sibling view automatically)
let buttonVC = DSButtonHostingController.embed(
    in: self,
    below: titleLabel,
    configuration: DSButtonConfiguration(title: "Sign in"),
    action: { self.handleSignIn() }
)
```

Update without re-creating:
```swift
buttonVC.update(
    configuration: DSButtonConfiguration(title: "Retry", variant: .destructive),
    action: { retry() }
)
```

### DSButtonView

```swift
let buttonView = DSButtonView(
    configuration: DSButtonConfiguration(title: "Add to cart"),
    action: { addItem() }
)
stackView.addArrangedSubview(buttonView)
```

### RDSButtonFactory (legacy)

Plain `UIButton` with basic Rogers brand styling — for legacy screens not ready for the hosting approach:

```swift
let button = RDSButtonFactory.makePrimaryButton(
    title: "Sign in",
    target: self,
    action: #selector(handleSignIn)
)
view.addSubview(button)
```

> Note: `RDSButtonFactory` does not use `DSButtonStyle` or state management. Prefer `DSButtonHostingController` for new code.

---

## DSLabel UIKit

### DSLabelFactory

Static factory that produces correctly attributed `UILabel` instances from `DSTextStyle` + `DSTextColor`.

All labels returned:
- Use `UIFontMetrics`-scaled fonts (Dynamic Type aware).
- Apply `minimumLineHeight` / `maximumLineHeight` via `NSParagraphStyle` for pixel-correct Figma line heights.
- Apply `baselineOffset` to vertically center glyphs.
- Auto-uppercase `overline` style text.

```swift
// Generic builder — any style and color
let label = DSLabelFactory.makeLabel(
    text: "With your My Chatr credentials",
    style: RDSToken.Typography.bodyRegular,
    textColor: .primary
)

// Convenience builder — hero label (matches UILabel export snippet exactly)
let heroLabel = DSLabelFactory.makeHeroLabel(
    text: "Now you make the call\nSign in to manage your account."
)

// Convenience builder — title3 label (Figma node 5:441)
let titleLabel = DSLabelFactory.makeTitle3Label(text: "Sign in")

// Convenience builder — body label (Figma node 5:395)
let bodyLabel = DSLabelFactory.makeBodyLabel(
    text: "With your My Chatr credentials",
    numberOfLines: 0
)
```

**Why not `lineHeightMultiple`?**

The Figma export sometimes emits `lineHeightMultiple: 0.98`. This is a tool artefact. `DSLabelFactory` uses `minimumLineHeight` / `maximumLineHeight` set to the absolute value (e.g. 36 pt for `heroBody`), which is the correct UIKit approach for matching Figma absolute line heights.

### DSPageHeaderView

UIView subclass reproducing the Figma node 5:448 title + subtitle composition.

```swift
let header = DSPageHeaderView(title: "Sign in", subtitle: "With your My Chatr credentials")
stackView.addArrangedSubview(header)
```

### DSLabelView

Generic `UIHostingController` wrapper for any `DSLabel`.

```swift
let labelVC = DSLabelView(
    text: "Featured",
    style: RDSToken.Typography.overline,
    color: .secondary
)
addChild(labelVC)
view.addSubview(labelVC.view)
```

---

## DSPromoBanner UIKit

### DSPromoBannerHostingController

```swift
let bannerVC = DSPromoBannerHostingController(configuration: .specialOffer())
bannerVC.embed(in: cardView, below: nil, controller: self)

// Update content without re-creating
bannerVC.update(configuration: .warningBanner(text: "Bill overdue"))
```

`embed(in:below:insets:controller:)` pins the banner to the top of `parentView` or below a named sibling.

### DSPromoBannerView

```swift
let bannerView = DSPromoBannerView(configuration: .specialOffer())
stackView.addArrangedSubview(bannerView)
```

### DSPromoBannerFactory

Static presets for quick construction:

```swift
let bannerView = DSPromoBannerFactory.makeOfferBanner()
```

---

## DSTabBar UIKit

### DSTabBarHostingController

```swift
let tabBarVC = DSTabBarHostingController(
    items: [
        DSTabBarItem(id: AppTab.home,    title: "Home",    iconName: "house",   selectedIconName: "house.fill"),
        DSTabBarItem(id: AppTab.plans,   title: "Plans",   iconName: "simcard", selectedIconName: "simcard.fill"),
        DSTabBarItem(id: AppTab.support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
        DSTabBarItem(id: AppTab.profile, title: "Profile", iconName: "person",  selectedIconName: "person.fill")
    ],
    selection: AppTab.home,
    onSelectionChanged: { [weak self] tab in self?.switchToTab(tab) }
)
addChild(tabBarVC)
view.addSubview(tabBarVC.view)
// Pin to bottom safe area
tabBarVC.didMove(toParent: self)
```

Update selection:
```swift
tabBarVC.update(selection: .plans)
```

Update items (e.g. badge count):
```swift
tabBarVC.update(items: updatedItems)
```

### DSTabBarView

```swift
let barView = DSTabBarView(items: tabItems, selection: .home)
view.addSubview(barView)
```

---

## DSTextField UIKit

### DSTextFieldHostingController

The text field hosting controller exposes the current text value and validation result via closure callbacks — no Combine dependency required at the call site.

```swift
let fieldVC = DSTextFieldHostingController(
    configuration: .email(),
    onTextChange: { [weak self] text in
        self?.email = text
    },
    onValidationResultChange: { result in
        print("Validation:", result)
    }
)

// Quick-embed below a sibling view
DSTextFieldHostingController.embed(in: self, below: headerLabel, controller: fieldVC)
```

Inject a server-side error after an API call:
```swift
fieldVC.setExternalResult(.invalid(message: "No account found for this email."))
```

### DSTextFieldView

```swift
let fieldView = DSTextFieldView(
    configuration: .phone(),
    onTextChange: { [weak self] in self?.phone = $0 }
)
formStack.addArrangedSubview(fieldView)
```

---

## Embedding Best Practices

1. Always use `addChild` + `didMove(toParent:)` with hosting controllers — skipping either breaks trait-collection forwarding.
2. Set `hostController.view.backgroundColor = .clear` to avoid white fill over colored backgrounds.
3. Set `translatesAutoresizingMaskIntoConstraints = false` before activating Auto Layout constraints.
4. Use the `embed(in:below:...)` helpers on hosting controllers when they are available — they handle all of the above automatically.
5. `DSButtonView`, `DSPromoBannerView`, `DSTabBarView`, and `DSTextFieldView` self-manage embedding via an internal hosting controller; do **not** call `addChild` on these views.

---

## Known Gaps

- No UIKit wrapper currently exists for `DSPageHeader` as a standalone hosting controller (only `DSPageHeaderView` via `DSLabelFactory`).
- `RDSButtonFactory` does not forward `DSButtonVariant` or `DSButtonSize` — use `DSButtonHostingController` for anything beyond a simple primary button.
- `DSTextFieldView` does not currently expose `externalResult` injection; use `DSTextFieldHostingController` when server-side validation is needed.
