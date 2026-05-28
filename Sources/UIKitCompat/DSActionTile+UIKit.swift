// DSActionTile+UIKit.swift
// Rogers iOS Design System
//
// UIKit compatibility layer for DSActionTile.
//
// Provides two integration surfaces:
//
//   1. DSActionTileHostingController — a UIHostingController<DSActionTile> subclass.
//      The standard, lifecycle-correct way to embed a SwiftUI DSActionTile inside
//      an existing UIViewController hierarchy.
//
//   2. DSActionTileView — a UIView subclass that self-manages embedding.
//      Drop-in for code that only has access to a UIView parent and cannot
//      inject a child view-controller (e.g., UITableViewCell, UIStackView).
//
// Recommended usage in a UIViewController:
//
//   let tileVC = DSActionTileHostingController(
//       configuration: DSActionTileConfiguration(
//           icon: UIImage(systemName: "airplane")!.toSwiftUIImage(),
//           title: "Roaming",
//           status: "Not Active",
//           statusType: .inactive,
//           buttonTitle: "Activate now"
//       ),
//       action: { self.handleActivation() }
//   )
//   addChild(tileVC)
//   view.addSubview(tileVC.view)
//   NSLayoutConstraint.activate([...])
//   tileVC.didMove(toParent: self)

import UIKit
import SwiftUI
import Components

// MARK: - DSActionTileHostingController

/// A `UIHostingController` subclass that hosts a `DSActionTile`.
///
/// Use this as a child view-controller for proper trait-collection propagation,
/// VoiceOver, and dark-mode handling.
public final class DSActionTileHostingController: UIHostingController<DSActionTile> {
    
    // MARK: Init
    
    /// Creates a controller hosting a `DSActionTile` built from `configuration`.
    ///
    /// - Parameters:
    ///   - configuration: Full tile configuration.
    ///   - action:        Tap handler invoked when the button is tapped (only relevant if `buttonTitle` is non-nil).
    public init(
        configuration: DSActionTileConfiguration,
        action: (() -> Void)? = nil
    ) {
        super.init(rootView: DSActionTile(configuration: configuration, action: action))
        view.backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:action:) instead.")
    }
    
    // MARK: Configuration updates
    
    /// Replaces the current tile configuration without re-creating the controller.
    ///
    /// Call from the main thread; SwiftUI will re-render on the next run loop pass.
    public func update(configuration: DSActionTileConfiguration, action: (() -> Void)? = nil) {
        rootView = DSActionTile(configuration: configuration, action: action)
    }
    
    // MARK: Preferred size
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Allow the hosting controller to size itself to the SwiftUI content
        preferredContentSize = view.intrinsicContentSize
    }
}

// MARK: - DSActionTileHostingController embed helper

public extension DSActionTileHostingController {
    
    /// Embeds a `DSActionTileHostingController` into `parentVC` and pins its view
    /// to the parent's safe-area with default layout.
    ///
    /// - Parameters:
    ///   - parentVC:      The view-controller to add as a child.
    ///   - configuration: Tile configuration.
    ///   - action:        Optional tap handler.
    /// - Returns:         The embedded `DSActionTileHostingController`.
    @discardableResult
    static func embed(
        in parentVC: UIViewController,
        configuration: DSActionTileConfiguration,
        action: (() -> Void)? = nil
    ) -> DSActionTileHostingController {
        let tileVC = DSActionTileHostingController(configuration: configuration, action: action)
        parentVC.addChild(tileVC)
        parentVC.view.addSubview(tileVC.view)
        tileVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tileVC.view.leadingAnchor.constraint(equalTo: parentVC.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tileVC.view.trailingAnchor.constraint(equalTo: parentVC.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tileVC.view.topAnchor.constraint(equalTo: parentVC.view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
        tileVC.didMove(toParent: parentVC)
        return tileVC
    }
}

// MARK: - DSActionTileView

/// A `UIView` subclass that self-manages a `DSActionTile` embedding.
///
/// Use this for code that does not have access to a parent view-controller
/// (e.g., UITableViewCell subviews, UIStackView children).
///
/// When a parent VC is available, call `embed(in:)` for proper lifecycle
/// integration; otherwise the tile will still render but may not receive
/// trait-collection updates correctly.
public final class DSActionTileView: UIView {
    
    // MARK: Properties
    
    private let hostingController: DSActionTileHostingController
    
    /// The current tile configuration.
    public var configuration: DSActionTileConfiguration {
        didSet { hostingController.update(configuration: configuration, action: action) }
    }
    
    /// The action closure invoked when the tile button is tapped.
    public var action: (() -> Void)? {
        didSet { hostingController.update(configuration: configuration, action: action) }
    }
    
    // MARK: Init
    
    /// Creates a `DSActionTileView` with the specified configuration.
    ///
    /// - Parameters:
    ///   - configuration: Tile configuration.
    ///   - action:        Optional tap handler.
    public init(
        configuration: DSActionTileConfiguration,
        action: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.action = action
        self.hostingController = DSActionTileHostingController(configuration: configuration, action: action)
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:action:) instead.")
    }
    
    // MARK: Setup
    
    private func setupView() {
        addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: Embedding
    
    /// Properly embeds the tile's hosting controller into a parent view-controller.
    ///
    /// Call this when adding the tile view to a view-controller hierarchy to ensure
    /// trait-collection updates, dark-mode switching, and accessibility work correctly.
    ///
    /// - Parameter parentVC: The view-controller that owns the parent view hierarchy.
    public func embed(in parentVC: UIViewController) {
        parentVC.addChild(hostingController)
        hostingController.didMove(toParent: parentVC)
    }
    
    // MARK: Intrinsic size
    
    public override var intrinsicContentSize: CGSize {
        hostingController.view.intrinsicContentSize
    }
}

// MARK: - UIImage to SwiftUI Image helper

public extension UIImage {
    /// Converts a `UIImage` to a SwiftUI `Image`.
    func toSwiftUIImage() -> Image {
        Image(uiImage: self)
    }
}
