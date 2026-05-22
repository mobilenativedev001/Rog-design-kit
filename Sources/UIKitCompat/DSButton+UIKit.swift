// DSButton+UIKit.swift
// Rogers iOS Design System
//
// UIKit compatibility layer for DSButton.
//
// Provides two integration surfaces:
//
//   1. DSButtonHostingController — a UIHostingController<DSButton> subclass.
//      The standard, lifecycle-correct way to embed a SwiftUI DSButton inside
//      an existing UIViewController hierarchy.
//
//   2. DSButtonView — a UIView subclass that self-manages embedding.
//      Drop-in for code that only has access to a UIView parent and cannot
//      inject a child view-controller (e.g., UITableViewCell, UIStackView).
//      Call `embed(in:)` to inject properly when a parent VC IS available.
//
// Recommended usage in a UIViewController:
//
//   let buttonVC = DSButtonHostingController(
//       configuration: DSButtonConfiguration(title: "Sign in"),
//       action: { self.handleSignIn() }
//   )
//   addChild(buttonVC)
//   view.addSubview(buttonVC.view)
//   NSLayoutConstraint.activate([...])
//   buttonVC.didMove(toParent: self)
//
// Quick-embed helper:
//
//   let buttonVC = DSButtonHostingController.embed(
//       in: self,
//       below: titleLabel,
//       configuration: DSButtonConfiguration(title: "Sign in"),
//       action: { self.handleSignIn() }
//   )

import UIKit
import SwiftUI
import Components

// MARK: - DSButtonHostingController

/// A `UIHostingController` subclass that hosts a `DSButton`.
///
/// Use this as a child view-controller for proper trait-collection propagation,
/// VoiceOver, and dark-mode handling.
public final class DSButtonHostingController: UIHostingController<DSButton> {

    // MARK: Init

    /// Creates a controller hosting a `DSButton` built from `configuration`.
    ///
    /// - Parameters:
    ///   - configuration: Full button configuration.
    ///   - action:        Tap handler invoked on the main thread.
    public init(
        configuration: DSButtonConfiguration,
        action: @escaping () -> Void
    ) {
        super.init(rootView: DSButton(configuration: configuration, action: action))
        view.backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:action:) instead.")
    }

    // MARK: Configuration updates

    /// Replaces the current button configuration without re-creating the controller.
    ///
    /// Call from the main thread; SwiftUI will re-render on the next run loop pass.
    public func update(configuration: DSButtonConfiguration, action: @escaping () -> Void) {
        rootView = DSButton(configuration: configuration, action: action)
    }

    // MARK: Preferred size

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Allow the hosting controller to size itself to the SwiftUI content
        preferredContentSize = view.intrinsicContentSize
    }
}

// MARK: - DSButtonHostingController embed helper

public extension DSButtonHostingController {

    /// Embeds a `DSButtonHostingController` into `parentVC` and pins its view
    /// to `anchorView` (or the parent's safe-area if `anchorView` is `nil`).
    ///
    /// - Parameters:
    ///   - parentVC:      The view-controller to add as a child.
    ///   - anchorView:    Optional sibling view. The button is placed below it
    ///                    with 16 pt spacing inside the same superview.
    ///   - configuration: Button configuration.
    ///   - action:        Tap handler.
    /// - Returns:         The embedded `DSButtonHostingController`.
    @discardableResult
    static func embed(
        in parentVC: UIViewController,
        below anchorView: UIView? = nil,
        configuration: DSButtonConfiguration,
        action: @escaping () -> Void
    ) -> DSButtonHostingController {
        let controller = DSButtonHostingController(
            configuration: configuration,
            action: action
        )
        parentVC.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        parentVC.view.addSubview(controller.view)

        var constraints: [NSLayoutConstraint] = [
            controller.view.leadingAnchor.constraint(
                equalTo: parentVC.view.leadingAnchor, constant: 16),
            controller.view.trailingAnchor.constraint(
                equalTo: parentVC.view.trailingAnchor, constant: -16),
        ]

        if let anchor = anchorView {
            constraints.append(
                controller.view.topAnchor.constraint(
                    equalTo: anchor.bottomAnchor, constant: 16)
            )
        } else {
            constraints.append(
                controller.view.topAnchor.constraint(
                    equalTo: parentVC.view.safeAreaLayoutGuide.topAnchor, constant: 16)
            )
        }

        NSLayoutConstraint.activate(constraints)
        controller.didMove(toParent: parentVC)
        return controller
    }
}

// MARK: - DSButtonView

/// A `UIView` subclass that embeds a `DSButton` via an internal
/// `UIHostingController`.
///
/// For contexts where only a `UIView` reference is available (e.g. cells,
/// stack views). When a parent view-controller IS available prefer
/// `DSButtonHostingController` for complete lifecycle management.
public final class DSButtonView: UIView {

    // MARK: Properties

    private var hostController: UIHostingController<DSButton>

    // MARK: Init

    public init(
        configuration: DSButtonConfiguration,
        action: @escaping () -> Void
    ) {
        hostController = UIHostingController(
            rootView: DSButton(configuration: configuration, action: action)
        )
        super.init(frame: .zero)
        setupHosting()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:action:) instead.")
    }

    // MARK: Hosting setup

    private func setupHosting() {
        hostController.view.translatesAutoresizingMaskIntoConstraints = false
        hostController.view.backgroundColor = .clear
        addSubview(hostController.view)
        NSLayoutConstraint.activate([
            hostController.view.topAnchor.constraint(equalTo: topAnchor),
            hostController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: Configuration updates

    /// Updates the button without re-creating the host controller.
    public func update(configuration: DSButtonConfiguration, action: @escaping () -> Void) {
        hostController.rootView = DSButton(configuration: configuration, action: action)
    }

    // MARK: Sizing

    public override var intrinsicContentSize: CGSize {
        hostController.view.intrinsicContentSize
    }
}

// MARK: - Legacy factory extension (additive — preserves existing RDSButtonFactory)

/// Extends the existing factory with DSButton-backed convenience builders.
public extension RDSButtonFactory {

    /// Creates a `DSButtonView` preconfigured for a primary action.
    static func makeDSPrimaryButton(
        title: String,
        action: @escaping () -> Void
    ) -> DSButtonView {
        DSButtonView(
            configuration: DSButtonConfiguration(title: title, variant: .primary),
            action: action
        )
    }

    /// Creates a `DSButtonView` preconfigured for a secondary action.
    static func makeDSSecondaryButton(
        title: String,
        action: @escaping () -> Void
    ) -> DSButtonView {
        DSButtonView(
            configuration: DSButtonConfiguration(title: title, variant: .secondary),
            action: action
        )
    }

    /// Creates a `DSButtonView` preconfigured for a destructive action.
    static func makeDSDestructiveButton(
        title: String,
        action: @escaping () -> Void
    ) -> DSButtonView {
        DSButtonView(
            configuration: DSButtonConfiguration(title: title, variant: .destructive),
            action: action
        )
    }
}
