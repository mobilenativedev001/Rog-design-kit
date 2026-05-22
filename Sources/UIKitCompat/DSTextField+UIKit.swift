// DSTextField+UIKit.swift
// Rogers iOS Design System
//
// UIKit compatibility layer for DSTextField.
//
// Provides two integration surfaces (mirroring the DSButton UIKit pattern):
//
//   1. DSTextFieldHostingController — a UIHostingController<_DSTextFieldWrapper>
//      subclass. Lifecycle-correct for embedding inside a UIViewController hierarchy.
//      Exposes text and validation result as observable Combine publishers.
//
//   2. DSTextFieldView — a UIView subclass for contexts where only a UIView
//      parent is available (UITableViewCell, UIStackView, etc.).
//
// Recommended pattern in a UIViewController:
//
//   private var emailText = ""
//
//   override func viewDidLoad() {
//       super.viewDidLoad()
//       let fieldVC = DSTextFieldHostingController(
//           configuration: .email(),
//           onTextChange: { [weak self] in self?.emailText = $0 }
//       )
//       DSTextFieldHostingController.embed(in: self, below: headerLabel, controller: fieldVC)
//   }

import UIKit
import SwiftUI
import Combine
import Components

// MARK: - Internal SwiftUI wrapper for UIKit embedding

/// Thin SwiftUI view that owns `@State` bindings and forwards changes
/// to UIKit via closures (avoiding Combine or ObservableObject overhead).
private struct _DSTextFieldWrapper: View {

    let configuration: DSTextFieldConfiguration
    let onTextChange:             ((String) -> Void)?
    let onValidationResultChange: ((DSValidationResult) -> Void)?
    let onEditingChanged:         ((Bool) -> Void)?

    @State private var text:           String             = ""
    @State private var externalResult: DSValidationResult = .idle

    var body: some View {
        DSTextField(
            configuration: configuration,
            text: $text,
            externalResult: $externalResult
        )
        .onChange(of: text)           { onTextChange?($0) }
        .onChange(of: externalResult) { onValidationResultChange?($0) }
        // Re-expose focused state if needed via onEditingChanged (future hook)
    }

    /// Programmatically inject an external validation result (e.g. server error).
    mutating func setExternalResult(_ result: DSValidationResult) {
        externalResult = result
    }
}

// MARK: - DSTextFieldHostingController

/// A `UIHostingController` subclass that hosts a `DSTextField`.
///
/// Exposes the current text value and validation result via closure callbacks
/// so UIKit controllers can react without importing Combine.
public final class DSTextFieldHostingController: UIViewController {

    // MARK: Properties

    private var configuration: DSTextFieldConfiguration
    private let onTextChange:             ((String) -> Void)?
    private let onValidationResultChange: ((DSValidationResult) -> Void)?
    private let onEditingChanged:         ((Bool) -> Void)?

    private var hostingController: UIHostingController<_DSTextFieldWrapper>?

    // MARK: Init

    /// Creates a controller hosting a `DSTextField`.
    ///
    /// - Parameters:
    ///   - configuration:           Field configuration (use `.email()`, `.password()`, etc.).
    ///   - onTextChange:            Called on every keystroke with the updated text.
    ///   - onValidationResultChange: Called when the validation result changes.
    ///   - onEditingChanged:        Called when focus enters (`true`) or leaves (`false`).
    public init(
        configuration: DSTextFieldConfiguration,
        onTextChange:             ((String) -> Void)? = nil,
        onValidationResultChange: ((DSValidationResult) -> Void)? = nil,
        onEditingChanged:         ((Bool) -> Void)? = nil
    ) {
        self.configuration             = configuration
        self.onTextChange              = onTextChange
        self.onValidationResultChange  = onValidationResultChange
        self.onEditingChanged          = onEditingChanged
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:onTextChange:) instead.")
    }

    // MARK: View lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        let wrapper = _DSTextFieldWrapper(
            configuration: configuration,
            onTextChange: onTextChange,
            onValidationResultChange: onValidationResultChange,
            onEditingChanged: onEditingChanged
        )
        let host = UIHostingController(rootView: wrapper)
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(host)
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        host.didMove(toParent: self)
        hostingController = host
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        preferredContentSize = view.systemLayoutSizeFitting(
            CGSize(width: view.bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }

    // MARK: Configuration update

    /// Replaces the configuration and re-renders the SwiftUI view.
    public func update(configuration: DSTextFieldConfiguration) {
        self.configuration = configuration
        hostingController?.rootView = _DSTextFieldWrapper(
            configuration: configuration,
            onTextChange: onTextChange,
            onValidationResultChange: onValidationResultChange,
            onEditingChanged: onEditingChanged
        )
    }
}

// MARK: - Embed helper

public extension DSTextFieldHostingController {

    /// Embeds `controller` as a child of `parentVC` and pins it below `anchorView`
    /// (or the safe-area top when `anchorView` is `nil`).
    static func embed(
        in parentVC: UIViewController,
        below anchorView: UIView? = nil,
        insets: UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16),
        controller: DSTextFieldHostingController
    ) {
        parentVC.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        parentVC.view.addSubview(controller.view)

        var constraints: [NSLayoutConstraint] = [
            controller.view.leadingAnchor.constraint(
                equalTo: parentVC.view.leadingAnchor, constant: insets.left),
            controller.view.trailingAnchor.constraint(
                equalTo: parentVC.view.trailingAnchor, constant: -insets.right),
        ]

        if let anchor = anchorView {
            constraints.append(
                controller.view.topAnchor.constraint(
                    equalTo: anchor.bottomAnchor, constant: insets.top)
            )
        } else {
            constraints.append(
                controller.view.topAnchor.constraint(
                    equalTo: parentVC.view.safeAreaLayoutGuide.topAnchor,
                    constant: insets.top)
            )
        }

        NSLayoutConstraint.activate(constraints)
        controller.didMove(toParent: parentVC)
    }
}

// MARK: - DSTextFieldView

/// A `UIView` subclass wrapping `DSTextField` for use in UIKit view hierarchies
/// that don't have a parent view-controller readily available.
///
/// For full lifecycle correctness, use `DSTextFieldHostingController` instead
/// and call `embed(in:below:controller:)`.
public final class DSTextFieldView: UIView {

    // MARK: Properties

    private var hostController: UIHostingController<_DSTextFieldWrapper>

    // MARK: Init

    public init(
        configuration: DSTextFieldConfiguration,
        onTextChange:             ((String) -> Void)? = nil,
        onValidationResultChange: ((DSValidationResult) -> Void)? = nil
    ) {
        let wrapper = _DSTextFieldWrapper(
            configuration: configuration,
            onTextChange: onTextChange,
            onValidationResultChange: onValidationResultChange,
            onEditingChanged: nil
        )
        hostController = UIHostingController(rootView: wrapper)
        super.init(frame: .zero)
        setupHosting()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:onTextChange:) instead.")
    }

    // MARK: Hosting setup

    private func setupHosting() {
        hostController.view.backgroundColor = .clear
        hostController.view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hostController.view)
        NSLayoutConstraint.activate([
            hostController.view.topAnchor.constraint(equalTo: topAnchor),
            hostController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostController.view.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: Configuration update

    public func update(
        configuration: DSTextFieldConfiguration,
        onTextChange:             ((String) -> Void)? = nil,
        onValidationResultChange: ((DSValidationResult) -> Void)? = nil
    ) {
        hostController.rootView = _DSTextFieldWrapper(
            configuration: configuration,
            onTextChange: onTextChange,
            onValidationResultChange: onValidationResultChange,
            onEditingChanged: nil
        )
    }

    // MARK: Sizing

    public override var intrinsicContentSize: CGSize {
        hostController.view.intrinsicContentSize
    }
}
