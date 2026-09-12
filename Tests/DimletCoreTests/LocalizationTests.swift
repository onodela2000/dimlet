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
            for count in [0, 1, 2, 10] {
                let label = language.displayCount(count)
                XCTAssertTrue(label.contains(String(count)), "Missing count in \(language)")
                XCTAssertFalse(label.contains("{"), "Unresolved placeholder in \(language)")
            }
            XCTAssertTrue(language.about(version: "9.8.7").contains("9.8.7"))
            XCTAssertFalse(language.about(version: "9.8.7").contains("{"))
            XCTAssertNotEqual(language.text(.blackoutOn), language.text(.blackoutOff))
        }
        XCTAssertEqual(Set(AppLanguage.allCases.map(\.nativeName)).count, 5)
        XCTAssertEqual(AppLanguage.english.displayCount(1), "1 external display · built-in untouched")
        XCTAssertEqual(AppLanguage.english.displayCount(2), "2 external displays · built-in untouched")
    }
}
