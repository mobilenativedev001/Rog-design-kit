# Core Module

The `Core` module provides foundational utilities and app-lifecycle hooks that the rest of the Rogers iOS Design System depends on. It is intentionally minimal — it does not contain UI components or tokens.

---

## Module Summary

| Field | Value |
|---|---|
| Module | `Core` |
| Source | `Sources/Core/Core.swift` |
| Dependencies | `Foundation`, `UIKit` |
| Purpose | Font registration hook and future system-level primitives |

---

## Public API

### RDSCore

```swift
public struct RDSCore {
    public static func registerFontsIfNeeded()
}
```

#### `registerFontsIfNeeded()`

Registers the custom TedNext typefaces used by `RDSToken.Typography` so they are available to both UIKit and SwiftUI at render time.

**When to call it:**

Call once as early as possible in the app lifecycle, before any design-system component renders:

```swift
// AppDelegate
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    RDSCore.registerFontsIfNeeded()
    return true
}
```

```swift
// SwiftUI App entry point
@main
struct MyApp: App {
    init() {
        RDSCore.registerFontsIfNeeded()
    }
    var body: some Scene { ... }
}
```

**What happens if you skip it:**

`RDSToken.Typography` tokens fall back to `UIFont.systemFont` at the equivalent weight (bold / medium). The layout and spacing remain correct but the branded TedNext typeface will not appear.

---

## Designed Extension Points

The `Core` module is the correct location for future cross-cutting system primitives such as:

- Trait-collection observers for theme switching
- Environment value definitions shared across the module graph
- Custom font loading utilities
- Analytics or logging entry points that the design system needs to call (behind a protocol)

Do not add component-specific logic here. Anything tied to a single component belongs in `Sources/Components`.

---

## Dependencies

`Core` has no dependency on `Components` or `Tokens`. It sits at the base of the module graph and may be imported safely by any other module without introducing cycles.

```
App
 └── Components (imports Core, Tokens)
 └── UIKitCompat (imports Components, Tokens)
 └── Tokens (imports Core)
 └── Core (no DS imports)
```
