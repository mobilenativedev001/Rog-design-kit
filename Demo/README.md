Demo App

This folder contains example files to help you create a demo iOS app that consumes the design system.

Recommended workflow
1. Open Xcode and create a new iOS app target (SwiftUI App lifecycle).
2. In the project settings, add the repository as a Swift Package dependency (File > Swift Packages > Add Package Dependency), pointing to this repo (local path is fine when developing).
3. Create an App target that imports `Components` (and `UIKitCompat` if you need UIKit shims).

Example SwiftUI App file is included for quick copy/paste: `DemoApp.swift`.
