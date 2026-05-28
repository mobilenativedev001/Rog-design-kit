import UIKit
import SwiftUI
import Components

// MARK: - DSInfoTileHostingController

/// UIKit hosting controller for `DSInfoTile`.
public final class DSInfoTileHostingController: UIViewController {
    private var configuration: DSInfoTileConfiguration {
        didSet { updateTile() }
    }

    private var hostController: UIHostingController<DSInfoTile>

    public init(configuration: DSInfoTileConfiguration) {
        self.configuration = configuration
        self.hostController = UIHostingController(rootView: DSInfoTile(configuration: configuration))
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:)")
    }

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

    public func update(configuration: DSInfoTileConfiguration) {
        self.configuration = configuration
    }

    private func updateTile() {
        hostController.rootView = DSInfoTile(configuration: configuration)
    }
}

// MARK: - DSInfoTileView

/// UIView wrapper for `DSInfoTile` for use in UIKit layouts.
public final class DSInfoTileView: UIView {
    private var hostController: UIHostingController<DSInfoTile>

    public var configuration: DSInfoTileConfiguration {
        didSet {
            hostController.rootView = DSInfoTile(configuration: configuration)
            invalidateIntrinsicContentSize()
        }
    }

    public init(configuration: DSInfoTileConfiguration) {
        self.configuration = configuration
        self.hostController = UIHostingController(rootView: DSInfoTile(configuration: configuration))
        super.init(frame: .zero)
        setupHosting()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:)")
    }

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

// MARK: - DSInfoTileFactory

public enum DSInfoTileFactory {
    /// Figma-aligned special offer tile preset.
    public static func makeSpecialOfferTile(
        badgeText: String = "Special Offer for you",
        brandText: String = "Apple",
        titleText: String = "iPhone 17 Pro Max",
        descriptionText: String = "Save up to $1,000 on any iphone when you trade in your eligible device",
        secondaryButtonTitle: String? = nil,
        image: UIImage? = nil
    ) -> DSInfoTileView {
        let swiftUIImage = image.map { Image(uiImage: $0) }
        return DSInfoTileView(
            configuration: DSInfoTileConfiguration.specialOffer(
                badgeText: badgeText,
                brandText: brandText,
                titleText: titleText,
                descriptionText: descriptionText,
                secondaryButtonTitle: secondaryButtonTitle,
                image: swiftUIImage
            )
        )
    }
}