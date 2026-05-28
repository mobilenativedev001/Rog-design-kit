// DSActionTileSnapshotTests.swift
// Rogers iOS Design System
//
// Snapshot + unit tests for DSActionTile, DSActionTileConfiguration,
// DSActionTileStatus.

import XCTest
import SwiftUI
import SnapshotTesting
@testable import Components
@testable import Tokens

final class DSActionTileSnapshotTests: XCTestCase {
    
    private let record = false
    
    // MARK: - Figma node 128:199 — exact reproduction
    
    func testActionTile_Figma128_199_Light() {
        // Exact spec from Figma node 128:199:
        //   Icon: airplane 24×24, Title: "Roaming" (DemiBold 16pt), 
        //   Status: "Not Active" (Medium 14pt, error red),
        //   Button: "Activate now" (outline purple)
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "airplane"),
                title: "Roaming",
                status: "Not Active",
                statusType: .inactive,
                buttonTitle: "Activate now"
            ) {},
            name: "figma_128_199_light",
            colorScheme: .light,
            width: 390
        )
    }
    
    func testActionTile_Figma128_199_Dark() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "airplane"),
                title: "Roaming",
                status: "Not Active",
                statusType: .inactive,
                buttonTitle: "Activate now"
            ) {},
            name: "figma_128_199_dark",
            colorScheme: .dark,
            width: 390
        )
    }
    
    // MARK: - Status Variants (Light)
    
    func testActionTile_StatusActive_Light() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "checkmark.circle.fill"),
                title: "Data Plan",
                status: "Active",
                statusType: .active,
                buttonTitle: "Manage"
            ) {},
            name: "status_active_light",
            colorScheme: .light
        )
    }
    
    func testActionTile_StatusInactive_Light() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "airplane"),
                title: "Roaming",
                status: "Not Active",
                statusType: .inactive,
                buttonTitle: "Activate now"
            ) {},
            name: "status_inactive_light",
            colorScheme: .light
        )
    }
    
    func testActionTile_StatusWarning_Light() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "exclamationmark.triangle.fill"),
                title: "Payment",
                status: "Attention Required",
                statusType: .warning,
                buttonTitle: "Review"
            ) {},
            name: "status_warning_light",
            colorScheme: .light
        )
    }
    
    func testActionTile_StatusError_Light() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "xmark.circle.fill"),
                title: "Service",
                status: "Error",
                statusType: .error,
                buttonTitle: "Retry"
            ) {},
            name: "status_error_light",
            colorScheme: .light
        )
    }
    
    func testActionTile_StatusNeutral_Light() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "info.circle"),
                title: "Information",
                status: "Available",
                statusType: .neutral,
                buttonTitle: "Learn more"
            ) {},
            name: "status_neutral_light",
            colorScheme: .light
        )
    }
    
    // MARK: - Status Variants (Dark)
    
    func testActionTile_AllStatuses_Dark() {
        let view = VStack(spacing: 16) {
            DSActionTile(
                icon: Image(systemName: "checkmark.circle.fill"),
                title: "Data Plan",
                status: "Active",
                statusType: .active,
                buttonTitle: "Manage"
            ) {}
            
            DSActionTile(
                icon: Image(systemName: "airplane"),
                title: "Roaming",
                status: "Not Active",
                statusType: .inactive,
                buttonTitle: "Activate now"
            ) {}
            
            DSActionTile(
                icon: Image(systemName: "exclamationmark.triangle.fill"),
                title: "Payment",
                status: "Attention Required",
                statusType: .warning,
                buttonTitle: "Review"
            ) {}
            
            DSActionTile(
                icon: Image(systemName: "xmark.circle.fill"),
                title: "Service",
                status: "Error",
                statusType: .error,
                buttonTitle: "Retry"
            ) {}
            
            DSActionTile(
                icon: Image(systemName: "info.circle"),
                title: "Information",
                status: "Available",
                statusType: .neutral,
                buttonTitle: "Learn more"
            ) {}
        }
        .padding()
        
        assertTileSnapshot(view, name: "all_statuses_dark", colorScheme: .dark, width: 390)
    }
    
    // MARK: - Without Button
    
    func testActionTile_NoButton_Active_Light() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "checkmark.circle.fill"),
                title: "Unlimited Data",
                status: "Active",
                statusType: .active
            ),
            name: "no_button_active_light",
            colorScheme: .light
        )
    }
    
    func testActionTile_NoButton_Neutral_Light() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "phone.fill"),
                title: "Voice Calls",
                status: "Unlimited Canada-wide",
                statusType: .neutral
            ),
            name: "no_button_neutral_light",
            colorScheme: .light
        )
    }
    
    func testActionTile_NoButton_Multiple_Dark() {
        let view = VStack(spacing: 16) {
            DSActionTile(
                icon: Image(systemName: "checkmark.circle.fill"),
                title: "Unlimited Data",
                status: "Active",
                statusType: .active
            )
            
            DSActionTile(
                icon: Image(systemName: "phone.fill"),
                title: "Voice Calls",
                status: "Unlimited Canada-wide",
                statusType: .neutral
            )
            
            DSActionTile(
                icon: Image(systemName: "message.fill"),
                title: "Text Messages",
                status: "Unlimited",
                statusType: .active
            )
        }
        .padding()
        
        assertTileSnapshot(view, name: "no_button_multiple_dark", colorScheme: .dark, width: 390)
    }
    
    // MARK: - Dynamic Type
    
    func testActionTile_DynamicType_Large() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "airplane"),
                title: "Roaming",
                status: "Not Active",
                statusType: .inactive,
                buttonTitle: "Activate now"
            ) {},
            name: "dynamic_type_large",
            colorScheme: .light,
            sizeCategory: .large
        )
    }
    
    func testActionTile_DynamicType_AccessibilityXXL() {
        assertTileSnapshot(
            DSActionTile(
                icon: Image(systemName: "airplane"),
                title: "Roaming",
                status: "Not Active",
                statusType: .inactive,
                buttonTitle: "Activate now"
            ) {},
            name: "dynamic_type_axl",
            colorScheme: .light,
            sizeCategory: .accessibilityExtraExtraLarge
        )
    }
    
    // MARK: - In-Context Settings Screen
    
    func testActionTile_InContext_SettingsScreen_Light() {
        let screen = VStack(alignment: .leading, spacing: 24) {
            DSPageHeader(
                title: "Manage Services",
                subtitle: "Control your account features"
            )
            
            VStack(spacing: 16) {
                DSActionTile(
                    icon: Image(systemName: "airplane"),
                    title: "Roaming",
                    status: "Not Active",
                    statusType: .inactive,
                    buttonTitle: "Activate now"
                ) {}
                
                DSActionTile(
                    icon: Image(systemName: "checkmark.circle.fill"),
                    title: "Data Plan",
                    status: "Active",
                    statusType: .active,
                    buttonTitle: "Manage"
                ) {}
                
                DSActionTile(
                    icon: Image(systemName: "exclamationmark.triangle.fill"),
                    title: "Payment",
                    status: "Attention Required",
                    statusType: .warning,
                    buttonTitle: "Review"
                ) {}
            }
        }
        .padding()
        .background(Color(.systemBackground))
        
        assertTileSnapshot(screen, name: "in_context_settings_light", colorScheme: .light, width: 390)
    }
    
    func testActionTile_InContext_SettingsScreen_Dark() {
        let screen = VStack(alignment: .leading, spacing: 24) {
            DSPageHeader(
                title: "Manage Services",
                subtitle: "Control your account features"
            )
            
            VStack(spacing: 16) {
                DSActionTile(
                    icon: Image(systemName: "airplane"),
                    title: "Roaming",
                    status: "Not Active",
                    statusType: .inactive,
                    buttonTitle: "Activate now"
                ) {}
                
                DSActionTile(
                    icon: Image(systemName: "checkmark.circle.fill"),
                    title: "Data Plan",
                    status: "Active",
                    statusType: .active,
                    buttonTitle: "Manage"
                ) {}
                
                DSActionTile(
                    icon: Image(systemName: "exclamationmark.triangle.fill"),
                    title: "Payment",
                    status: "Attention Required",
                    statusType: .warning,
                    buttonTitle: "Review"
                ) {}
            }
        }
        .padding()
        .background(Color(.systemBackground))
        
        assertTileSnapshot(screen, name: "in_context_settings_dark", colorScheme: .dark, width: 390)
    }
    
    // MARK: - Unit Tests: DSActionTileConfiguration
    
    func testConfiguration_DefaultValues() {
        let config = DSActionTileConfiguration(
            icon: Image(systemName: "airplane"),
            title: "Test",
            status: "Status"
        )
        XCTAssertEqual(config.title, "Test")
        XCTAssertEqual(config.status, "Status")
        XCTAssertEqual(config.statusType, .neutral)
        XCTAssertNil(config.buttonTitle)
        XCTAssertNil(config.accessibilityLabel)
        XCTAssertNil(config.accessibilityHint)
        XCTAssertNil(config.accessibilityIdentifier)
    }
    
    func testConfiguration_WithButton() {
        let config = DSActionTileConfiguration(
            icon: Image(systemName: "airplane"),
            title: "Roaming",
            status: "Not Active",
            statusType: .inactive,
            buttonTitle: "Activate now"
        )
        XCTAssertEqual(config.buttonTitle, "Activate now")
        XCTAssertEqual(config.statusType, .inactive)
    }
    
    func testConfiguration_WithAccessibility() {
        let config = DSActionTileConfiguration(
            icon: Image(systemName: "airplane"),
            title: "Roaming",
            status: "Not Active",
            statusType: .inactive,
            buttonTitle: "Activate now",
            accessibilityLabel: "Roaming service, currently not active",
            accessibilityHint: "Double tap to activate roaming",
            accessibilityIdentifier: "roaming-tile"
        )
        XCTAssertEqual(config.accessibilityLabel, "Roaming service, currently not active")
        XCTAssertEqual(config.accessibilityHint, "Double tap to activate roaming")
        XCTAssertEqual(config.accessibilityIdentifier, "roaming-tile")
    }
    
    func testConfiguration_Equality_SameConfigs() {
        let config1 = DSActionTileConfiguration(
            icon: Image(systemName: "airplane"),
            title: "Roaming",
            status: "Not Active",
            statusType: .inactive,
            buttonTitle: "Activate now"
        )
        let config2 = DSActionTileConfiguration(
            icon: Image(systemName: "airplane"),
            title: "Roaming",
            status: "Not Active",
            statusType: .inactive,
            buttonTitle: "Activate now"
        )
        XCTAssertEqual(config1, config2)
    }
    
    func testConfiguration_Equality_DifferentTitles() {
        let config1 = DSActionTileConfiguration(
            icon: Image(systemName: "airplane"),
            title: "Roaming",
            status: "Not Active"
        )
        let config2 = DSActionTileConfiguration(
            icon: Image(systemName: "airplane"),
            title: "Data Plan",
            status: "Not Active"
        )
        XCTAssertNotEqual(config1, config2)
    }
    
    // MARK: - Unit Tests: DSActionTileStatus
    
    func testStatus_TextColorMapping_Active() {
        XCTAssertEqual(DSActionTileStatus.active.textColor, .success)
    }
    
    func testStatus_TextColorMapping_Inactive() {
        XCTAssertEqual(DSActionTileStatus.inactive.textColor, .error)
    }
    
    func testStatus_TextColorMapping_Warning() {
        XCTAssertEqual(DSActionTileStatus.warning.textColor, .warning)
    }
    
    func testStatus_TextColorMapping_Error() {
        XCTAssertEqual(DSActionTileStatus.error.textColor, .error)
    }
    
    func testStatus_TextColorMapping_Neutral() {
        XCTAssertEqual(DSActionTileStatus.neutral.textColor, .secondary)
    }
    
    func testStatus_AllCases() {
        let allCases = DSActionTileStatus.allCases
        XCTAssertEqual(allCases.count, 5)
        XCTAssertTrue(allCases.contains(.active))
        XCTAssertTrue(allCases.contains(.inactive))
        XCTAssertTrue(allCases.contains(.warning))
        XCTAssertTrue(allCases.contains(.error))
        XCTAssertTrue(allCases.contains(.neutral))
    }
    
    // MARK: - Helpers
    
    private func assertTileSnapshot<V: View>(
        _ view: V,
        name: String,
        colorScheme: ColorScheme,
        width: CGFloat = 390,
        sizeCategory: ContentSizeCategory = .medium,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let themed = view
            .preferredColorScheme(colorScheme)
            .environment(\.sizeCategory, sizeCategory)
            .frame(width: width)
            .background(Color(.systemBackground))
        
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
