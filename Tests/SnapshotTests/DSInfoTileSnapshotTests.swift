import XCTest
import SwiftUI
import SnapshotTesting
@testable import Components

final class DSInfoTileSnapshotTests: XCTestCase {
    private let record = false

    func testInfoTile_SpecialOffer_Light() {
        assertTileSnapshot(
            DSInfoTile(configuration: .specialOffer()),
            name: "special_offer_light",
            colorScheme: .light
        )
    }

    func testInfoTile_SpecialOffer_Dark() {
        assertTileSnapshot(
            DSInfoTile(configuration: .specialOffer()),
            name: "special_offer_dark",
            colorScheme: .dark
        )
    }

    func testInfoTile_NoBadgeIcon() {
        let configuration = DSInfoTileConfiguration(
            badgeText: "Special Offer for you",
            badgeIconSystemName: nil,
            brandText: "Apple",
            titleText: "iPhone 17 Pro Max",
            descriptionText: "Save up to $1,000 on any iphone when you trade in your eligible device"
        )

        assertTileSnapshot(
            DSInfoTile(configuration: configuration),
            name: "no_badge_icon",
            colorScheme: .light
        )
    }

    func testInfoTile_CustomContent() {
        let configuration = DSInfoTileConfiguration(
            badgeText: "Limited Time",
            badgeIconSystemName: "sparkles",
            brandText: "Google",
            titleText: "Pixel Ultra",
            descriptionText: "Trade in your device and save up to $900 on your next upgrade"
        )

        assertTileSnapshot(
            DSInfoTile(configuration: configuration),
            name: "custom_content",
            colorScheme: .light
        )
    }

    func testInfoTile_WithSecondaryButton() {
        let configuration = DSInfoTileConfiguration(
            badgeText: "Special Offer for you",
            badgeIconSystemName: "tag.fill",
            brandText: "Apple",
            titleText: "iPhone 17 Pro Max",
            descriptionText: "Save up to $1,000 on any iphone when you trade in your eligible device",
            secondaryButtonTitle: "Shop now"
        )

        assertTileSnapshot(
            DSInfoTile(configuration: configuration),
            name: "with_secondary_button",
            colorScheme: .light
        )
    }

    private func assertTileSnapshot<V: View>(
        _ view: V,
        name: String,
        colorScheme: ColorScheme,
        width: CGFloat = 380,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let themed = view
            .preferredColorScheme(colorScheme)
            .frame(width: width)

        let host = UIHostingController(rootView: themed)
        host.overrideUserInterfaceStyle = colorScheme == .dark ? .dark : .light
        host.view.frame = CGRect(
            origin: .zero,
            size: host.view.systemLayoutSizeFitting(
                CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
        )

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