import SwiftUI
import Tokens

// MARK: - DSCompactTileConfiguration

/// Configuration model for `DSCompactTile`.
///
/// This configuration is value-based to keep the component reusable and
/// composable across screens without embedding feature logic.
public struct DSCompactTileConfiguration: Equatable {
    public var title: String
    public var valueText: String
    public var detailText: String
    public var progress: Double
    public var leadingIconSystemName: String?
    public var actionIconSystemName: String?
    public var showsActionButton: Bool
    public var accessibilityLabel: String?
    public var accessibilityHint: String?
    public var accessibilityIdentifier: String?

    public init(
        title: String,
        valueText: String,
        detailText: String,
        progress: Double,
        leadingIconSystemName: String? = "antenna.radiowaves.left.and.right",
        actionIconSystemName: String? = "plus",
        showsActionButton: Bool = true,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.title = title
        self.valueText = valueText
        self.detailText = detailText
        self.progress = progress
        self.leadingIconSystemName = leadingIconSystemName
        self.actionIconSystemName = actionIconSystemName
        self.showsActionButton = showsActionButton
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    /// Preset aligned with Figma node 128:177.
    public static func dataUsage(
        title: String = "Data Usage",
        valueText: String = "63%",
        detailText: String = "12.6 GB of 20 GB is used",
        progress: Double = 0.63
    ) -> DSCompactTileConfiguration {
        DSCompactTileConfiguration(
            title: title,
            valueText: valueText,
            detailText: detailText,
            progress: progress,
            leadingIconSystemName: "antenna.radiowaves.left.and.right",
            actionIconSystemName: "plus",
            showsActionButton: true,
            accessibilityLabel: "\(title), \(valueText), \(detailText)",
            accessibilityHint: "Shows current usage details"
        )
    }
}

// MARK: - DSCompactTile

/// Reusable metric tile component derived from Figma node 128:177.
///
/// The component is token-driven, supports dark mode, and exposes UIKit
/// compatibility via `DSCompactTile+UIKit.swift`.
public struct DSCompactTile: View {
    private enum Metrics {
        static let cornerRadius: CGFloat = RDSToken.Spacing.medium
        static let borderWidth: CGFloat = 1
        static let topPadding: CGFloat = RDSToken.Spacing.medium
        static let horizontalPadding: CGFloat = RDSToken.Spacing.medium
        static let bottomPadding: CGFloat = RDSToken.Spacing.medium
        static let iconSize: CGFloat = 21
        static let iconContainerSize: CGFloat = RDSToken.Spacing.large + RDSToken.Spacing.small
        static let actionContainerSize: CGFloat = RDSToken.Spacing.large + RDSToken.Spacing.small
        static let rowSpacing: CGFloat = RDSToken.Spacing.small
        static let progressHeight: CGFloat = RDSToken.Spacing.xxSmall
        static let progressCornerRadius: CGFloat = RDSToken.Spacing.xxSmall / 2
    }

    private let configuration: DSCompactTileConfiguration
    private let onActionTap: (() -> Void)?

    public init(
        configuration: DSCompactTileConfiguration,
        onActionTap: (() -> Void)? = nil
    ) {
        self.configuration = configuration
        self.onActionTap = onActionTap
    }

    public init(
        title: String,
        valueText: String,
        detailText: String,
        progress: Double,
        leadingIconSystemName: String? = "antenna.radiowaves.left.and.right",
        actionIconSystemName: String? = "plus",
        showsActionButton: Bool = true,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil,
        onActionTap: (() -> Void)? = nil
    ) {
        self.init(
            configuration: DSCompactTileConfiguration(
                title: title,
                valueText: valueText,
                detailText: detailText,
                progress: progress,
                leadingIconSystemName: leadingIconSystemName,
                actionIconSystemName: actionIconSystemName,
                showsActionButton: showsActionButton,
                accessibilityLabel: accessibilityLabel,
                accessibilityHint: accessibilityHint,
                accessibilityIdentifier: accessibilityIdentifier
            ),
            onActionTap: onActionTap
        )
    }

    public var body: some View {
        VStack(spacing: Metrics.rowSpacing) {
            headerRow

            Text(configuration.valueText)
                .font(RDSToken.Typography.compactTileMetric.font)
                .lineSpacing(RDSToken.Typography.compactTileMetric.swiftUILineSpacing)
                .tracking(RDSToken.Typography.compactTileMetric.letterSpacing)
                .foregroundColor(RDSToken.Color.textSecondaryColor)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.75)
                .lineLimit(1)

            Text(configuration.detailText)
                .font(RDSToken.Typography.compactTileDetail.font)
                .lineSpacing(RDSToken.Typography.compactTileDetail.swiftUILineSpacing)
                .foregroundColor(RDSToken.Color.textSecondaryColor)
                .multilineTextAlignment(.center)
                .lineLimit(2)

            progressBar
        }
        .padding(.top, Metrics.topPadding)
        .padding(.horizontal, Metrics.horizontalPadding)
        .padding(.bottom, Metrics.bottomPadding)
        .background(RDSToken.Color.compactTileBackgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: Metrics.cornerRadius, style: .continuous)
                .stroke(RDSToken.Color.compactTileBorderColor, lineWidth: Metrics.borderWidth)
        )
        .clipShape(RoundedRectangle(cornerRadius: Metrics.cornerRadius, style: .continuous))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(configuration.accessibilityLabel ?? "\(configuration.title), \(configuration.valueText), \(configuration.detailText)")
        .accessibilityHint(configuration.accessibilityHint ?? "")
        .accessibilityValue("\(Int(clampedProgress * 100)) percent")
        .optionalAccessibilityIdentifier(configuration.accessibilityIdentifier)
    }

    private var clampedProgress: Double {
        min(max(configuration.progress, 0), 1)
    }

    @ViewBuilder
    private var headerRow: some View {
        HStack(spacing: RDSToken.Spacing.xxSmall) {
            if let iconName = configuration.leadingIconSystemName {
                ZStack {
                    Circle()
                        .fill(RDSToken.Color.compactTileAccessoryBackgroundColor)
                    Image(systemName: iconName)
                        .font(.system(size: Metrics.iconSize, weight: .semibold))
                        .foregroundColor(RDSToken.Color.compactTileAccessoryForegroundColor)
                        .accessibilityHidden(true)
                }
                .frame(width: Metrics.iconContainerSize, height: Metrics.iconContainerSize)
            }

            Text(configuration.title)
                .font(RDSToken.Typography.compactTileTitle.font)
                .lineSpacing(RDSToken.Typography.compactTileTitle.swiftUILineSpacing)
                .foregroundColor(RDSToken.Color.textPrimaryColor)
                .lineLimit(1)

            Spacer(minLength: RDSToken.Spacing.small)

            if configuration.showsActionButton, let actionIconName = configuration.actionIconSystemName {
                actionButton(iconName: actionIconName)
            }
        }
    }

    @ViewBuilder
    private func actionButton(iconName: String) -> some View {
        Group {
            if let onActionTap {
                Button(action: onActionTap) {
                    actionContent(iconName: iconName)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Add")
                .accessibilityHint("Performs compact tile action")
                .accessibilityAddTraits(.isButton)
            } else {
                actionContent(iconName: iconName)
                    .accessibilityHidden(true)
            }
        }
    }

    private func actionContent(iconName: String) -> some View {
        ZStack {
            Circle()
                .fill(RDSToken.Color.compactTileAccessoryBackgroundColor)
            Image(systemName: iconName)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(RDSToken.Color.compactTileAccessoryForegroundColor)
        }
        .frame(width: Metrics.actionContainerSize, height: Metrics.actionContainerSize)
    }

    private var progressBar: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: Metrics.progressCornerRadius, style: .continuous)
                    .fill(RDSToken.Color.compactTileProgressTrackColor)

                RoundedRectangle(cornerRadius: Metrics.progressCornerRadius, style: .continuous)
                    .fill(RDSToken.Color.compactTileProgressFillColor)
                    .frame(width: proxy.size.width * clampedProgress)
            }
        }
        .frame(height: Metrics.progressHeight)
        .accessibilityHidden(true)
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
struct DSCompactTile_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DSCompactTile(configuration: .dataUsage())
                .frame(width: 200)
                .preferredColorScheme(.light)
                .previewDisplayName("Data Usage - Light")

            DSCompactTile(configuration: .dataUsage())
                .frame(width: 200)
                .preferredColorScheme(.dark)
                .previewDisplayName("Data Usage - Dark")

            DSCompactTile(
                configuration: DSCompactTileConfiguration(
                    title: "Cloud Storage",
                    valueText: "40%",
                    detailText: "40 GB of 100 GB is used",
                    progress: 0.4,
                    leadingIconSystemName: "externaldrive.fill",
                    actionIconSystemName: "chevron.right",
                    showsActionButton: true
                )
            )
            .frame(width: 200)
            .preferredColorScheme(.light)
            .previewDisplayName("Custom")
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
