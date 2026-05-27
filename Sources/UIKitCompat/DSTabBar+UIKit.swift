// DSTabBar+UIKit.swift
// Rogers iOS Design System
//
// UIKit compatibility layer for DSTabBar.
//
// Provides:
//   • DSTabBarHostingController — UIViewController wrapper for screen containers
//   • DSTabBarView              — UIView wrapper for cells and stack views

import UIKit
import SwiftUI
import Components

// MARK: - DSTabBarHostingController

public final class DSTabBarHostingController<Selection: Hashable>: UIViewController {

    public var items: [DSTabBarItem<Selection>] {
        didSet { updateRootView() }
    }

    public var selection: Selection {
        didSet { updateRootView() }
    }

    public var configuration: DSTabBarConfiguration {
        didSet { updateRootView() }
    }

    public var onSelectionChanged: ((Selection) -> Void)? {
        didSet { updateRootView() }
    }

    private lazy var hostController = UIHostingController(rootView: makeRootView())

    public init(
        items: [DSTabBarItem<Selection>],
        selection: Selection,
        configuration: DSTabBarConfiguration = DSTabBarConfiguration(),
        onSelectionChanged: ((Selection) -> Void)? = nil
    ) {
        self.items = items
        self.selection = selection
        self.configuration = configuration
        self.onSelectionChanged = onSelectionChanged
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(items:selection:configuration:onSelectionChanged:) instead.")
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

    public func update(
        items: [DSTabBarItem<Selection>]? = nil,
        selection: Selection? = nil,
        configuration: DSTabBarConfiguration? = nil,
        onSelectionChanged: ((Selection) -> Void)? = nil
    ) {
        if let items { self.items = items }
        if let selection { self.selection = selection }
        if let configuration { self.configuration = configuration }
        if let onSelectionChanged { self.onSelectionChanged = onSelectionChanged }
        updateRootView()
    }

    private func makeRootView() -> DSTabBar<Selection> {
        DSTabBar(
            items: items,
            selection: Binding(
                get: { self.selection },
                set: { [weak self] newSelection in
                    self?.selection = newSelection
                    self?.onSelectionChanged?(newSelection)
                }
            ),
            configuration: configuration,
            onSelectionChanged: nil
        )
    }

    private func updateRootView() {
        hostController.rootView = makeRootView()
    }
}

// MARK: - DSTabBarView

public final class DSTabBarView<Selection: Hashable>: UIView {

    public var items: [DSTabBarItem<Selection>] {
        didSet { updateRootView() }
    }

    public var selection: Selection {
        didSet { updateRootView() }
    }

    public var configuration: DSTabBarConfiguration {
        didSet { updateRootView() }
    }

    public var onSelectionChanged: ((Selection) -> Void)? {
        didSet { updateRootView() }
    }

    private lazy var hostController = UIHostingController(rootView: makeRootView())

    public init(
        items: [DSTabBarItem<Selection>],
        selection: Selection,
        configuration: DSTabBarConfiguration = DSTabBarConfiguration(),
        onSelectionChanged: ((Selection) -> Void)? = nil
    ) {
        self.items = items
        self.selection = selection
        self.configuration = configuration
        self.onSelectionChanged = onSelectionChanged
        super.init(frame: .zero)
        setupHosting()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(items:selection:configuration:onSelectionChanged:) instead.")
    }

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

    public func update(
        items: [DSTabBarItem<Selection>]? = nil,
        selection: Selection? = nil,
        configuration: DSTabBarConfiguration? = nil,
        onSelectionChanged: ((Selection) -> Void)? = nil
    ) {
        if let items { self.items = items }
        if let selection { self.selection = selection }
        if let configuration { self.configuration = configuration }
        if let onSelectionChanged { self.onSelectionChanged = onSelectionChanged }
        updateRootView()
    }

    public override var intrinsicContentSize: CGSize {
        hostController.view.intrinsicContentSize
    }

    private func makeRootView() -> DSTabBar<Selection> {
        DSTabBar(
            items: items,
            selection: Binding(
                get: { self.selection },
                set: { [weak self] newSelection in
                    self?.selection = newSelection
                    self?.onSelectionChanged?(newSelection)
                }
            ),
            configuration: configuration,
            onSelectionChanged: nil
        )
    }

    private func updateRootView() {
        hostController.rootView = makeRootView()
        invalidateIntrinsicContentSize()
    }
}
