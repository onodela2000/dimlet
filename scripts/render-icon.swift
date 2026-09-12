import AppKit
import Foundation

guard CommandLine.arguments.count == 3 else { fatalError("Usage: render-icon.swift input.svg output.iconset") }
guard let image = NSImage(contentsOfFile: CommandLine.arguments[1]) else { fatalError("Cannot decode the SVG icon") }
let directory = URL(fileURLWithPath: CommandLine.arguments[2])
try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
for points in [16, 32, 128, 256, 512] {
    for scale in [1, 2] {
        let pixels = points * scale
        guard let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0) else { fatalError("Cannot allocate icon") }
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
        NSGraphicsContext.current?.imageInterpolation = .high
        image.draw(in: NSRect(x: 0, y: 0, width: pixels, height: pixels))
        NSGraphicsContext.restoreGraphicsState()
        let suffix = scale == 2 ? "@2x" : ""
        let file = directory.appendingPathComponent("icon_\(points)x\(points)\(suffix).png")
        guard let png = bitmap.representation(using: .png, properties: [:]) else { fatalError("Cannot encode icon") }
        try png.write(to: file)
    }
}
