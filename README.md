Rogers iOS Design System

Overview
- Swift Package Manager based design system
- SwiftUI-first with UIKit compatibility layer
- Modular architecture for enterprise scale
- Snapshot testing support
- Token generation support
- Demo app integration guidance

Structure (top-level directories)
- Sources/
  - Tokens/          // Design tokens (generated + source)
  - Core/            // Core utilities, styles and primitives
  - Components/      // SwiftUI components (public library)
  - UIKitCompat/     // UIKit wrappers and compatibility helpers
- 
- Demo/               // Demo iOS app (Xcode project or example files)
- Docs/               // Documentation, guides and design decisions
- Package.swift       // Swift Package manifest

Getting started
1. Open the repository in Xcode (13+).
2. The package is configured at the repo root; Xcode will recognize it as a Swift Package.
3. Create an iOS app target (Demo/App) and add this package as a dependency.

Docs
- See `Docs/` for architecture, tokens, and contribution guidelines.
