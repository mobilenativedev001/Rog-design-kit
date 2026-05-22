// DSPromoBannerSnapshotTests.swift
// Rogers iOS Design System
//
// Snapshot + unit tests for DSPromoBanner, DSPromoBannerConfiguration,
// DSPromoBannerVariant, and DSPromoBannerView.

import XCTest
import SwiftUI
import SnapshotTesting
@testable import Components
@testable import Tokens

final class DSPromoBannerSnapshotTests: XCTestCase {

    private let record = false

    // MARK: - Figma node 128:60 — exact reproduction

    func testPromoBanner_Figma128_60_Light() {
        // Exact spec from pixel analysis:
        //   width=244pt, height=33pt, bg=#55228A, white text "Special Offer for you"
        assertBannerSnapshot(
            DSPromoBanner(text: "Special Offer for you"),
            name: "figma_128_60_light",
            colorScheme: .light,
            width: 244
        )
    }

    func testPromoBanner_Figma128_60_Dark() {
        assertBannerSnapshot(
            DSPromoBanner(text: "Special Offer for you"),
            name: "figma_128_60_dark",
            colorScheme: .dark,
            width: 244
        )
    }

    // MARK: - Variants (light)

    func testPromoBanner_Offer_Light() {
        assertBannerSnapshot(
            DSPromoBanner(configuration: .specialOffer()),
            name: "variant_offer_light",
            colorScheme: .light
        )
    }

    func testPromoBanner_Success_Light() {
        assertBannerSnapshot(
            DSPromoBanner(configuration: .successBanner(text: "Your plan has been updated")),
            name: "variant_success_light",
            colorScheme: .light
        )
    }

    func testPromoBanner_Warning_Light() {
        assertBannerSnapshot(
            DSPromoBanner(configuration: .warningBanner(text: "Payment due in 3 days")),
            name: "variant_warning_light",
            colorScheme: .light
        )
    }

    func testPromoBanner_Info_Light() {
        assertBannerSnapshot(
            DSPromoBanner(configuration: .infoBanner(text: "New features available")),
            name: "variant_info_light",
            colorScheme: .light
        )
    }

    // MARK: - Variants (dark)

    func testPromoBanner_AllVariants_Dark() {
        let view = VStack(spacing: 0) {
            DSPromoBanner(configuration: .specialOffer())
            DSPromoBanner(configuration: .successBanner(text: "Your plan has been updated"))
            DSPromoBanner(configuration: .warningBanner(text: "Payment due in 3 days"))
            DSPromoBanner(configuration: .infoBanner(text: "New features available"))
        }
        assertBannerSnapshot(view, name: "all_variants_dark", colorScheme: .dark)
    }

    // MARK: - Icon variations

    func testPromoBanner_NoIcon() {
        assertBannerSnapshot(
            DSPromoBanner(text: "Special Offer for you", iconName: nil),
            name: "no_icon",
            colorScheme: .light
        )
    }

    func testPromoBanner_StarIcon() {
        assertBannerSnapshot(
            DSPromoBanner(text: "Best Value", iconName: "star.fill"),
            name: "star_icon",
            colorScheme: .light
        )
    }

    func testPromoBanner_SparklesIcon() {
        assertBannerSnapshot(
            DSPromoBanner(text: "Limited Time Offer", iconName: "sparkles"),
            name: "sparkles_icon",
            colorScheme: .light
        )
    }

    func testPromoBanner_GiftIcon() {
        assertBannerSnapshot(
            DSPromoBanner(text: "Free gift with plan", iconName: "gift.fill"),
            name: "gift_icon",
            colorScheme: .light
        )
    }

    // MARK: - Custom variant

    func testPromoBanner_CustomVariant() {
        assertBannerSnapshot(
            DSPromoBanner(
                text: "Flash Deal — 24 hours only",
                iconName: "flame.fill",
                variant: .custom(
                    background: Color(red: 0.85, green: 0.15, blue: 0.1),
                    foreground: .white
                )
            ),
            name: "custom_variant",
            colorScheme: .light
        )
    }

    // MARK: - Dynamic Type

    func testPromoBanner_DynamicType_Large() {
        assertBannerSnapshot(
            DSPromoBanner(text: "Special Offer for you"),
            name: "dynamic_type_large",
            colorScheme: .light,
            sizeCategory: .large
        )
    }

    func testPromoBanner_DynamicType_AccessibilityXXL() {
        assertBannerSnapshot(
            DSPromoBanner(text: "Special Offer for you"),
            name: "dynamic_type_axl",
            colorScheme: .light,
            sizeCategory: .accessibilityExtraExtraLarge
        )
    }

    // MARK: - Full-width context

    func testPromoBanner_FullWidth_iPhone14() {
        assertBannerSnapshot(
            DSPromoBanner(text: "Special Offer for you"),
            name: "full_width_iphone14",
            colorScheme: .light,
            width: 390
        )
    }

    // MARK: - In-context plan card

    func testPromoBanner_InContext_PlanCard_Light() {
        let card = VStack(spacing: 0) {
            DSPromoBanner(text: "Special Offer for you")
            VStack(alignment: .leading, spacing: 12) {
                DSLabel("Rogers Infinite+",
                        style: RDSToken.Typography.title4,
                        color: .primary)
                DSLabel("$55/month • Unlimited Canada-wide data",
                        style: RDSToken.Typography.bodyRegular,
                        color: .secondary)
                DSButton(title: "Get this plan", variant: .primary, size: .medium) {}
            }
            .padding()
            .background(Color(RDSToken.Color.surface))
        }
        .background(Color(RDSToken.Color.surface))
        .cornerRadius(12)
        .padding()

        assertBannerSnapshot(card, name: "in_context_plan_card_light", colorScheme: .light, width: 360)
    }

    func testPromoBanner_InContext_PlanCard_Dark() {
        let card = VStack(spacing: 0) {
            DSPromoBanner(text: "Special Offer for you")
            VStack(alignment: .leading, spacing: 12) {
                DSLabel("Rogers Infinite+",
                        style: RDSToken.Typography.title4,
                        color: .primary)
                DSLabel("$55/month • Unlimited Canada-wide data",
                        style: RDSToken.Typography.bodyRegular,
                        color: .secondary)
                DSButton(title: "Get this plan", variant: .primary, size: .medium) {}
            }
            .padding()
            .background(Color(RDSToken.Color.surface))
        }
        .background(Color(RDSToken.Color.surface))
        .cornerRadius(12)
        .padding()

        assertBannerSnapshot(card, name: "in_context_plan_card_dark", colorScheme: .dark, width: 360)
    }

    // MARK: - Unit tests: DSPromoBannerConfiguration

    func testConfiguration_DefaultValues() {
        let config = DSPromoBannerConfiguration(text: "Test")
        XCTAssertEqual(config.text, "Test")
        XCTAssertEqual(config.iconName, "tag.fill")
        XCTAssertEqual(config.variant, .offer)
        XCTAssertEqual(config.minHeight, 33)
        XCTAssertEqual(config.horizontalPadding, 10)
        XCTAssertEqual(config.iconTextSpacing, 6)
    }

    func testConfiguration_SpecialOfferPreset() {
        let config = DSPromoBannerConfiguration.specialOffer()
        XCTAssertEqual(config.text, "Special Offer for you")
        XCTAssertEqual(config.iconName, "tag.fill")
        XCTAssertEqual(config.variant, .offer)
    }

    func testConfiguration_SpecialOfferPreset_CustomText() {
        let config = DSPromoBannerConfiguration.specialOffer(text: "Best Plan for You")
        XCTAssertEqual(config.text, "Best Plan for You")
    }

    func testConfiguration_SuccessPreset() {
        let config = DSPromoBannerConfiguration.successBanner(text: "Done")
        XCTAssertEqual(config.variant, .success)
        XCTAssertEqual(config.iconName, "checkmark.circle.fill")
    }

    func testConfiguration_WarningPreset() {
        let config = DSPromoBannerConfiguration.warningBanner(text: "Warning")
        XCTAssertEqual(config.variant, .warning)
        XCTAssertEqual(config.iconName, "exclamationmark.triangle.fill")
    }

    func testConfiguration_InfoPreset() {
        let config = DSPromoBannerConfiguration.infoBanner(text: "Info")
        XCTAssertEqual(config.variant, .info)
        XCTAssertEqual(config.iconName, "info.circle.fill")
    }

    func testConfiguration_NoIcon() {
        let config = DSPromoBannerConfiguration(text: "No icon", iconName: nil)
        XCTAssertNil(config.iconName)
    }

    // MARK: - Unit tests: DSPromoBannerVariant

    func testVariant_Equality_SameVariants() {
        XCTAssertEqual(DSPromoBannerVariant.offer, .offer)
        XCTAssertEqual(DSPromoBannerVariant.success, .success)
        XCTAssertEqual(DSPromoBannerVariant.warning, .warning)
        XCTAssertEqual(DSPromoBannerVariant.info, .info)
    }

    func testVariant_Equality_DifferentVariants() {
        XCTAssertNotEqual(DSPromoBannerVariant.offer, .success)
        XCTAssertNotEqual(DSPromoBannerVariant.success, .warning)
        XCTAssertNotEqual(DSPromoBannerVariant.info, .offer)
    }

    func testVariant_Custom_Equality() {
        let v1 = DSPromoBannerVariant.custom(background: .red, foreground: .white)
        let v2 = DSPromoBannerVariant.custom(background: .red, foreground: .white)
        let v3 = DSPromoBannerVariant.custom(background: .blue, foreground: .white)
        XCTAssertEqual(v1, v2)
        XCTAssertNotEqual(v1, v3)
    }

    func testVariant_Offer_BackgroundColor_IsNonTransparent() {
        let variant = DSPromoBannerVariant.offer
        // Background color should exist and be opaque (non-clear)
        let uiColor = UIColor(variant.backgroundColor)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertGreaterThan(a, 0.9, "Offer banner background must be opaque")
        // Should be a purple color (blue > red component is wrong for our purple, but alpha is right)
        XCTAssertGreaterThan(b, g, "Offer banner background should be bluish-purple")
    }

    func testVariant_Offer_ForegroundColor_IsWhite() {
        let variant = DSPromoBannerVariant.offer
        let uiColor = UIColor(variant.foregroundColor)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 1.0, accuracy: 0.05, "Offer banner foreground must be white")
        XCTAssertEqual(g, 1.0, accuracy: 0.05)
        XCTAssertEqual(b, 1.0, accuracy: 0.05)
    }

    // MARK: - Unit tests: promoBannerBackground token

    func testToken_PromoBannerBackground_MatchesFigmaPixel() {
        // Pixel analysis of node 128:60 shows dominant color #55228A
        let expected = UIColor(hex: "#55228A")
        let token    = RDSToken.Color.promoBannerBackground

        // Resolve in light mode
        let traitLight = UITraitCollection(userInterfaceStyle: .light)
        let resolved   = token.resolvedColor(with: traitLight)

        var eR: CGFloat = 0, eG: CGFloat = 0, eB: CGFloat = 0, eA: CGFloat = 0
        var rR: CGFloat = 0, rG: CGFloat = 0, rB: CGFloat = 0, rA: CGFloat = 0
        expected.getRed(&eR, green: &eG, blue: &eB, alpha: &eA)
        resolved.getRed(&rR, green: &rG, blue: &rB, alpha: &rA)

        XCTAssertEqual(rR, eR, accuracy: 0.01, "Red channel mismatch vs Figma #55228A")
        XCTAssertEqual(rG, eG, accuracy: 0.01, "Green channel mismatch vs Figma #55228A")
        XCTAssertEqual(rB, eB, accuracy: 0.01, "Blue channel mismatch vs Figma #55228A")
    }

    func testToken_PromoBannerForeground_IsWhite() {
        let token   = RDSToken.Color.promoBannerForeground
        let trait   = UITraitCollection(userInterfaceStyle: .light)
        let resolved = token.resolvedColor(with: trait)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        resolved.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 1.0, accuracy: 0.01, "Promo banner foreground must be white")
        XCTAssertEqual(g, 1.0, accuracy: 0.01)
        XCTAssertEqual(b, 1.0, accuracy: 0.01)
    }

    // MARK: - UIKit factory unit tests

    func testFactory_MakeOfferBanner_DefaultText() {
        let view = DSPromoBannerFactory.makeOfferBanner()
        XCTAssertEqual(view.configuration.text, "Special Offer for you")
        XCTAssertEqual(view.configuration.variant, .offer)
    }

    func testFactory_MakeOfferBanner_CustomText() {
        let view = DSPromoBannerFactory.makeOfferBanner(text: "Get 3 months free")
        XCTAssertEqual(view.configuration.text, "Get 3 months free")
    }

    func testFactory_MakeSuccessBanner() {
        let view = DSPromoBannerFactory.makeSuccessBanner(text: "Payment confirmed")
        XCTAssertEqual(view.configuration.variant, .success)
        XCTAssertEqual(view.configuration.text, "Payment confirmed")
    }

    func testFactory_MakeWarningBanner() {
        let view = DSPromoBannerFactory.makeWarningBanner(text: "Card expiring soon")
        XCTAssertEqual(view.configuration.variant, .warning)
    }

    func testFactory_MakeInfoBanner() {
        let view = DSPromoBannerFactory.makeInfoBanner(text: "System maintenance tonight")
        XCTAssertEqual(view.configuration.variant, .info)
    }

    func testFactory_MakeTextOnlyBanner_NoIcon() {
        let view = DSPromoBannerFactory.makeTextOnlyBanner(text: "Promo text", variant: .offer)
        XCTAssertNil(view.configuration.iconName)
        XCTAssertEqual(view.configuration.variant, .offer)
    }

    func testFactory_UpdateConfiguration() {
        let view = DSPromoBannerFactory.makeOfferBanner(text: "Initial text")
        view.configuration = .successBanner(text: "Updated text")
        XCTAssertEqual(view.configuration.text, "Updated text")
        XCTAssertEqual(view.configuration.variant, .success)
    }

    // MARK: - Helpers

    private func assertBannerSnapshot<V: View>(
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
