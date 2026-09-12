#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."

VERSION="$(cat VERSION)"
OUTPUT="dist"
APP="$OUTPUT/Dimlet.app"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" .build/module-cache

if [[ "${1:-}" == "--universal" ]]; then
  ARCHS=(arm64 x86_64)
  FLAVOR="universal"
else
  ARCHS=("$(uname -m)")
  FLAVOR="${ARCHS[0]}"
fi

BINARIES=()
for ARCH in "${ARCHS[@]}"; do
  SCRATCH=".build/release-$ARCH"
  swift build -c release --arch "$ARCH" --scratch-path "$SCRATCH" \
    -Xswiftc -debug-prefix-map -Xswiftc "$PWD=." --product Dimlet
  BIN_DIR="$(swift build -c release --arch "$ARCH" --scratch-path "$SCRATCH" --show-bin-path)"
  BINARIES+=("$BIN_DIR/Dimlet")
done

if [[ ${#BINARIES[@]} -gt 1 ]]; then
  lipo -create "${BINARIES[@]}" -output "$APP/Contents/MacOS/Dimlet"
else
  cp "${BINARIES[0]}" "$APP/Contents/MacOS/Dimlet"
fi
strip -S "$APP/Contents/MacOS/Dimlet"
cp Resources/*.svg "$APP/Contents/Resources/"
cp assets/icon.svg "$APP/Contents/Resources/icon.svg"
swift -module-cache-path .build/module-cache scripts/render-icon.swift assets/icon.svg .build/Dimlet.iconset
iconutil -c icns .build/Dimlet.iconset -o "$APP/Contents/Resources/AppIcon.icns"

cat > "$APP/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>Dimlet</string>
<key>CFBundleIdentifier</key><string>io.github.onodela2000.dimlet</string>
<key>CFBundleName</key><string>Dimlet</string>
<key>CFBundleDisplayName</key><string>Dimlet</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>CFBundleShortVersionString</key><string>$VERSION</string>
<key>CFBundleVersion</key><string>$VERSION</string>
<key>CFBundleIconFile</key><string>AppIcon</string>
<key>LSMinimumSystemVersion</key><string>13.0</string>
<key>LSMultipleInstancesProhibited</key><true/>
<key>LSUIElement</key><true/>
<key>NSHighResolutionCapable</key><true/>
<key>NSPrincipalClass</key><string>NSApplication</string>
</dict></plist>
PLIST
plutil -lint "$APP/Contents/Info.plist"
# Ad-hoc signing preserves bundle integrity; this is not Developer ID signing or notarization.
codesign --force --sign - "$APP"
codesign --verify --deep --strict "$APP"
ARCHIVE="$OUTPUT/Dimlet-$VERSION-macos-$FLAVOR.zip"
ditto -c -k --keepParent "$APP" "$ARCHIVE"
(cd "$OUTPUT" && shasum -a 256 "$(basename "$ARCHIVE")" > "$(basename "$ARCHIVE").sha256")
printf '\nBuilt %s\n' "$ARCHIVE"
