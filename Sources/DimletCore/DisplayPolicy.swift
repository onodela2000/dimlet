import Foundation

public struct DisplayDescriptor: Equatable {
    public let id: UInt32
    public let isBuiltIn: Bool
    public let isMirrored: Bool

    public init(id: UInt32, isBuiltIn: Bool, isMirrored: Bool = false) {
        self.id = id
        self.isBuiltIn = isBuiltIn
        self.isMirrored = isMirrored
    }
}

public enum BlackoutMode: String, CaseIterable {
    case externalOnly, allDisplays

    public static func load(from defaults: UserDefaults = .standard) -> BlackoutMode {
        defaults.string(forKey: "blackoutMode").flatMap(BlackoutMode.init(rawValue:)) ?? .externalOnly
    }

    public func save(to defaults: UserDefaults = .standard) {
        defaults.set(rawValue, forKey: "blackoutMode")
    }
}

public enum DisplayPolicy {
    // Mirrored screens share content, so covering one can cover the built-in panel.
    public static func targets(in displays: [DisplayDescriptor], enabled: Bool, mode: BlackoutMode = .externalOnly) -> [UInt32] {
        guard enabled else { return [] }
        return displays.filter { mode == .allDisplays || (!$0.isBuiltIn && !$0.isMirrored) }.map(\.id)
    }
}
