// DSLabel+UIKit.swift
// Rogers iOS Design System
//
// UIKit compatibility layer for DSLabel, DSPageHeader, and DSHeroText.
//
// Provides:
//
//   1. DSLabelFactory — static methods that return configured UILabel instances
//      with correct attributed text (proper line height, kerning, font).
//      Replaces hand-written UILabel setup code like the design export snippet:
//
//        // Before (exported snippet — line height incorrectly set):
//        var view = UILabel()
//        view.font = UIFont(name: "TedNext-Bold", size: 16)
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 0.98  // ← incorrect
//        // Line height: 36 pt
//
//        // After (design-system-correct):
//        let label = DSLabelFactory.makeLabel(
//            text: "Now you make the call Sign in to manage your account.",
//            style: RDSToken.Typography.heroBody,
//            textColor: .inverse
//        )
//
//   2. DSPageHeaderView — a UIView subclass that reproduces node 5:448 in UIKit.
//
//   3. DSLabelView — generic UIView wrapper for any DSLabel via UIHostingController.

import UIKit
import SwiftUI
import Components
import Tokens

// MARK: - DSLabelFactory

/// Static factory that produces correctly attributed `UILabel` instances
/// from `DSTextStyle` + `DSTextColor` tokens.
///
/// All labels returned:
///   • use `UIFontMetrics`-scaled fonts (Dynamic Type)
///   • apply `minimumLineHeight`/`maximumLineHeight` via `NSParagraphStyle`
///     (the correct way to match absolute Figma line-height values)
///   • apply `baselineOffset` to vertically centre glyphs within the line box
///   • handle `isUppercased` styles automatically
public final class DSLabelFactory {

    private init() {}

    // MARK: - Universal label builder

    /// Returns a `UILabel` configured with the given `DSTextStyle` and colour.
    ///
    /// - Parameters:
    ///   - text:          Display string.
    ///   - style:         Typography token (e.g. `RDSToken.Typography.heroBody`).
    ///   - textColor:     Semantic colour role.
    ///   - alignment:     Paragraph alignment (default: `.natural`).
    ///   - numberOfLines: 0 = unlimited (default).
    ///   - lineBreakMode: Word wrapping by default.
    /// - Returns:         A fully configured `UILabel` with attributed text.
    public static func makeLabel(
        text: String,
        style: DSTextStyle,
        textColor: DSTextColor = .primary,
        alignment: NSTextAlignment = .natural,
        numberOfLines: Int = 0,
        lineBreakMode: NSLineBreakMode = .byWordWrapping
    ) -> UILabel {
        let label = UILabel()
        label.numberOfLines  = numberOfLines
        label.lineBreakMode  = lineBreakMode
        label.adjustsFontForContentSizeCategory = true
        label.attributedText = style.attributedString(
            text,
            textColor: textColor.uiColor,
            alignment: alignment,
            lineBreakMode: lineBreakMode
        )
        return label
    }

    // MARK: - Convenience builders

    /// Reproduces the UILabel code snippet exactly (with correct line-height):
    ///
    ///     // Original (incorrect lineHeightMultiple):
    ///     paragraphStyle.lineHeightMultiple = 0.98  // Line height: 36 pt
    ///
    ///     // Correct equivalent:
    ///     let label = DSLabelFactory.makeHeroLabel(
    ///         text: "Now you make the call Sign in to manage your account."
    ///     )
    public static func makeHeroLabel(
        text: String,
        textColor: DSTextColor = .inverse,
        alignment: NSTextAlignment = .natural
    ) -> UILabel {
        makeLabel(
            text: text,
            style: RDSToken.Typography.heroBody,
            textColor: textColor,
            alignment: alignment
        )
    }

    /// Title label — TedNext-Bold 30/36, brand purple. Matches Figma node 5:441.
    public static func makeTitle3Label(
        text: String,
        textColor: DSTextColor = .brand
    ) -> UILabel {
        makeLabel(
            text: text,
            style: RDSToken.Typography.title3,
            textColor: textColor
        )
    }

    /// Body label — TedNext-Medium 16/24, primary dark. Matches Figma node 5:395.
    public static func makeBodyLabel(
        text: String,
        textColor: DSTextColor = .primary,
        numberOfLines: Int = 0
    ) -> UILabel {
        makeLabel(
            text: text,
            style: RDSToken.Typography.bodyRegular,
            textColor: textColor,
            numberOfLines: numberOfLines
        )
    }

    /// Caption label — TedNext-Medium 12/16, secondary grey.
    public static func makeCaptionLabel(
        text: String,
        textColor: DSTextColor = .secondary
    ) -> UILabel {
        makeLabel(
            text: text,
            style: RDSToken.Typography.caption,
            textColor: textColor
        )
    }

    /// Overline label — TedNext-Bold 10/16, uppercased, letter-spaced.
    public static func makeOverlineLabel(
        text: String,
        textColor: DSTextColor = .secondary
    ) -> UILabel {
        makeLabel(
            text: text,
            style: RDSToken.Typography.overline,
            textColor: textColor
        )
    }
}

// MARK: - DSPageHeaderView

/// A `UIView` subclass that reproduces Figma node 5:448 in UIKit.
///
/// Contains a title label (TedNext-Bold 30/36 brand purple) and an optional
/// subtitle label (TedNext-Medium 16/24 primary dark), stacked vertically
/// with 4 pt spacing — exactly matching the Figma composition.
///
///     let header = DSPageHeaderView(
///         title: "Sign in",
///         subtitle: "With your My Chatr credentials"
///     )
///     view.addSubview(header)
public final class DSPageHeaderView: UIView {

    // MARK: Subviews

    public private(set) lazy var titleLabel: UILabel = {
        DSLabelFactory.makeTitle3Label(text: "")
    }()

    public private(set) lazy var subtitleLabel: UILabel = {
        DSLabelFactory.makeBodyLabel(text: "")
    }()

    private lazy var stack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        sv.axis    = .vertical
        sv.spacing = 4
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    // MARK: Init

    public init(
        title: String,
        subtitle: String? = nil,
        titleColor: DSTextColor = .brand,
        subtitleColor: DSTextColor = .primary
    ) {
        super.init(frame: .zero)
        setup()
        configure(title: title, subtitle: subtitle,
                  titleColor: titleColor, subtitleColor: subtitleColor)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(title:subtitle:) instead.")
    }

    // MARK: Layout

    private func setup() {
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    // MARK: Configuration

    /// Updates the header's content without re-creating the view hierarchy.
    public func configure(
        title: String,
        subtitle: String?,
        titleColor: DSTextColor = .brand,
        subtitleColor: DSTextColor = .primary
    ) {
        titleLabel.attributedText = RDSToken.Typography.title3
            .attributedString(title, textColor: titleColor.uiColor)

        if let subtitle = subtitle, !subtitle.isEmpty {
            subtitleLabel.attributedText = RDSToken.Typography.bodyRegular
                .attributedString(subtitle, textColor: subtitleColor.uiColor)
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }

        // Accessibility: treat title + subtitle as one logical heading.
        isAccessibilityElement = true
        accessibilityTraits    = .header
        accessibilityLabel     = subtitle.map { "\(title), \($0)" } ?? title
    }

    public override var intrinsicContentSize: CGSize {
        stack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

// MARK: - DSLabelView

/// A lightweight `UIView` that embeds any `DSLabel` configuration via
/// `UIHostingController`.  Prefer `DSLabelFactory.makeLabel` when you only
/// need a `UILabel` — use this only when the full SwiftUI rendering pipeline
/// is required (e.g. Markdown, `AttributedString` SwiftUI rendering).
public final class DSLabelView: UIView {

    private var hostController: UIHostingController<AnyView>

    public init<V: View>(content: V) {
        hostController = UIHostingController(rootView: AnyView(content))
        super.init(frame: .zero)
        setupHosting()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

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

// MARK: - UILabel convenience extension

public extension UILabel {

    /// Applies a `DSTextStyle` to this label using attributed text.
    ///
    ///     titleLabel.apply(style: RDSToken.Typography.title3, textColor: .brand)
    func apply(
        style: DSTextStyle,
        textColor: DSTextColor,
        alignment: NSTextAlignment = .natural,
        numberOfLines: Int = 0
    ) {
        self.numberOfLines  = numberOfLines
        self.lineBreakMode  = .byWordWrapping
        self.adjustsFontForContentSizeCategory = true
        self.attributedText = style.attributedString(
            text ?? "",
            textColor: textColor.uiColor,
            alignment: alignment
        )
    }
}
