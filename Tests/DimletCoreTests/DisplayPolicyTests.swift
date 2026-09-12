import XCTest
@testable import DimletCore

final class DisplayPolicyTests: XCTestCase {
    func testBuiltInIsProtectedEvenWhenExternalIsMain() {
        let displays = [DisplayDescriptor(id: 7, isBuiltIn: false), DisplayDescriptor(id: 1, isBuiltIn: true)]
        XCTAssertEqual(DisplayPolicy.targets(in: displays, enabled: true), [7])
    }
    func testOffDoesNotCoverAnyScreen() {
        XCTAssertEqual(DisplayPolicy.targets(in: [.init(id: 7, isBuiltIn: false)], enabled: false), [])
    }
    func testHotPlugAndRemovalUseTheCurrentScreens() {
        let internalScreen = DisplayDescriptor(id: 1, isBuiltIn: true)
        let first = DisplayDescriptor(id: 2, isBuiltIn: false)
        let second = DisplayDescriptor(id: 3, isBuiltIn: false)
        XCTAssertEqual(DisplayPolicy.targets(in: [internalScreen, first], enabled: true), [2])
        XCTAssertEqual(DisplayPolicy.targets(in: [internalScreen, first, second], enabled: true), [2, 3])
        XCTAssertEqual(DisplayPolicy.targets(in: [internalScreen, second], enabled: true), [3])
    }
    func testMirroredScreensAreSkipped() {
        let screens: [DisplayDescriptor] = [.init(id: 1, isBuiltIn: true), .init(id: 2, isBuiltIn: false, isMirrored: true)]
        XCTAssertEqual(DisplayPolicy.targets(in: screens, enabled: true), [])
    }
    func testDesktopMacCanCoverAllScreens() {
        XCTAssertEqual(DisplayPolicy.targets(in: [.init(id: 2, isBuiltIn: false), .init(id: 3, isBuiltIn: false)], enabled: true), [2, 3])
    }
    func testAllModeIncludesBuiltInAndMirroredScreens() {
        let screens: [DisplayDescriptor] = [
            .init(id: 1, isBuiltIn: true, isMirrored: true),
            .init(id: 2, isBuiltIn: false, isMirrored: true),
            .init(id: 3, isBuiltIn: false)
        ]
        XCTAssertEqual(DisplayPolicy.targets(in: screens, enabled: true, mode: .allDisplays), [1, 2, 3])
        XCTAssertEqual(DisplayPolicy.targets(in: screens, enabled: true, mode: .externalOnly), [3])
        XCTAssertEqual(DisplayPolicy.targets(in: screens, enabled: false, mode: .allDisplays), [])
    }

    func testBuiltInOnlySetupAndDisconnect() {
        let laptop = DisplayDescriptor(id: 1, isBuiltIn: true)
        XCTAssertEqual(DisplayPolicy.targets(in: [laptop], enabled: true, mode: .allDisplays), [1])
        XCTAssertEqual(DisplayPolicy.targets(in: [laptop], enabled: true, mode: .externalOnly), [])
        XCTAssertEqual(DisplayPolicy.targets(in: [], enabled: true, mode: .allDisplays), [])
    }

    func testModePreferenceDefaultsAndPersistence() {
        let name = "DimletTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: name)!
        defer { defaults.removePersistentDomain(forName: name) }
        XCTAssertEqual(BlackoutMode.load(from: defaults), .externalOnly)
        for mode in BlackoutMode.allCases {
            mode.save(to: defaults)
            XCTAssertEqual(BlackoutMode.load(from: UserDefaults(suiteName: name)!), mode)
        }
        defaults.set("unknown", forKey: "blackoutMode")
        XCTAssertEqual(BlackoutMode.load(from: defaults), .externalOnly)
    }

}
