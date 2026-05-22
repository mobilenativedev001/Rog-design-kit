// DSTextFieldSnapshotTests.swift
// Rogers iOS Design System
//
// Snapshot tests for DSTextField — covers all states, style variants, and
// validation results in both light and dark appearance modes.
//
// Run with SnapshotTesting in record mode to create/update reference images:
//   let record = true   ← flip locally, never commit

import XCTest
import SwiftUI
import SnapshotTesting
@testable import Components

final class DSTextFieldSnapshotTests: XCTestCase {

    // Set to `true` locally to regenerate reference images after intentional changes.
    // Never commit as `true`.
    private let record = false

    // MARK: - Idle state

    func testDSTextField_Idle_Light() {
        assertFieldSnapshot(
            DSTextField("Username", placeholder: "Enter username", text: .constant("")),
            name: "idle_light", colorScheme: .light
        )
    }

    func testDSTextField_Idle_Dark() {
        assertFieldSnapshot(
            DSTextField("Username", placeholder: "Enter username", text: .constant("")),
            name: "idle_dark", colorScheme: .dark
        )
    }

    // MARK: - With placeholder text

    func testDSTextField_WithValue_Light() {
        assertFieldSnapshot(
            DSTextField("Email", placeholder: "you@rogers.com", text: .constant("user@rogers.com")),
            name: "with_value_light", colorScheme: .light
        )
    }

    func testDSTextField_WithValue_Dark() {
        assertFieldSnapshot(
            DSTextField("Email", placeholder: "you@rogers.com", text: .constant("user@rogers.com")),
            name: "with_value_dark", colorScheme: .dark
        )
    }

    // MARK: - Validation states

    func testDSTextField_Valid() {
        assertFieldSnapshot(
            DSTextField(
                "Email",
                placeholder: "you@rogers.com",
                validators: [DSEmailValidator()],
                text: .constant("user@rogers.com"),
                externalResult: .constant(.valid)
            ),
            name: "valid", colorScheme: .light
        )
    }

    func testDSTextField_Error_Light() {
        assertFieldSnapshot(
            DSTextField(
                "Email",
                placeholder: "you@rogers.com",
                text: .constant("not-an-email"),
                externalResult: .constant(.invalid(message: "Please enter a valid email address."))
            ),
            name: "error_light", colorScheme: .light
        )
    }

    func testDSTextField_Error_Dark() {
        assertFieldSnapshot(
            DSTextField(
                "Email",
                placeholder: "you@rogers.com",
                text: .constant("not-an-email"),
                externalResult: .constant(.invalid(message: "Please enter a valid email address."))
            ),
            name: "error_dark", colorScheme: .dark
        )
    }

    func testDSTextField_Error_WithHelperText() {
        assertFieldSnapshot(
            DSTextField(
                "Password",
                placeholder: "Enter password",
                helperText: "Minimum 8 characters.",
                validators: [DSRequiredValidator(), DSMinLengthValidator(minLength: 8)],
                text: .constant("short"),
                externalResult: .constant(.invalid(message: "Must be at least 8 characters."))
            ),
            name: "error_with_helper_text", colorScheme: .light
        )
    }

    // MARK: - Disabled state

    func testDSTextField_Disabled_Light() {
        assertFieldSnapshot(
            DSTextField(
                "Username",
                placeholder: "Not available",
                isDisabled: true,
                text: .constant("jsmith")
            ),
            name: "disabled_light", colorScheme: .light
        )
    }

    func testDSTextField_Disabled_Dark() {
        assertFieldSnapshot(
            DSTextField(
                "Username",
                placeholder: "Not available",
                isDisabled: true,
                text: .constant("jsmith")
            ),
            name: "disabled_dark", colorScheme: .dark
        )
    }

    // MARK: - Secure input

    func testDSTextField_Secure_Hidden() {
        assertFieldSnapshot(
            DSTextField(
                "Password",
                placeholder: "Enter password",
                isSecure: true,
                text: .constant("s3cr3tP@ss")
            ),
            name: "secure_hidden", colorScheme: .light
        )
    }

    // MARK: - Style variants

    func testDSTextField_StyleVariant_Outlined() {
        assertFieldSnapshot(
            DSTextField("Label", placeholder: "Outlined", styleVariant: .outlined, text: .constant("")),
            name: "style_outlined", colorScheme: .light
        )
    }

    func testDSTextField_StyleVariant_Filled() {
        assertFieldSnapshot(
            DSTextField("Label", placeholder: "Filled", styleVariant: .filled, text: .constant("")),
            name: "style_filled", colorScheme: .light
        )
    }

    func testDSTextField_StyleVariant_Underlined() {
        assertFieldSnapshot(
            DSTextField("Label", placeholder: "Underlined", styleVariant: .underlined, text: .constant("")),
            name: "style_underlined", colorScheme: .light
        )
    }

    // MARK: - Prefix / suffix icons

    func testDSTextField_PrefixIcon() {
        assertFieldSnapshot(
            DSTextField(
                "Search",
                placeholder: "Search channels...",
                prefixIcon: Image(systemName: "magnifyingglass"),
                text: .constant("")
            ),
            name: "prefix_icon", colorScheme: .light
        )
    }

    func testDSTextField_SuffixIcon() {
        assertFieldSnapshot(
            DSTextField(
                "Promo code",
                placeholder: "Enter code",
                suffixIcon: Image(systemName: "qrcode.viewfinder"),
                onSuffixIconTap: {},
                text: .constant("")
            ),
            name: "suffix_icon", colorScheme: .light
        )
    }

    func testDSTextField_PrefixAndSuffixIcon() {
        assertFieldSnapshot(
            DSTextField(
                "Phone",
                placeholder: "+1 (416) 555-0100",
                prefixIcon: Image(systemName: "phone"),
                suffixIcon: Image(systemName: "chevron.down"),
                text: .constant("")
            ),
            name: "prefix_suffix_icon", colorScheme: .light
        )
    }

    // MARK: - Helper text

    func testDSTextField_WithHelperText() {
        assertFieldSnapshot(
            DSTextField(
                "Email",
                placeholder: "you@rogers.com",
                helperText: "We'll never share your email.",
                text: .constant("")
            ),
            name: "with_helper_text", colorScheme: .light
        )
    }

    // MARK: - Convenience factory configurations

    func testDSTextField_Config_Email() {
        assertFieldSnapshot(
            DSTextField(configuration: .email(), text: .constant("")),
            name: "config_email", colorScheme: .light
        )
    }

    func testDSTextField_Config_Password() {
        assertFieldSnapshot(
            DSTextField(configuration: .password(), text: .constant("")),
            name: "config_password", colorScheme: .light
        )
    }

    func testDSTextField_Config_Phone() {
        assertFieldSnapshot(
            DSTextField(configuration: .phone(), text: .constant("")),
            name: "config_phone", colorScheme: .light
        )
    }

    // MARK: - All states matrix (single reference image)

    func testDSTextField_AllStates_Matrix() {
        let matrix = ScrollView {
            VStack(spacing: 16) {
                DSTextField("Idle",     placeholder: "Enter text",       text: .constant(""))
                DSTextField("Filled",   placeholder: "Enter text",       text: .constant("Sample value"))
                DSTextField("Valid",    placeholder: "you@rogers.com",   text: .constant("user@rogers.com"),  externalResult: .constant(.valid))
                DSTextField("Error",    placeholder: "you@rogers.com",   text: .constant("bad"),              externalResult: .constant(.invalid(message: "Invalid email")))
                DSTextField("Disabled", placeholder: "Unavailable",      isDisabled: true, text: .constant(""))
                DSTextField("Secure",   placeholder: "Enter password",   isSecure: true, text: .constant("password"))
                DSTextField("Icon",     placeholder: "Search…",          prefixIcon: Image(systemName: "magnifyingglass"), text: .constant(""))
                DSTextField("Helper",   placeholder: "Enter text",       helperText: "Some helpful hint.", text: .constant(""))
            }
            .padding()
            .background(Color(.systemBackground))
        }
        assertFieldSnapshot(matrix, name: "all_states_matrix", colorScheme: .light, width: 360)
    }

    // MARK: - Validation unit tests

    func testRequiredValidator_Empty_ReturnsInvalid() {
        let result = DSRequiredValidator().validate("")
        XCTAssertEqual(result, .invalid(message: "This field is required."))
    }

    func testRequiredValidator_Whitespace_ReturnsInvalid() {
        let result = DSRequiredValidator().validate("   ")
        XCTAssertEqual(result, .invalid(message: "This field is required."))
    }

    func testRequiredValidator_NonEmpty_ReturnsValid() {
        let result = DSRequiredValidator().validate("hello")
        XCTAssertEqual(result, .valid)
    }

    func testEmailValidator_ValidAddress_ReturnsValid() {
        XCTAssertEqual(DSEmailValidator().validate("user@rogers.com"), .valid)
        XCTAssertEqual(DSEmailValidator().validate("first.last+tag@sub.domain.ca"), .valid)
    }

    func testEmailValidator_InvalidAddress_ReturnsInvalid() {
        XCTAssertEqual(DSEmailValidator().validate("notanemail").isValid, false)
        XCTAssertEqual(DSEmailValidator().validate("@missing.com").isValid, false)
        XCTAssertEqual(DSEmailValidator().validate("missing@").isValid, false)
    }

    func testMinLengthValidator_TooShort_ReturnsInvalid() {
        let result = DSMinLengthValidator(minLength: 8).validate("short")
        XCTAssertEqual(result, .invalid(message: "Must be at least 8 characters."))
    }

    func testMinLengthValidator_ExactLength_ReturnsValid() {
        XCTAssertEqual(DSMinLengthValidator(minLength: 8).validate("12345678"), .valid)
    }

    func testMaxLengthValidator_TooLong_ReturnsInvalid() {
        let result = DSMaxLengthValidator(maxLength: 5).validate("toolong")
        XCTAssertEqual(result.isValid, false)
    }

    func testPhoneValidator_Valid() {
        XCTAssertEqual(DSPhoneValidator().validate("4165550100"), .valid)
        XCTAssertEqual(DSPhoneValidator().validate("416-555-0100"), .valid)
        XCTAssertEqual(DSPhoneValidator().validate("+1 (416) 555-0100"), .valid)
    }

    func testPhoneValidator_Invalid() {
        XCTAssertEqual(DSPhoneValidator().validate("123").isValid, false)
        XCTAssertEqual(DSPhoneValidator().validate("abc").isValid, false)
    }

    func testPostalCodeValidator_ValidCanadian() {
        XCTAssertEqual(DSPostalCodeValidator().validate("M5V 3A8"), .valid)
        XCTAssertEqual(DSPostalCodeValidator().validate("m5v3a8"), .valid)  // case-insensitive
    }

    func testPostalCodeValidator_Invalid() {
        XCTAssertEqual(DSPostalCodeValidator().validate("12345").isValid, false)
        XCTAssertEqual(DSPostalCodeValidator().validate("").isValid, false)
    }

    func testRunValidators_FirstFailureReturned() {
        let validators: [any DSTextFieldValidator] = [
            DSRequiredValidator(message: "Required."),
            DSEmailValidator(message: "Bad email.")
        ]
        XCTAssertEqual(dsRunValidators("", validators: validators),
                       .invalid(message: "Required."))
        XCTAssertEqual(dsRunValidators("notanemail", validators: validators),
                       .invalid(message: "Bad email."))
        XCTAssertEqual(dsRunValidators("user@rogers.com", validators: validators), .valid)
    }

    func testRunValidators_EmptyArray_ReturnsIdle() {
        XCTAssertEqual(dsRunValidators("anything", validators: []), .idle)
    }

    func testCustomValidator() {
        let noSpaces = DSCustomValidator { text in
            text.contains(" ") ? .invalid(message: "No spaces allowed.") : .valid
        }
        XCTAssertEqual(noSpaces.validate("hello world"), .invalid(message: "No spaces allowed."))
        XCTAssertEqual(noSpaces.validate("helloworld"), .valid)
    }

    func testValidationResult_Convenience() {
        XCTAssertTrue(DSValidationResult.valid.isValid)
        XCTAssertFalse(DSValidationResult.idle.isValid)
        XCTAssertFalse(DSValidationResult.invalid(message: "err").isValid)
        XCTAssertEqual(DSValidationResult.invalid(message: "err").errorMessage, "err")
        XCTAssertNil(DSValidationResult.valid.errorMessage)
        XCTAssertTrue(DSValidationResult.idle.isPassing)
        XCTAssertFalse(DSValidationResult.invalid(message: "err").isPassing)
    }

    // MARK: - Helpers

    private func assertFieldSnapshot<V: View>(
        _ view: V,
        name: String,
        colorScheme: ColorScheme,
        width: CGFloat = 340,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let themed = view
            .preferredColorScheme(colorScheme)
            .frame(width: width)
            .padding(16)
            .background(Color(.systemBackground))

        let host = UIHostingController(rootView: themed)
        host.overrideUserInterfaceStyle = colorScheme == .dark ? .dark : .light
        host.view.frame = CGRect(
            origin: .zero,
            size: host.view.systemLayoutSizeFitting(
                CGSize(width: width + 32, height: UIView.layoutFittingCompressedSize.height),
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
