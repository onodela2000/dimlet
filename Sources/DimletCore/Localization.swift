import Foundation

public enum AppLanguage: String, CaseIterable {
    case english = "en", japanese = "ja", chinese = "zh-Hans", french = "fr", german = "de"

    public var nativeName: String {
        switch self {
        case .english: return "English"
        case .japanese: return "日本語"
        case .chinese: return "简体中文"
        case .french: return "Français"
        case .german: return "Deutsch"
        }
    }

    public static func load(from defaults: UserDefaults = .standard) -> AppLanguage {
        defaults.string(forKey: "appLanguage").flatMap(AppLanguage.init(rawValue:)) ?? .english
    }

    public func save(to defaults: UserDefaults = .standard) {
        defaults.set(rawValue, forKey: "appLanguage")
    }

    public func text(_ key: TextKey) -> String {
        let translation = Self.catalog[key]!
        switch self {
        case .english: return translation.en
        case .japanese: return translation.ja
        case .chinese: return translation.zh
        case .french: return translation.fr
        case .german: return translation.de
        }
    }

    public func about(version: String) -> String {
        text(.aboutBody).replacingOccurrences(of: "{version}", with: version)
    }

    // Named fields keep each language explicit; shared placeholders are checked in tests.
    private static let catalog: [TextKey: (en: String, ja: String, zh: String, fr: String, de: String)] = [
        .externalOnly: ("Darken external monitors only", "外部モニターだけ暗くする", "仅调暗外接显示器", "Assombrir les écrans externes uniquement", "Nur externe Monitore abdunkeln"),
        .allDisplays: ("Darken all monitors (built-in + external)", "すべてのモニターを暗くする（内蔵＋外部）", "调暗所有显示器（内置及外接）", "Assombrir tous les écrans (intégré + externes)", "Alle Monitore abdunkeln (intern + extern)"),
        .language: ("Language", "言語", "语言", "Langue", "Sprache"),
        .about: ("About Dimlet…", "Dimletについて…", "关于 Dimlet…", "À propos de Dimlet…", "Über Dimlet…"),
        .quit: ("Quit Dimlet", "Dimletを終了", "退出 Dimlet", "Quitter Dimlet", "Dimlet beenden"),
        .awake: ("Mac stays awake while Dimlet is open", "起動中はMacの自動スリープを防止", "Dimlet 运行时，Mac 不会自动睡眠", "Le Mac reste éveillé tant que Dimlet est ouvert", "Der Mac bleibt wach, solange Dimlet läuft"),
        .awakeFailed: ("Could not prevent Mac sleep", "Macのスリープ防止を開始できませんでした", "无法阻止 Mac 自动睡眠", "Impossible d’empêcher la veille du Mac", "Der Ruhezustand konnte nicht verhindert werden"),
        .blackoutOn: ("Dimlet · Blackout ON", "Dimlet · 暗くする：ON", "Dimlet · 黑屏已开启", "Dimlet · Masquage activé", "Dimlet · Abdunklung AN"),
        .blackoutOff: ("Dimlet · Blackout OFF", "Dimlet · 暗くする：OFF", "Dimlet · 黑屏已关闭", "Dimlet · Masquage désactivé", "Dimlet · Abdunklung AUS"),
        .reveal: ("Click to restore all screens", "クリックするとすべての画面が戻ります", "点击以恢复所有屏幕", "Cliquez pour réafficher tous les écrans", "Klicken, um alle Bildschirme wieder anzuzeigen"),
        .done: ("Done", "閉じる", "关闭", "Fermer", "Schließen"),
        .aboutBody: (
            "Screens rest. Your Mac keeps going.\n\nVersion {version} · Free & open source\nBlack overlays, not monitor power-off.\nNo account. No tracking. No network access.",
            "画面は静かに。Macは、そのまま。\n\nバージョン {version} · 無料・オープンソース\n電源OFFではなく、画面を黒く覆います。\nアカウント・追跡・ネットワーク通信なし。",
            "屏幕休息，Mac 继续工作。\n\n版本 {version} · 免费开源\n用黑色窗口覆盖屏幕，不关闭显示器电源。\n无需账号，无追踪，无网络通信。",
            "Les écrans se reposent. Votre Mac continue.\n\nVersion {version} · Gratuit et open source\nDes fenêtres noires recouvrent les écrans sans les éteindre.\nSans compte, sans suivi, sans accès réseau.",
            "Die Bildschirme ruhen. Dein Mac macht weiter.\n\nVersion {version} · Kostenlos und Open Source\nSchwarze Fenster verdecken die Bildschirme, ohne sie auszuschalten.\nKein Konto. Kein Tracking. Kein Netzwerkzugriff."
        )
    ]
}

public enum TextKey: CaseIterable {
    case externalOnly, allDisplays, language, about, quit, awake, awakeFailed, blackoutOn, blackoutOff
    case reveal, done, aboutBody
}
