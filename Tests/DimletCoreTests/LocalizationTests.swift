import Foundation
import XCTest
@testable import DimletCore

final class LocalizationTests: XCTestCase {
    func testFirstLaunchAndUnknownPreferenceUseEnglish() {
        let name = "DimletTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: name)!
        defer { defaults.removePersistentDomain(forName: name) }
        XCTAssertEqual(AppLanguage.load(from: defaults), .english)
        defaults.set("unsupported", forKey: "appLanguage")
        XCTAssertEqual(AppLanguage.load(from: defaults), .english)
    }

    func testEveryLanguageSurvivesPreferenceReload() {
        let name = "DimletTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: name)!
        defer { defaults.removePersistentDomain(forName: name) }
        for language in AppLanguage.allCases {
            language.save(to: defaults)
            XCTAssertEqual(AppLanguage.load(from: UserDefaults(suiteName: name)!), language)
        }
    }

    func testEveryLanguageHasCompleteCopyAndValidPlaceholders() {
        for language in AppLanguage.allCases {
            for key in TextKey.allCases {
                XCTAssertFalse(language.text(key).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            XCTAssertTrue(language.about(version: "9.8.7").contains("9.8.7"))
            XCTAssertFalse(language.about(version: "9.8.7").contains("{"))
            XCTAssertNotEqual(language.text(.blackoutOn), language.text(.blackoutOff))
        }
        XCTAssertEqual(Set(AppLanguage.allCases.map(\.nativeName)).count, 5)
    }
}
