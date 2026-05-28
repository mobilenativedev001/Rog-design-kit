import XCTest
import SwiftUI
import SnapshotTesting
@testable import Components

final class DSCompactTileSnapshotTests: XCTestCase {
    private let record = false

    func testCompactTile_DataUsage_Light() {
        assertTileSnapshot(
            DSCompactTile(configuration: .dataUsage()),
            name: "data_usage_light",
            colorScheme: .light
        )
    }

    func testCompactTile_DataUsage_Dark() {
        assertTileSnapshot(
            DSCompactTile(configuration: .dataUsage()),
            name: "data_usage_dark",
            colorScheme: .dark
        )
    }

    func testCompactTile_ActionHidden() {
        let config = DSCompactTileConfiguration(
            title: "Data Usage",
            valueText: "63%",
            detailText: "12.6 GB of 20 GB is used",
            progress: 0.63,
            leadingIconSystemName: "antenna.radiowaves.left.and.right",
            actionIconSystemName: "plus",
            showsActionButton: false
        )

        assertTileSnapshot(
            DSCompactTile(configuration: config),
            name: "action_hidden",
            colorScheme: .light
        )
    }

    func testCompactTile_ProgressBounds() {
        let low = DSCompactTileConfiguration(title: "A", valueText: "0%", detailText: "0", progress: -1)
        let high = DSCompactTileConfiguration(title: "B", valueText: "100%", detailText: "100", progress: 2)
        XCTAssertEqual(low.progress, -1)
        XCTAssertEqual(high.progress, 2)
    }

    private func assertTileSnapshot<V: View>(
        _ view: V,
        name: String,
        colorScheme: ColorScheme,
        width: CGFloat = 200,
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
