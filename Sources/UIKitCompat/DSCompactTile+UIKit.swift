import UIKit
import SwiftUI
import Components

// MARK: - DSCompactTileHostingController

/// UIKit hosting controller for `DSCompactTile`.
public final class DSCompactTileHostingController: UIViewController {
    private var configuration: DSCompactTileConfiguration {
        didSet { updateTile() }
    }
    private let onActionTap: (() -> Void)?
    private var hostController: UIHostingController<DSCompactTile>

    public init(
        configuration: DSCompactTileConfiguration,
        onActionTap: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onActionTap = onActionTap
        self.hostController = UIHostingController(
            rootView: DSCompactTile(configuration: configuration, onActionTap: onActionTap)
        )
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:onActionTap:)")
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

    public func update(configuration: DSCompactTileConfiguration) {
        self.configuration = configuration
    }

    private func updateTile() {
        hostController.rootView = DSCompactTile(configuration: configuration, onActionTap: onActionTap)
    }
}

// MARK: - DSCompactTileView

/// UIView wrapper for `DSCompactTile` for use inside UIKit-only layouts.
public final class DSCompactTileView: UIView {
    private var hostController: UIHostingController<DSCompactTile>

    public var configuration: DSCompactTileConfiguration {
        didSet {
            hostController.rootView = DSCompactTile(configuration: configuration, onActionTap: onActionTap)
            invalidateIntrinsicContentSize()
        }
    }

    private let onActionTap: (() -> Void)?

    public init(
        configuration: DSCompactTileConfiguration,
        onActionTap: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onActionTap = onActionTap
        self.hostController = UIHostingController(
            rootView: DSCompactTile(configuration: configuration, onActionTap: onActionTap)
        )
        super.init(frame: .zero)
        setupHosting()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(configuration:onActionTap:)")
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

// MARK: - DSCompactTileFactory

public enum DSCompactTileFactory {
    /// Figma-aligned preset.
    public static func makeDataUsageTile(
        title: String = "Data Usage",
        valueText: String = "63%",
        detailText: String = "12.6 GB of 20 GB is used",
        progress: Double = 0.63,
        onActionTap: (() -> Void)? = nil
    ) -> DSCompactTileView {
        DSCompactTileView(
            configuration: .dataUsage(
                title: title,
                valueText: valueText,
                detailText: detailText,
                progress: progress
            ),
            onActionTap: onActionTap
        )
    }
}
