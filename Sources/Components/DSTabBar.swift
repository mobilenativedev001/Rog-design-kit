// DSTabBar.swift
// Rogers iOS Design System
//
// Enterprise-grade, token-driven tab bar for SwiftUI.
//
// Goals:
//   • Reusable across app shells and embedded flows
//   • State driven by a typed selection binding
//   • Configurable without leaking styling logic into call sites
//   • Accessible, Dynamic Type aware, and dark-mode compatible
//
// Usage:
//   enum AppTab: String, Hashable {
//       case home, plans, support, profile
//   }
//
//   @State private var selectedTab: AppTab = .home
//
//   DSTabBar(
//       items: [
//           DSTabBarItem(id: .home, title: "Home", iconName: "house", selectedIconName: "house.fill"),
//           DSTabBarItem(id: .plans, title: "Plans", iconName: "simcard", selectedIconName: "simcard.fill", badge: .count(2)),
//           DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
//           DSTabBarItem(id: .profile, title: "Profile", iconName: "person", selectedIconName: "person.fill")
//       ],
//       selection: $selectedTab
//   )

import SwiftUI
import Tokens

// MARK: - DSTabBarBadge

public enum DSTabBarBadge: Equatable {
    case none
    case dot
    case count(Int)

    var isVisible: Bool {
        switch self {
        case .none: return false
        case .dot: return true
        case .count(let value): return value > 0
        }
    }

    var text: String? {
        switch self {
        case .none, .dot:
            return nil
        case .count(let value):
            return value > 99 ? "99+" : "\(value)"
        }
    }

    var accessibilityValue: String? {
        switch self {
        case .none:
            return nil
        case .dot:
            return "New item"
        case .count(let value):
            return "\(value) notifications"
        }
    }
}

// MARK: - DSTabBarItem

public struct DSTabBarItem<Selection: Hashable>: Identifiable, Equatable {
    public let id: Selection
    public let title: String
    public let iconName: String
    public let selectedIconName: String?
    public let badge: DSTabBarBadge
    public let isEnabled: Bool
    public let accessibilityLabel: String?
    public let accessibilityHint: String?
    public let accessibilityIdentifier: String?

    public init(
        id: Selection,
        title: String,
        iconName: String,
        selectedIconName: String? = nil,
        badge: DSTabBarBadge = .none,
        isEnabled: Bool = true,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil,
        accessibilityIdentifier: String? = nil
    ) {
        self.id = id
        self.title = title
        self.iconName = iconName
        self.selectedIconName = selectedIconName
        self.badge = badge
        self.isEnabled = isEnabled
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

// MARK: - DSTabBarConfiguration

public struct DSTabBarConfiguration: Equatable {
    public let horizontalPadding: CGFloat
    public let topPadding: CGFloat
    public let bottomPadding: CGFloat
    public let itemSpacing: CGFloat
    public let minHeight: CGFloat
    public let iconSize: CGFloat
    public let indicatorWidth: CGFloat
    public let indicatorHeight: CGFloat
    public let cornerRadius: CGFloat
    public let showsTopDivider: Bool
    public let showsShadow: Bool
    public let backgroundColor: Color
    public let selectedColor: Color
    public let unselectedColor: Color
    public let disabledColor: Color
    public let dividerColor: Color
    public let badgeBackgroundColor: Color
    public let badgeForegroundColor: Color

    public init(
        horizontalPadding: CGFloat = RDSToken.Spacing.medium,
        topPadding: CGFloat = 10,
        bottomPadding: CGFloat = 10,
        itemSpacing: CGFloat = RDSToken.Spacing.small,
        minHeight: CGFloat = 72,
        iconSize: CGFloat = 22,
        indicatorWidth: CGFloat = 28,
        indicatorHeight: CGFloat = 4,
        cornerRadius: CGFloat = 0,
        showsTopDivider: Bool = true,
        showsShadow: Bool = true,
        backgroundColor: Color = Color(RDSToken.Color.surface),
        selectedColor: Color = RDSToken.Color.buttonPrimaryBackgroundColor,
        unselectedColor: Color = RDSToken.Color.textSecondaryColor,
        disabledColor: Color = RDSToken.Color.textDisabledColor,
        dividerColor: Color = Color(RDSToken.Color.border),
        badgeBackgroundColor: Color = RDSToken.Color.errorColor,
        badgeForegroundColor: Color = .white
    ) {
        self.horizontalPadding = horizontalPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.itemSpacing = itemSpacing
        self.minHeight = minHeight
        self.iconSize = iconSize
        self.indicatorWidth = indicatorWidth
        self.indicatorHeight = indicatorHeight
        self.cornerRadius = cornerRadius
        self.showsTopDivider = showsTopDivider
        self.showsShadow = showsShadow
        self.backgroundColor = backgroundColor
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.disabledColor = disabledColor
        self.dividerColor = dividerColor
        self.badgeBackgroundColor = badgeBackgroundColor
        self.badgeForegroundColor = badgeForegroundColor
    }
}

// MARK: - DSTabBar

public struct DSTabBar<Selection: Hashable>: View {
    public let items: [DSTabBarItem<Selection>]
    @Binding public var selection: Selection
    public let configuration: DSTabBarConfiguration
    public let onSelectionChanged: ((Selection) -> Void)?

    public init(
        items: [DSTabBarItem<Selection>],
        selection: Binding<Selection>,
        configuration: DSTabBarConfiguration = DSTabBarConfiguration(),
        onSelectionChanged: ((Selection) -> Void)? = nil
    ) {
        self.items = items
        self._selection = selection
        self.configuration = configuration
        self.onSelectionChanged = onSelectionChanged
    }

    public var body: some View {
        VStack(spacing: 0) {
            if configuration.showsTopDivider {
                Rectangle()
                    .fill(configuration.dividerColor)
                    .frame(height: 1)
            }

            HStack(alignment: .top, spacing: configuration.itemSpacing) {
                ForEach(items) { item in
                    tabButton(for: item)
                }
            }
            .padding(.horizontal, configuration.horizontalPadding)
            .padding(.top, configuration.topPadding)
            .padding(.bottom, configuration.bottomPadding)
            .frame(maxWidth: .infinity, minHeight: configuration.minHeight)
            .background(configuration.backgroundColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: configuration.cornerRadius, style: .continuous))
        .shadow(
            color: configuration.showsShadow ? Color.black.opacity(0.08) : .clear,
            radius: configuration.showsShadow ? 10 : 0,
            x: 0,
            y: configuration.showsShadow ? -2 : 0
        )
    }

    @ViewBuilder
    private func tabButton(for item: DSTabBarItem<Selection>) -> some View {
        let isSelected = selection == item.id
        Button {
            guard item.isEnabled else { return }
            if selection != item.id {
                selection = item.id
                onSelectionChanged?(item.id)
            }
        } label: {
            VStack(spacing: 6) {
                Capsule()
                    .fill(isSelected ? configuration.selectedColor : .clear)
                    .frame(width: configuration.indicatorWidth, height: configuration.indicatorHeight)

                ZStack(alignment: .topTrailing) {
                    icon(for: item, isSelected: isSelected)
                        .frame(width: configuration.iconSize, height: configuration.iconSize)

                    if item.badge.isVisible {
                        badgeView(for: item.badge)
                            .offset(x: 10, y: -6)
                    }
                }
                .frame(height: configuration.iconSize)

                Text(item.title)
                    .font(RDSToken.Typography.caption.font)
                    .lineSpacing(RDSToken.Typography.caption.swiftUILineSpacing)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundColor(foregroundColor(isSelected: isSelected, isEnabled: item.isEnabled))
            .frame(maxWidth: .infinity, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!item.isEnabled)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(item.accessibilityLabel ?? item.title)
        .accessibilityHint(item.accessibilityHint ?? "Switches to the \(item.title) tab")
        .accessibilityValue(accessibilityValue(for: item, isSelected: isSelected))
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .optionalAccessibilityIdentifier(item.accessibilityIdentifier)
    }

    private func icon(for item: DSTabBarItem<Selection>, isSelected: Bool) -> some View {
        Image(systemName: isSelected ? (item.selectedIconName ?? item.iconName) : item.iconName)
            .resizable()
            .scaledToFit()
            .fontWeight(isSelected ? .semibold : .regular)
    }

    private func badgeView(for badge: DSTabBarBadge) -> some View {
        ZStack {
            Capsule()
                .fill(configuration.badgeBackgroundColor)
                .frame(
                    minWidth: badge.text == nil ? 10 : 18,
                    minHeight: badge.text == nil ? 10 : 18
                )

            if let text = badge.text {
                Text(text)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(configuration.badgeForegroundColor)
                    .padding(.horizontal, 4)
            }
        }
        .fixedSize()
    }

    private func foregroundColor(isSelected: Bool, isEnabled: Bool) -> Color {
        if !isEnabled { return configuration.disabledColor }
        return isSelected ? configuration.selectedColor : configuration.unselectedColor
    }

    private func accessibilityValue(for item: DSTabBarItem<Selection>, isSelected: Bool) -> String {
        var parts: [String] = []
        if isSelected {
            parts.append("Selected")
        }
        if let badgeValue = item.badge.accessibilityValue {
            parts.append(badgeValue)
        }
        return parts.joined(separator: ", ")
    }
}

private extension View {
    @ViewBuilder
    func optionalAccessibilityIdentifier(_ identifier: String?) -> some View {
        if let identifier {
            accessibilityIdentifier(identifier)
        } else {
            self
        }
    }
}

// MARK: - Previews

private enum _DSTabPreviewTab: String, Hashable {
    case home
    case plans
    case support
    case profile
}

#Preview("DSTabBar Light") {
    struct PreviewHost: View {
        @State private var selection: _DSTabPreviewTab = .home
        private var tabConfig = DSTabBarConfiguration(showsTopDivider: false)
        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                DSTabBar(
                    items: [
                        DSTabBarItem(id: .home, title: "Home", iconName: "house", selectedIconName: "house.fill"),
                        DSTabBarItem(id: .plans, title: "Plans", iconName: "simcard", selectedIconName: "simcard.fill", badge: .count(2)),
                        DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
                        DSTabBarItem(id: .profile, title: "Profile", iconName: "person", selectedIconName: "person.fill")
                    ],
                    selection: $selection,
                    configuration: tabConfig
                )
            }
            .background(Color(RDSToken.Color.background))
        }
    }

    return PreviewHost()
}

#Preview("DSTabBar Dark") {
    struct PreviewHost: View {
        @State private var selection: _DSTabPreviewTab = .plans

        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                DSTabBar(
                    items: [
                        DSTabBarItem(id: .home, title: "Home", iconName: "house", selectedIconName: "house.fill"),
                        DSTabBarItem(id: .plans, title: "Plans", iconName: "simcard", selectedIconName: "simcard.fill", badge: .dot),
                        DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill", isEnabled: false),
                        DSTabBarItem(id: .profile, title: "Profile", iconName: "person", selectedIconName: "person.fill")
                    ],
                    selection: $selection
                )
            }
            .background(Color(RDSToken.Color.background))
            .preferredColorScheme(.dark)
        }
    }

    return PreviewHost()
}
