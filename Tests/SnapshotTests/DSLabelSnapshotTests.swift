// DSLabelSnapshotTests.swift
// Rogers iOS Design System
//
// Snapshot and unit tests for DSLabel, DSPageHeader, DSHeroText,
// DSLabelFactory, and the RDSToken.Typography type scale.

import XCTest
import SwiftUI
import SnapshotTesting
@testable import Components
@testable import Tokens

final class DSLabelSnapshotTests: XCTestCase {

    private let record = false

    // MARK: - DSLabel — all typography styles

    func testDSLabel_Display_Light() {
        assertLabelSnapshot(DSLabel("Display 48", style: .display, color: .primary),
                            name: "display_light", colorScheme: .light)
    }

    func testDSLabel_Title3_Brand_Light() {
        assertLabelSnapshot(DSLabel("Sign in", style: .title3, color: .brand),
                            name: "title3_brand_light", colorScheme: .light)
    }

    func testDSLabel_Title3_Brand_Dark() {
        assertLabelSnapshot(DSLabel("Sign in", style: .title3, color: .brand),
                            name: "title3_brand_dark", colorScheme: .dark)
    }

    func testDSLabel_BodyRegular_Primary() {
        assertLabelSnapshot(
            DSLabel("With your My Chatr credentials",
                    style: .bodyRegular, color: .primary),
            name: "body_regular_primary_light", colorScheme: .light
        )
    }

    func testDSLabel_HeroBody_Inverse() {
        assertLabelSnapshot(
            DSLabel(
                "Now you make the call Sign in to manage your account.",
                style: .heroBody, color: .inverse
            )
            .padding()
            .background(Color(RDSToken.Color.buttonPrimaryBackground)),
            name: "hero_body_inverse_light", colorScheme: .light
        )
    }

    func testDSLabel_Caption_Secondary() {
        assertLabelSnapshot(DSLabel("Caption 12pt", style: .caption, color: .secondary),
                            name: "caption_secondary", colorScheme: .light)
    }

    func testDSLabel_Overline_Uppercased() {
        assertLabelSnapshot(DSLabel("featured plan", style: .overline, color: .secondary),
                            name: "overline_uppercased", colorScheme: .light)
    }

    func testDSLabel_Multiline_BodyRegular() {
        assertLabelSnapshot(
            DSLabel(
                "Rogers provides nationwide wireless, internet, and media services " +
                "to millions of Canadians every day.",
                style: .bodyRegular, color: .primary
            ),
            name: "multiline_body_regular", colorScheme: .light, width: 300
        )
    }

    func testDSLabel_NumberOfLines_Truncated() {
        assertLabelSnapshot(
            DSLabel(
                "A very long label that should be truncated after one line " +
                "because numberOfLines is set to 1.",
                style: .bodyRegular, color: .primary,
                numberOfLines: 1
            ),
            name: "truncated_one_line", colorScheme: .light, width: 300
        )
    }

    // MARK: - DSLabel — colour modes

    func testDSLabel_AllColors_Light() {
        let view = VStack(alignment: .leading, spacing: 8) {
            DSLabel("primary",   style: .bodyRegular, color: .primary)
            DSLabel("secondary", style: .bodyRegular, color: .secondary)
            DSLabel("brand",     style: .bodyRegular, color: .brand)
            DSLabel("error",     style: .bodyRegular, color: .error)
            DSLabel("success",   style: .bodyRegular, color: .success)
            DSLabel("warning",   style: .bodyRegular, color: .warning)
            DSLabel("disabled",  style: .bodyRegular, color: .disabled)
        }
        .padding()
        .background(Color(.systemBackground))
        assertLabelSnapshot(view, name: "all_colors_light", colorScheme: .light)
    }

    func testDSLabel_AllColors_Dark() {
        let view = VStack(alignment: .leading, spacing: 8) {
            DSLabel("primary",   style: .bodyRegular, color: .primary)
            DSLabel("secondary", style: .bodyRegular, color: .secondary)
            DSLabel("brand",     style: .bodyRegular, color: .brand)
            DSLabel("error",     style: .bodyRegular, color: .error)
            DSLabel("success",   style: .bodyRegular, color: .success)
        }
        .padding()
        .background(Color(.systemBackground))
        assertLabelSnapshot(view, name: "all_colors_dark", colorScheme: .dark)
    }

    // MARK: - DSPageHeader (Figma node 5:448)

    func testDSPageHeader_TitleAndSubtitle_Light() {
        assertLabelSnapshot(
            DSPageHeader(
                title: "Sign in",
                subtitle: "With your My Chatr credentials"
            ).padding(),
            name: "page_header_title_subtitle_light", colorScheme: .light
        )
    }

    func testDSPageHeader_TitleAndSubtitle_Dark() {
        assertLabelSnapshot(
            DSPageHeader(
                title: "Sign in",
                subtitle: "With your My Chatr credentials"
            ).padding(),
            name: "page_header_title_subtitle_dark", colorScheme: .dark
        )
    }

    func testDSPageHeader_TitleOnly() {
        assertLabelSnapshot(
            DSPageHeader(title: "Manage your account").padding(),
            name: "page_header_title_only", colorScheme: .light
        )
    }

    func testDSPageHeader_CentreAligned() {
        assertLabelSnapshot(
            DSPageHeader(
                title: "Welcome back",
                subtitle: "Chatr wireless",
                alignment: .center
            ).padding(),
            name: "page_header_center", colorScheme: .light
        )
    }

    func testDSPageHeader_InverseOnPurple() {
        let view = ZStack {
            Color(RDSToken.Color.buttonPrimaryBackground)
            DSPageHeader(
                title: "Your Rogers Plan",
                subtitle: "Unlimited everything",
                titleColor: .inverse,
                subtitleColor: .inverse
            )
            .padding()
        }
        .frame(height: 120)
        assertLabelSnapshot(view, name: "page_header_inverse_purple", colorScheme: .light)
    }

    // MARK: - DSHeroText

    func testDSHeroText_OnPurpleBackground() {
        let view = ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(RDSToken.Color.buttonPrimaryBackground))
                .frame(height: 180)
            DSHeroText(
                "Now you make the call\nSign in to manage your account."
            )
            .padding()
        }
        assertLabelSnapshot(view, name: "hero_text_purple_bg", colorScheme: .light)
    }

    func testDSHeroText_OnDarkBackground() {
        let view = ZStack(alignment: .bottomLeading) {
            Color.black.frame(height: 120)
            DSHeroText("Unlimited Canada-wide data.")
                .padding()
        }
        assertLabelSnapshot(view, name: "hero_text_dark_bg", colorScheme: .light)
    }

    // MARK: - Complete type-scale matrix

    func testDSLabel_TypeScale_Matrix() {
        let view = ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Group {
                    DSLabel("Display 48",    style: .display,      color: .primary)
                    DSLabel("Title 1 — 36",  style: .title1,       color: .primary)
                    DSLabel("Title 2 — 32",  style: .title2,       color: .primary)
                    DSLabel("Title 3 — 30",  style: .title3,       color: .brand)
                    DSLabel("Title 4 — 24",  style: .title4,       color: .primary)
                }
                Divider()
                Group {
                    DSLabel("Body Large — 18",   style: .bodyLarge,   color: .primary)
                    DSLabel("Body Regular — 16",  style: .bodyRegular, color: .primary)
                    DSLabel("Body Bold — 16",     style: .bodyBold,    color: .primary)
                    DSLabel("Hero Body — 16/36",  style: .heroBody,    color: .brand)
                    DSLabel("Body Small — 14",    style: .bodySmall,   color: .secondary)
                }
                Divider()
                Group {
                    DSLabel("Caption — 12",       style: .caption,     color: .secondary)
                    DSLabel("Label — 12 Bold",    style: .label,       color: .primary)
                    DSLabel("section header",     style: .overline,    color: .secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        assertLabelSnapshot(view, name: "type_scale_matrix", colorScheme: .light, width: 360)
    }

    // MARK: - DSTextStyle unit tests

    func testDSTextStyle_Title3_Values() {
        let style = RDSToken.Typography.title3
        XCTAssertEqual(style.size, 30)
        XCTAssertEqual(style.lineHeight, 36)
        XCTAssertEqual(style.letterSpacing, 0)
        XCTAssertFalse(style.isUppercased)
        XCTAssertTrue(style.fontName.contains("Bold"))
    }

    func testDSTextStyle_BodyRegular_Values() {
        let style = RDSToken.Typography.bodyRegular
        XCTAssertEqual(style.size, 16)
        XCTAssertEqual(style.lineHeight, 24)
        XCTAssertEqual(style.letterSpacing, 0)
        XCTAssertFalse(style.isUppercased)
        XCTAssertTrue(style.fontName.contains("Medium"))
    }

    func testDSTextStyle_HeroBody_Values() {
        // Validates the UILabel snippet spec: TedNext-Bold 16/36
        let style = RDSToken.Typography.heroBody
        XCTAssertEqual(style.size, 16)
        XCTAssertEqual(style.lineHeight, 36,
                       "heroBody line height must be 36pt per UILabel snippet spec")
        XCTAssertTrue(style.fontName.contains("Bold"))
    }

    func testDSTextStyle_Overline_IsUppercased() {
        XCTAssertTrue(RDSToken.Typography.overline.isUppercased)
        XCTAssertEqual(RDSToken.Typography.overline.letterSpacing, 0.8, accuracy: 0.01)
    }

    func testDSTextStyle_SwiftUILineSpacing_NonNegative() {
        // lineSpacing must never be negative — would compress lines below design intent.
        for style in allStyles {
            XCTAssertGreaterThanOrEqual(
                style.swiftUILineSpacing, 0,
                "Negative lineSpacing for style size=\(style.size)"
            )
        }
    }

    func testDSTextStyle_AttributedString_ParagraphLineHeight() {
        let style   = RDSToken.Typography.heroBody
        let attrStr = style.attributedString("Test", textColor: .white)
        guard let paraStyle = attrStr.attribute(
            .paragraphStyle,
            at: 0,
            effectiveRange: nil
        ) as? NSParagraphStyle else {
            XCTFail("Missing paragraph style"); return
        }
        XCTAssertEqual(paraStyle.minimumLineHeight, style.lineHeight, accuracy: 0.01,
                       "minimumLineHeight must equal DSTextStyle.lineHeight")
        XCTAssertEqual(paraStyle.maximumLineHeight, style.lineHeight, accuracy: 0.01,
                       "maximumLineHeight must equal DSTextStyle.lineHeight")
    }

    func testDSTextStyle_AttributedString_Font() {
        let style   = RDSToken.Typography.title3
        let attrStr = style.attributedString("Test", textColor: .black)
        let font    = attrStr.attribute(.font, at: 0, effectiveRange: nil) as? UIFont
        XCTAssertNotNil(font, "Attributed string must contain a UIFont attribute")
        XCTAssertEqual(font?.pointSize ?? 0, style.scaledUIFont.pointSize, accuracy: 0.5)
    }

    func testDSTextStyle_Overline_Uppercases_Text() {
        let style   = RDSToken.Typography.overline
        let input   = "featured plan"
        let attrStr = style.attributedString(input, textColor: .black)
        XCTAssertEqual(attrStr.string, input.uppercased(),
                       "Overline style must uppercase the string")
    }

    // MARK: - DSTextColor unit tests

    func testDSTextColor_Brand_IsNonClear() {
        // Brand colour must not be clear / transparent in light mode.
        let color = DSTextColor.brand.color
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertGreaterThan(a, 0.9, "Brand text colour must be opaque")
    }

    func testDSTextColor_Inverse_IsWhite() {
        let color = DSTextColor.inverse.uiColor
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 1.0, accuracy: 0.01)
        XCTAssertEqual(g, 1.0, accuracy: 0.01)
        XCTAssertEqual(b, 1.0, accuracy: 0.01)
    }

    // MARK: - DSLabelFactory unit tests

    func testDSLabelFactory_MakeLabel_SetsAttributedText() {
        let label = DSLabelFactory.makeLabel(
            text: "Hello",
            style: RDSToken.Typography.bodyRegular,
            textColor: .primary
        )
        XCTAssertNotNil(label.attributedText, "attributedText must be set")
        XCTAssertEqual(label.numberOfLines, 0)
    }

    func testDSLabelFactory_MakeHeroLabel_MatchesSpec() {
        // Reproduces UILabel snippet validation
        let label = DSLabelFactory.makeHeroLabel(
            text: "Now you make the call Sign in to manage your account."
        )
        guard let paraStyle = label.attributedText?.attribute(
            .paragraphStyle, at: 0, effectiveRange: nil
        ) as? NSParagraphStyle else {
            XCTFail("Missing paragraph style"); return
        }
        XCTAssertEqual(paraStyle.minimumLineHeight, 36, accuracy: 0.01,
                       "Hero label must have 36pt line height")
        XCTAssertEqual(paraStyle.maximumLineHeight, 36, accuracy: 0.01)
        // Text colour must be white (inverse)
        let fgColor = label.attributedText?.attribute(
            .foregroundColor, at: 0, effectiveRange: nil
        ) as? UIColor
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        fgColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 1.0, accuracy: 0.01, "Hero label text must be white")
    }

    func testDSLabelFactory_MakeTitle3_BrandColour() {
        let label = DSLabelFactory.makeTitle3Label(text: "Sign in")
        let fgColor = label.attributedText?.attribute(
            .foregroundColor, at: 0, effectiveRange: nil
        ) as? UIColor
        XCTAssertNotNil(fgColor)
        // Confirm it's the brand purple (not clear or black)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        fgColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertGreaterThan(b, r, "Brand colour should have blue > red component")
        XCTAssertGreaterThan(a, 0.9, "Brand colour must be opaque")
    }

    func testUILabel_ApplyStyle_Extension() {
        let label = UILabel()
        label.text = "Hello"
        label.apply(style: RDSToken.Typography.caption, textColor: .secondary)
        XCTAssertNotNil(label.attributedText)
        XCTAssertEqual(label.numberOfLines, 0)
    }

    // MARK: - Helpers

    private var allStyles: [DSTextStyle] {
        [
            .display, .title1, .title2, .title3, .title4,
            .bodyLarge, .bodyRegular, .bodyBold, .heroBody, .bodySmall,
            .caption, .label, .overline
        ]
    }

    private func assertLabelSnapshot<V: View>(
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
