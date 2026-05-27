import XCTest
import SwiftUI
import SnapshotTesting
@testable import Components
@testable import Tokens

final class DSTabBarSnapshotTests: XCTestCase {

    private let record = false

    private enum FixtureTab: String, Hashable {
        case home
        case plans
        case support
        case profile
    }

    func testDSTabBar_Light() {
        assertTabBarSnapshot(
            selection: .home,
            name: "light_default",
            colorScheme: .light
        )
    }

    func testDSTabBar_Dark() {
        assertTabBarSnapshot(
            selection: .plans,
            name: "dark_selected_plans",
            colorScheme: .dark
        )
    }

    func testDSTabBar_WithBadge() {
        assertTabBarSnapshot(
            selection: .plans,
            items: fixtureItems,
            name: "with_badge",
            colorScheme: .light
        )
    }

    func testDSTabBar_DisabledItem() {
        let items = [
            DSTabBarItem(id: FixtureTab.home, title: "Home", iconName: "house", selectedIconName: "house.fill"),
            DSTabBarItem(id: FixtureTab.plans, title: "Plans", iconName: "simcard", selectedIconName: "simcard.fill"),
            DSTabBarItem(id: FixtureTab.support, title: "Support", iconName: "message", selectedIconName: "message.fill", isEnabled: false),
            DSTabBarItem(id: FixtureTab.profile, title: "Profile", iconName: "person", selectedIconName: "person.fill")
        ]

        assertTabBarSnapshot(
            selection: .support,
            items: items,
            name: "disabled_item",
            colorScheme: .light
        )
    }

    func testBadgeTextCapsAt99Plus() {
        XCTAssertEqual(DSTabBarBadge.count(120).text, "99+")
    }

    private var fixtureItems: [DSTabBarItem<FixtureTab>] {
        [
            DSTabBarItem(id: .home, title: "Home", iconName: "house", selectedIconName: "house.fill"),
            DSTabBarItem(id: .plans, title: "Plans", iconName: "simcard", selectedIconName: "simcard.fill", badge: .count(7)),
            DSTabBarItem(id: .support, title: "Support", iconName: "message", selectedIconName: "message.fill"),
            DSTabBarItem(id: .profile, title: "Profile", iconName: "person", selectedIconName: "person.fill")
        ]
    }

    private func assertTabBarSnapshot(
        selection: FixtureTab,
        items: [DSTabBarItem<FixtureTab>] = [],
        name: String,
        colorScheme: ColorScheme,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let renderedItems = items.isEmpty ? fixtureItems : items
        let view = DSTabBar(
            items: renderedItems,
            selection: .constant(selection)
        )
        .preferredColorScheme(colorScheme)
        .background(Color(RDSToken.Color.background))

        let host = UIHostingController(rootView: view)
        host.overrideUserInterfaceStyle = colorScheme == .dark ? .dark : .light
        host.view.frame = CGRect(x: 0, y: 0, width: 390, height: 88)

        assertSnapshot(
            matching: host,
            as: .image,
            named: name,
            record: record,
            file: file,
            testName: testName,
            line: line
        )
    }
}
