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

public enum DisplayPolicy {
    // Mirrored screens share content, so covering one can cover the built-in panel.
    public static func targets(in displays: [DisplayDescriptor], enabled: Bool) -> [UInt32] {
        guard enabled else { return [] }
        return displays.filter { !$0.isBuiltIn && !$0.isMirrored }.map(\.id)
    }
}
