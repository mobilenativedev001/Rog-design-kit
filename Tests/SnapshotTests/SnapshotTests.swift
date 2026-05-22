import XCTest
import SwiftUI
import SnapshotTesting
@testable import Components

final class SnapshotTests: XCTestCase {

    // Set to true locally to regenerate reference images after intentional changes.
    private let record = false

    override func setUp() {
        super.setUp()
        // isRecording = true
    }

    // MARK: - Legacy RDSButton

    func testPrimaryButtonSnapshot() {
        let view = RDSButton(title: "Snapshot", action: {})
        let host = UIHostingController(rootView: view)
        host.view.frame = CGRect(origin: .zero, size: CGSize(width: 200, height: 60))
        assertSnapshot(matching: host, as: .image, record: record)
    }

    // MARK: - DSButton variant snapshots

    func testDSButton_Primary_Light() {
        assertDSButtonSnapshot(
            DSButton("Sign in", variant: .primary) {},
            name: "primary_light",
            colorScheme: .light
        )
    }

    func testDSButton_Primary_Dark() {
        assertDSButtonSnapshot(
            DSButton("Sign in", variant: .primary) {},
            name: "primary_dark",
            colorScheme: .dark
        )
    }

    func testDSButton_Secondary_Light() {
        assertDSButtonSnapshot(
            DSButton("Activate now", variant: .secondary) {},
            name: "secondary_light",
            colorScheme: .light
        )
    }

    func testDSButton_Outline_Light() {
        assertDSButtonSnapshot(
            DSButton("Learn more", variant: .outline) {},
            name: "outline_light",
            colorScheme: .light
        )
    }

    func testDSButton_Outline_Dark() {
        assertDSButtonSnapshot(
            DSButton("Learn more", variant: .outline) {},
            name: "outline_dark",
            colorScheme: .dark
        )
    }

    func testDSButton_Destructive_Light() {
        assertDSButtonSnapshot(
            DSButton("Delete account", variant: .destructive) {},
            name: "destructive_light",
            colorScheme: .light
        )
    }

    func testDSButton_Ghost_Light() {
        assertDSButtonSnapshot(
            DSButton("Skip", variant: .ghost) {},
            name: "ghost_light",
            colorScheme: .light
        )
    }

    // MARK: - DSButton size snapshots

    func testDSButton_Size_Small() {
        assertDSButtonSnapshot(
            DSButton("Small", variant: .primary, size: .small) {},
            name: "size_small",
            colorScheme: .light
        )
    }

    func testDSButton_Size_Medium() {
        assertDSButtonSnapshot(
            DSButton("Medium", variant: .primary, size: .medium) {},
            name: "size_medium",
            colorScheme: .light
        )
    }

    func testDSButton_Size_Large() {
        assertDSButtonSnapshot(
            DSButton("Large", variant: .primary, size: .large) {},
            name: "size_large",
            colorScheme: .light
        )
    }

    // MARK: - DSButton state snapshots

    func testDSButton_State_Loading() {
        assertDSButtonSnapshot(
            DSButton("Sign in", variant: .primary, isLoading: true) {},
            name: "state_loading",
            colorScheme: .light
        )
    }

    func testDSButton_State_Disabled() {
        assertDSButtonSnapshot(
            DSButton("Sign in", variant: .primary, isDisabled: true) {},
            name: "state_disabled",
            colorScheme: .light
        )
    }

    func testDSButton_State_Disabled_Outline() {
        assertDSButtonSnapshot(
            DSButton("Learn more", variant: .outline, isDisabled: true) {},
            name: "state_disabled_outline",
            colorScheme: .light
        )
    }

    // MARK: - DSButton icon snapshots

    func testDSButton_WithLeadingIcon() {
        assertDSButtonSnapshot(
            DSButton(
                "Download",
                variant: .primary,
                leadingIcon: Image(systemName: "arrow.down.circle.fill")
            ) {},
            name: "with_leading_icon",
            colorScheme: .light
        )
    }

    func testDSButton_WithTrailingIcon() {
        assertDSButtonSnapshot(
            DSButton(
                "Continue",
                variant: .outline,
                trailingIcon: Image(systemName: "arrow.right")
            ) {},
            name: "with_trailing_icon",
            colorScheme: .light
        )
    }

    // MARK: - All variants matrix

    /// Renders all five variants side-by-side in a single reference image
    /// so a single glance catches any cross-variant regression.
    func testDSButton_AllVariants_Matrix() {
        let matrix = VStack(spacing: 16) {
            DSButton("Primary",     variant: .primary)     { }
            DSButton("Secondary",   variant: .secondary)   { }
            DSButton("Outline",     variant: .outline)     { }
            DSButton("Destructive", variant: .destructive) { }
            DSButton("Ghost",       variant: .ghost)       { }
        }
        .padding()
        .background(Color(.systemBackground))

        assertDSButtonSnapshot(matrix, name: "all_variants_matrix", colorScheme: .light, width: 320)
    }

    // MARK: - Helpers

    /// Renders `view` inside a `UIHostingController` with the given
    /// `colorScheme` and asserts a snapshot match.
    private func assertDSButtonSnapshot<V: View>(
        _ view: V,
        name: String,
        colorScheme: ColorScheme,
        width: CGFloat = 300,
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
