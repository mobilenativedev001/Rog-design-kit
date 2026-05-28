import SwiftUI
import Tokens

// MARK: - DSInfoTileConfiguration

/// Configuration model for `DSInfoTile`.
public struct DSInfoTileConfiguration {
    public var badgeText: String
    public var badgeIconSystemName: String?
    public var brandText: String
    public var titleText: String
    public var descriptionText: String
    public var secondaryButtonTitle: String?
    public var image: Image?
    public var imageAccessibilityLabel: String
    public var accessibilityLabel: String?
    public var accessibilityHint: String?
    public var accessibilityIdentifier: String?

    public init(
        badgeText: String,
        badgeIconSystemName: String? = "tag.fill",
        brandText: String,
        titleText: String,
        descriptionText: String,
        secondaryButtonTitle: String? = nil,
        image: Image? = nil,
        imageAccessibilityLabel: String = "Product image",
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.badgeText = badgeText
        self.badgeIconSystemName = badgeIconSystemName
        self.brandText = brandText
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.secondaryButtonTitle = secondaryButtonTitle
        self.image = image
        self.imageAccessibilityLabel = imageAccessibilityLabel
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    /// Figma-aligned preset sourced from node 128:209.
    public static func specialOffer(
        badgeText: String = "Special Offer for you",
        brandText: String = "Apple",
        titleText: String = "iPhone 17 Pro Max",
        descriptionText: String = "Save up to $1,000 on any iphone when you trade in your eligible device",
        secondaryButtonTitle: String? = "Shop now",
        image: Image? = nil
    ) -> DSInfoTileConfiguration {
        DSInfoTileConfiguration(
            badgeText: badgeText,
            badgeIconSystemName: "tag.fill",
            brandText: brandText,
            titleText: titleText,
            descriptionText: descriptionText,
            secondaryButtonTitle: secondaryButtonTitle,
            image: image,
            imageAccessibilityLabel: "\(titleText) image",
            accessibilityLabel: "\(badgeText), \(brandText), \(titleText), \(descriptionText)",
            accessibilityHint: "Shows a promotional product offer"
        )
    }
}

// MARK: - DSInfoTile

/// Promotional info tile with top promo banner and media/content row.
///
/// Derived from Figma JSON node 128:209.
public struct DSInfoTile: View {
    private enum Metrics {
        static let rowSpacing: CGFloat = RDSToken.Spacing.small + (RDSToken.Spacing.xxSmall / 2)
        static let badgeMinHeight: CGFloat = RDSToken.Spacing.large + RDSToken.Spacing.small + (RDSToken.Spacing.xxSmall / 4)
        static let badgeHorizontalPadding: CGFloat = RDSToken.Spacing.small
        static let badgeIconTextSpacing: CGFloat = RDSToken.Spacing.medium
        static let imageSize: CGFloat = (RDSToken.Spacing.large * 6) + (RDSToken.Spacing.xxSmall - (RDSToken.Spacing.xxSmall / 4))
        static let placeholderIconSize: CGFloat = RDSToken.Spacing.large + RDSToken.Spacing.small
        static let textColumnTopPadding: CGFloat = RDSToken.Spacing.large
        static let textColumnSpacing: CGFloat = RDSToken.Spacing.xxSmall
        static let imageCornerRadius: CGFloat = RDSToken.Spacing.small
        static let secondaryButtonTopPadding: CGFloat = RDSToken.Spacing.small
    }

    private let configuration: DSInfoTileConfiguration
    private let onSecondaryButtonTap: (() -> Void)?

    public init(
        configuration: DSInfoTileConfiguration,
        onSecondaryButtonTap: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onSecondaryButtonTap = onSecondaryButtonTap
    }

    public init(
        badgeText: String,
        badgeIconSystemName: String? = "tag.fill",
        brandText: String,
        titleText: String,
        descriptionText: String,
        secondaryButtonTitle: String? = nil,
        image: Image? = nil,
        imageAccessibilityLabel: String = "Product image",
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil,
        onSecondaryButtonTap: (() -> Void)? = nil
    ) {
        self.init(
            configuration: DSInfoTileConfiguration(
                badgeText: badgeText,
                badgeIconSystemName: badgeIconSystemName,
                brandText: brandText,
                titleText: titleText,
                descriptionText: descriptionText,
                secondaryButtonTitle: secondaryButtonTitle,
                image: image,
                imageAccessibilityLabel: imageAccessibilityLabel,
                accessibilityLabel: accessibilityLabel,
                accessibilityHint: accessibilityHint,
                accessibilityIdentifier: accessibilityIdentifier
            ),
            onSecondaryButtonTap: onSecondaryButtonTap
        )
    }

    private var showsSecondaryButton: Bool {
        guard let secondaryButtonTitle = configuration.secondaryButtonTitle else {
            return false
        }
        return !secondaryButtonTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var body: some View {
        Group {
            if showsSecondaryButton {
                tileContent
                    .accessibilityElement(children: .contain)
                    .accessibilityHint(configuration.accessibilityHint ?? "")
            } else {
                tileContent
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(
                        configuration.accessibilityLabel
                            ?? "\(configuration.badgeText), \(configuration.brandText), \(configuration.titleText), \(configuration.descriptionText)"
                    )
                    .accessibilityHint(configuration.accessibilityHint ?? "")
            }
        }
        .optionalAccessibilityIdentifier(configuration.accessibilityIdentifier)
    }

    private var tileContent: some View {
        VStack(alignment: .leading, spacing: Metrics.rowSpacing) {
            badgeRow
            contentRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var badgeRow: some View {
        DSPromoBanner(
            configuration: DSPromoBannerConfiguration(
                text: configuration.badgeText,
                iconName: configuration.badgeIconSystemName,
                variant: .offer,
                minHeight: Metrics.badgeMinHeight,
                horizontalPadding: Metrics.badgeHorizontalPadding,
                iconTextSpacing: Metrics.badgeIconTextSpacing
            )
        )
        .frame(maxWidth: 300
                )
        .frame(maxHeight: 33)
        .accessibilityHidden(true)
    }

    private var contentRow: some View {
        VStack(alignment: .center, spacing: Metrics.rowSpacing) {
            
            HStack(alignment: .top, spacing: Metrics.rowSpacing) {
                imageContent

                VStack(alignment: .leading, spacing: Metrics.textColumnSpacing) {
                    DSLabel(
                        configuration.brandText,
                        style: RDSToken.Typography.bodyRegular,
                        color: .primary,
                        alignment: .leading,
                        numberOfLines: 1
                    )

                    DSLabel(
                        configuration.titleText,
                        style: RDSToken.Typography.bodyBold,
                        color: .primary,
                        alignment: .leading,
                        numberOfLines: 1
                    )

                    DSLabel(
                        configuration.descriptionText,
                        style: RDSToken.Typography.bodyRegular,
                        color: .primary,
                        alignment: .leading,
                        numberOfLines: 3
                    )
                }
                .padding(.top, Metrics.textColumnTopPadding)

                Spacer(minLength: 0)
            }
            
                if let secondaryButtonTitle = configuration.secondaryButtonTitle,
                   !secondaryButtonTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    DSButton(
                        secondaryButtonTitle,
                        variant: .outline,
                        size: .small
                    ) {
                        onSecondaryButtonTap?()
                    }
                    .padding(.top, Metrics.secondaryButtonTopPadding)
                    .padding(.leading, RDSToken.Spacing.large)
                    .padding(.trailing, RDSToken.Spacing.large)
                    .accessibilityHint("Activates \(secondaryButtonTitle)")
                }
        }
    }

    @ViewBuilder
    private var imageContent: some View {
        if let image = configuration.image {
            image
                .resizable()
                .scaledToFill()
                .frame(width: Metrics.imageSize, height: Metrics.imageSize)
                .clipShape(
                    RoundedRectangle(cornerRadius: Metrics.imageCornerRadius, style: .continuous)
                )
                .accessibilityLabel(configuration.imageAccessibilityLabel)
        } else {
            RoundedRectangle(cornerRadius: Metrics.imageCornerRadius, style: .continuous)
                .fill(RDSToken.Color.backgroundColor)
                .overlay(
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: Metrics.placeholderIconSize,
                            height: Metrics.placeholderIconSize
                        )
                        .foregroundColor(RDSToken.Color.textSecondaryColor)
                )
                .frame(width: Metrics.imageSize, height: Metrics.imageSize)
                .accessibilityLabel(configuration.imageAccessibilityLabel)
        }
    }
}

private extension View {
    @ViewBuilder
    func optionalAccessibilityIdentifier(_ identifier: String?) -> some View {
        if let identifier {
            self.accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}

#if DEBUG
struct DSInfoTile_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DSInfoTile(configuration: .specialOffer())
                .frame(width: 380)
                .preferredColorScheme(.light)
                .previewDisplayName("Special Offer - Light")

            DSInfoTile(configuration: .specialOffer())
                .frame(width: 380)
                .preferredColorScheme(.dark)
                .previewDisplayName("Special Offer - Dark")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
