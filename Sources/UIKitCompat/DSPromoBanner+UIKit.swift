// DSPromoBanner+UIKit.swift
// Rogers iOS Design System
//
// UIKit compatibility layer for DSPromoBanner.
//
// Provides:
//   DSPromoBannerHostingController — UIViewController embedding DSPromoBanner
//   DSPromoBannerView              — UIView wrapper (Auto Layout ready)
//   DSPromoBannerFactory           — static factory methods for common presets

import UIKit
import SwiftUI
import Components

// MARK: - DSPromoBannerHostingController

/// A `UIViewController` that hosts a `DSPromoBanner` SwiftUI view.
///
/// Use `embed(in:below:insets:controller:)` to pin the banner to any parent
/// view without writing boilerplate.
///
///     let vc = DSPromoBannerHostingController(
///         configuration: .specialOffer()
///     )
///     vc.embed(in: cardView, below: nil, controller: self)
public final class DSPromoBannerHostingController: UIViewController {

    // MARK: Properties

    private var configuration: DSPromoBannerConfiguration {
        didSet { updateBanner() }
    }

    private var hostController: UIHostingController<DSPromoBanner>

    // MARK: Init

    public init(configuration: DSPromoBannerConfiguration = .specialOffer()) {
        self.configuration  = configuration
        self.hostController = UIHostingController(rootView: DSPromoBanner(configuration: configuration))
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("Use init(configuration:)") }

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        addChild(hostController)
        hostController.view.backgroundColor = .clear
        hostController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostController.view)
        NSLayoutConstraint.activate([
            hostController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hostController.didMove(toParent: self)
    }

    // MARK: Public API

    /// Update the banner's content and/or variant without re-creating the view hierarchy.
    public func update(configuration: DSPromoBannerConfiguration) {
        self.configuration = configuration
    }

    // MARK: Embedding helper

    /// Embeds the hosting controller into `parentView` and pins it below `siblingView`
    /// (or to the top of `parentView` if `siblingView` is `nil`).
    ///
    /// - Parameters:
    ///   - parentView:    The UIView to add the banner into.
    ///   - siblingView:   Optional view whose bottom anchor the banner should be placed below.
    ///   - insets:        Extra insets (default: `.zero`).
    ///   - controller:    The parent `UIViewController` (required to manage child VC lifecycle).
    /// - Returns:         The activated bottom constraint so callers can adjust it later.
    @discardableResult
    public static func embed(
        in parentView: UIView,
        below siblingView: UIView?,
        insets: UIEdgeInsets = .zero,
        controller: UIViewController,
        configuration: DSPromoBannerConfiguration = .specialOffer()
    ) -> UIView {
        let vc = DSPromoBannerHostingController(configuration: configuration)
        controller.addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(vc.view)

        let topAnchor: NSLayoutYAxisAnchor = siblingView.map { $0.bottomAnchor } ?? parentView.topAnchor
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            vc.view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: insets.left),
            vc.view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -insets.right),
        ])
        vc.didMove(toParent: controller)
        return vc.view
    }

    // MARK: Private

    private func updateBanner() {
        hostController.rootView = DSPromoBanner(configuration: configuration)
    }
}

// MARK: - DSPromoBannerView

/// A `UIView` wrapper around `DSPromoBanner` that is fully Auto Layout compatible.
///
/// Prefer this over `DSPromoBannerHostingController` when you need a plain `UIView`
/// (e.g. inside a `UITableViewCell` or `UICollectionViewCell`).
///
///     let bannerView = DSPromoBannerView(configuration: .specialOffer())
///     cell.contentView.addSubview(bannerView)
///     // pin with Auto Layout…
public final class DSPromoBannerView: UIView {

    // MARK: Properties

    private var hostController: UIHostingController<DSPromoBanner>

    public var configuration: DSPromoBannerConfiguration {
        didSet {
            hostController.rootView = DSPromoBanner(configuration: configuration)
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: Init

    public init(configuration: DSPromoBannerConfiguration = .specialOffer()) {
        self.configuration  = configuration
        self.hostController = UIHostingController(rootView: DSPromoBanner(configuration: configuration))
        super.init(frame: .zero)
        setupHosting()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("Use init(configuration:)") }

    // MARK: Layout

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

    public override var intrinsicContentSize: CGSize {
        hostController.view.intrinsicContentSize
    }
}

// MARK: - DSPromoBannerFactory

/// Convenience factory methods for the most common `DSPromoBanner` UIView instances.
///
///     let banner = DSPromoBannerFactory.makeOfferBanner(
///         text: "Special Offer for you"
///     )
///     stackView.addArrangedSubview(banner)
public final class DSPromoBannerFactory {

    private init() {}

    // MARK: Presets

    /// Figma node 128:60 — offer banner with tag icon, deep purple background.
    public static func makeOfferBanner(
        text: String = "Special Offer for you"
    ) -> DSPromoBannerView {
        DSPromoBannerView(configuration: .specialOffer(text: text))
    }

    /// Success banner — green background, checkmark icon.
    public static func makeSuccessBanner(text: String) -> DSPromoBannerView {
        DSPromoBannerView(configuration: .successBanner(text: text))
    }

    /// Warning banner — amber background, triangle icon.
    public static func makeWarningBanner(text: String) -> DSPromoBannerView {
        DSPromoBannerView(configuration: .warningBanner(text: text))
    }

    /// Info banner — brand blue background, info icon.
    public static func makeInfoBanner(text: String) -> DSPromoBannerView {
        DSPromoBannerView(configuration: .infoBanner(text: text))
    }

    /// A banner without any icon.
    public static func makeTextOnlyBanner(
        text: String,
        variant: DSPromoBannerVariant = .offer
    ) -> DSPromoBannerView {
        DSPromoBannerView(configuration: DSPromoBannerConfiguration(
            text: text,
            iconName: nil,
            variant: variant
        ))
    }
}
