'use strict';
const translations = {
  ja: {
    navHow:'使い方',eyebrow:'MACのメニューバーに、小さなひと工夫',headline1:'画面は静かに。',headline2:'Macは、そのまま。',intro:'部屋の明かりを落としても、作業は続く。Dimletは外部モニターを黒く覆い、Macの自動スリープを防ぎます。',download:'Mac版をダウンロード',source:'ソースを見てみる ↗',compat:'無料・オープンソース · macOS 13以降 · Apple Silicon / Intel',desk:'いつものデスクを、少し静かに',live:'さわって試せるデモ',toggleTitle:'外部モニターを暗くする',statusOff:'画面は通常表示。スイッチを試してみて。',statusOn:'外部画面はひと休み。Macは作業中。',demoNote:'これはプレビューです。実際の画面は変わりません。',feature1Title:'光を減らして、作業はそのまま。',feature1:'AIエージェント、長いビルド、夜通しのレンダリング。作業を任せて、部屋を少し穏やかに。',feature2Title:'つながったまま。',feature2:'モニターの電源と接続を保ち、USB-C給電の継続を助けます。内蔵画面はいつもどおり使えます。',feature3Title:'必要なものだけ、小さく。',feature3:'Swift製、5言語対応。アカウント、追跡、サブスク、追加の権限は不要です。',howEyebrow:'すぐに、いつもの場所へ',howTitle:'小さなアプリで。\n落ち着く作業空間に。',guide:'導入ガイドを読む',step1Title:'メニューバーに、おじゃまします。',step1:'ZIPをダウンロードして展開し、Dimletをアプリケーションフォルダへ。起動すると、小さなモニターが現れます。',step2Title:'画面に、ひと休みを。',step2:'メニューバーのモニターをクリックし、黒表示をONに。独立した外部画面が、まとめて暗くなります。',step3Title:'戻るのは、いつでも。',step3:'黒い画面をクリックすれば、すべて元どおり。アプリを終了するまで、Macの自動スリープ防止は続きます。',faqEyebrow:'知っておきたいこと',faqTitle:'もう少しだけ、詳しく。',q1:'モニターの電源を切るのですか？',a1:'電源は切らず、外部画面を黒いウインドウで覆います。本体の電源はONにしてください。省電力やLCDのバックライト消灯は保証しません。USB-C給電の継続は機器の仕様にも依存します。',q2:'MacBookのフタは閉じてもいい？',a2:'フタは開けたまま使ってください。起動中の自動スリープを防ぎますが、フタを閉じたときや手動スリープ、電源OFF、バッテリー切れには対応しません。',q3:'設定や権限は必要ですか？',a3:'動作にアクセシビリティ・画面収録・管理者権限は不要です。現在はApple未公証のため、初回起動時に「システム設定 → プライバシーとセキュリティ → このまま開く」が必要な場合があります。詳細は導入ガイドをご覧ください。',q4:'自分の環境でも使えますか？',a4:'macOS 13以降の拡張デスクトップに対応し、ミラーリング中の画面は対象外です。M4 MacBook Airで実機確認済み。Intelや以前のmacOSでは、さらなる検証を歓迎します。アプリは英語・日本語・簡体字中国語・フランス語・ドイツ語に対応しています。',closing:'光を、少し控えて。\n作業は、心地よく。',closingNote:'使うのも、手を加えるのも、自由。',footer:'まだ続く作業の、そばに。'
  },
  'zh-Hans': {
    navHow:'使用方法',eyebrow:'MAC 菜单栏里的小小魔法',headline1:'屏幕休息。',headline2:'Mac 继续工作。',intro:'让房间安静下来，让工作继续。Dimlet 用黑色窗口覆盖外接屏幕，并防止 Mac 自动睡眠。',download:'下载 Mac 版',source:'查看源代码 ↗',compat:'免费开源 · macOS 13 及以上 · Apple Silicon / Intel',desk:'让桌面，更安静一点',live:'交互演示',toggleTitle:'将外接显示器设为黑屏',statusOff:'屏幕正常显示。试试这个开关。',statusOn:'外接屏幕休息了，Mac 仍在工作。',demoNote:'仅为演示，不会改变您的实际屏幕。',feature1Title:'少一点光，工作照常。',feature1:'AI 智能体、长时间构建、整夜渲染。让任务继续，让房间更舒适。',feature2Title:'保持连接。',feature2:'显示器保持通电和连接，让 USB-C 充电可以继续。内置屏幕照常使用。',feature3Title:'小巧，恰到好处。',feature3:'原生 Swift，支持五种语言。无需账号、追踪、订阅或额外权限。',howEyebrow:'几步即可开始',howTitle:'一个小应用。\n一处安静的工作空间。',guide:'阅读安装指南',step1Title:'给它留个小位置。',step1:'下载并解压 ZIP，将 Dimlet 移到应用程序文件夹。打开它，在菜单栏认识这位新朋友。',step2Title:'让屏幕休息一下。',step2:'点击菜单栏的小显示器，开启黑屏。所有独立的外接屏幕都会变黑。',step3Title:'随时回来。',step3:'点击任意黑色屏幕即可恢复所有外接屏幕。在您退出应用之前，Dimlet 会持续防止 Mac 自动睡眠。',faqEyebrow:'一些小细节',faqTitle:'使用前了解一下。',q1:'它真的会关闭显示器吗？',a1:'不会。Dimlet 用黑色窗口覆盖外接屏幕。请保持显示器电源开启。它不保证节能或完全关闭 LCD 背光。USB-C 充电取决于硬件。',q2:'可以合上 MacBook 吗？',a2:'请保持屏幕盖打开。Dimlet 运行时可防止自动睡眠，但无法阻止合盖睡眠、手动睡眠、关机或电量耗尽。',q3:'需要设置或授予权限吗？',a3:'运行时无需辅助功能、屏幕录制或管理员权限。当前版本尚未经过 Apple 公证，首次启动可能需要在系统设置 → 隐私与安全性中选择仍要打开。详见安装指南。',q4:'适合我的设备吗？',a4:'支持 macOS 13 及以上版本的独立扩展屏幕，跳过镜像屏幕。已在 M4 MacBook Air 上测试；Intel 和较早的 macOS 版本仍需更多实机验证。应用支持英语、日语、简体中文、法语和德语。',closing:'少一点光。\n多一份专注。',closingNote:'自由使用，自由修改。',footer:'陪伴那些仍在进行的工作。'
  },
  fr: {
    navHow:'Mode d’emploi',eyebrow:'UN PEU DE MAGIE DANS LA BARRE DES MENUS',headline1:'Les écrans se reposent.',headline2:'Votre Mac continue.',intro:'La pièce s’apaise, le travail avance. Dimlet masque vos écrans externes avec des fenêtres noires et empêche la mise en veille automatique du Mac.',download:'Télécharger pour Mac',source:'Voir le code source ↗',compat:'Gratuit et open source · macOS 13+ · Apple Silicon et Intel',desk:'VOTRE BUREAU, UN PEU PLUS CALME',live:'Démo interactive',toggleTitle:'Masquer les écrans externes',statusOff:'Les écrans sont visibles. Essayez l’interrupteur.',statusOn:'Les écrans se reposent. Le Mac travaille.',demoNote:'Un simple aperçu. Vos vrais écrans ne changent pas.',feature1Title:'Moins de lumière. Le même élan.',feature1:'Agents IA, longues compilations, rendus nocturnes. Laissez les tâches avancer dans une pièce plus calme.',feature2Title:'Gardez la connexion.',feature2:'Les écrans restent alimentés et connectés pour permettre la charge USB-C. L’écran intégré reste disponible.',feature3Title:'Petit, comme il faut.',feature3:'Swift natif. Cinq langues. Sans compte, suivi, abonnement ni permissions supplémentaires.',howEyebrow:'PRÊT EN QUELQUES INSTANTS',howTitle:'Une petite app.\nUn espace plus paisible.',guide:'Lire le guide d’installation',step1Title:'Faites-lui une petite place.',step1:'Téléchargez le ZIP, décompressez-le et glissez Dimlet dans Applications. Ouvrez l’app pour retrouver votre nouvel ami dans la barre des menus.',step2Title:'Offrez une pause aux écrans.',step2:'Cliquez sur le petit écran dans la barre des menus, puis activez le masquage. Tous les écrans externes indépendants deviennent noirs.',step3Title:'Revenez quand vous voulez.',step3:'Cliquez sur un écran noir pour tous les réafficher. Dimlet garde le Mac éveillé jusqu’à ce que vous quittiez l’app.',faqEyebrow:'LES PETITS DÉTAILS',faqTitle:'Bon à savoir.',q1:'Est-ce que mes écrans s’éteignent vraiment ?',a1:'Non. Dimlet recouvre les écrans externes de fenêtres noires. Laissez les moniteurs allumés. Il ne garantit ni économie d’énergie ni extinction du rétroéclairage LCD. La charge USB-C dépend de votre matériel.',q2:'Puis-je fermer mon MacBook ?',a2:'Gardez le capot ouvert. Dimlet empêche la veille automatique pendant son fonctionnement, mais pas la veille à la fermeture du capot, la veille manuelle, l’arrêt ou une batterie vide.',q3:'Faut-il des réglages ou des permissions ?',a3:'Aucune permission d’accessibilité, d’enregistrement d’écran ou d’administration n’est nécessaire. La version actuelle n’est pas notariée par Apple : au premier lancement, il peut être nécessaire d’utiliser Réglages Système → Confidentialité et sécurité → Ouvrir quand même. Consultez le guide d’installation.',q4:'Est-ce compatible avec mon équipement ?',a4:'Dimlet prend en charge macOS 13+ et les écrans indépendants en bureau étendu. Les écrans en miroir sont exclus. Testé sur MacBook Air M4 ; les Mac Intel et les anciennes versions de macOS nécessitent davantage de tests réels. L’app propose l’anglais, le japonais, le chinois simplifié, le français et l’allemand.',closing:'Un peu moins de lumière.\nUn peu plus de sérénité.',closingNote:'Libre de l’utiliser. Libre de le modifier.',footer:'Pour le travail qui continue.'
  },
  de: {
    navHow:'So funktioniert’s',eyebrow:'EIN BISSCHEN MAGIE FÜR DIE MAC-MENÜLEISTE',headline1:'Die Bildschirme ruhen.',headline2:'Dein Mac macht weiter.',intro:'Der Raum wird ruhiger, die Arbeit geht weiter. Dimlet verdeckt externe Bildschirme mit schwarzen Fenstern und verhindert den automatischen Ruhezustand.',download:'Für Mac herunterladen',source:'Zum Quellcode ↗',compat:'Kostenlos und Open Source · macOS 13+ · Apple Silicon und Intel',desk:'DEIN SCHREIBTISCH, EIN WENIG RUHIGER',live:'Interaktive Vorschau',toggleTitle:'Externe Bildschirme abdunkeln',statusOff:'Die Bildschirme sind an. Probier den Schalter aus.',statusOn:'Die Bildschirme ruhen. Der Mac arbeitet.',demoNote:'Nur eine Vorschau. Deine echten Bildschirme bleiben unverändert.',feature1Title:'Weniger Licht. Gleicher Schwung.',feature1:'KI-Agenten, lange Builds, nächtliche Renderjobs. Lass sie weiterlaufen, während der Raum etwas ruhiger wird.',feature2Title:'Verbunden bleiben.',feature2:'Monitore bleiben eingeschaltet und verbunden, damit USB-C-Laden weiter möglich ist. Das interne Display bleibt nutzbar.',feature3Title:'Klein, wo es zählt.',feature3:'Natives Swift. Fünf Sprachen. Kein Konto, Tracking, Abo oder zusätzliche Berechtigungen.',howEyebrow:'IN WENIGEN AUGENBLICKEN BEREIT',howTitle:'Eine kleine App.\nEin ruhigerer Arbeitsplatz.',guide:'Installationsanleitung lesen',step1Title:'Mach ein bisschen Platz.',step1:'Lade die ZIP-Datei herunter, entpacke sie und verschiebe Dimlet nach Programme. Öffne die App und begrüße deinen kleinen Freund in der Menüleiste.',step2Title:'Gönn den Bildschirmen eine Pause.',step2:'Klicke auf den kleinen Monitor in der Menüleiste und aktiviere die Abdunklung. Alle unabhängigen externen Bildschirme werden schwarz.',step3Title:'Komm jederzeit zurück.',step3:'Klicke auf einen schwarzen Bildschirm, um alle wieder einzublenden. Dimlet hält deinen Mac wach, bis du die App beendest.',faqEyebrow:'DIE KLEINEN DETAILS',faqTitle:'Gut zu wissen.',q1:'Werden die Monitore wirklich ausgeschaltet?',a1:'Nein. Dimlet verdeckt externe Bildschirme mit schwarzen Fenstern. Lass die Monitore eingeschaltet. Energieeinsparungen oder eine vollständig dunkle LCD-Hintergrundbeleuchtung sind nicht garantiert. USB-C-Laden hängt von deiner Hardware ab.',q2:'Kann ich mein MacBook zuklappen?',a2:'Lass den Deckel offen. Dimlet verhindert während der Laufzeit den automatischen Ruhezustand, aber nicht den Ruhezustand beim Zuklappen, manuell ausgelösten Ruhezustand, das Ausschalten oder einen leeren Akku.',q3:'Sind Einstellungen oder Berechtigungen nötig?',a3:'Zum Ausführen sind keine Bedienungshilfen-, Bildschirmaufnahme- oder Administratorrechte nötig. Die aktuelle Version ist nicht von Apple notarisiert. Beim ersten Start kann Systemeinstellungen → Datenschutz & Sicherheit → Dennoch öffnen erforderlich sein. Details stehen in der Installationsanleitung.',q4:'Funktioniert es mit meinem Setup?',a4:'Dimlet unterstützt macOS 13+ mit unabhängigen, erweiterten Bildschirmen. Gespiegelte Displays werden ausgelassen. Getestet auf einem M4 MacBook Air; Intel-Macs und ältere macOS-Versionen benötigen noch breitere Praxistests. Die App unterstützt Englisch, Japanisch, vereinfachtes Chinesisch, Französisch und Deutsch.',closing:'Ein bisschen weniger Licht.\nEin bisschen mehr Ruhe.',closingNote:'Frei zum Nutzen. Frei zum Verändern.',footer:'Für die Arbeit, die weitergeht.'
  }
};
// Mode-specific copy stays together across the five site languages.
Object.assign(translations.ja, {
  intro:'部屋の明かりを落としても、作業は続く。外部モニターだけ、または内蔵画面も含めて暗くし、Macの自動スリープを防ぎます。',
  feature2:'モニターの電源と接続を保ち、USB-C給電の継続を助けます。内蔵画面を残すか、一緒に暗くするかも選べます。',
  step2:'メニューで「外部モニターだけ暗くする」か「すべてのモニターを暗くする（内蔵＋外部）」を選びます。同じ項目をもう一度選ぶとOFFになります。',
  a1:'電源は切らず、選んだ画面を黒いウインドウで覆います。本体の電源はONにしてください。省電力やLCDのバックライト消灯は保証しません。USB-C給電の継続は機器の仕様にも依存します。',
  a4:'macOS 13以降に対応。「外部モニターだけ」ではミラーリング中の画面を除外し、「すべてのモニター」では内蔵画面も含めて暗くします。M4 MacBook Airで実機確認済み。Intelや以前のmacOSでは、さらなる検証を歓迎します。アプリは英語・日本語・簡体字中国語・フランス語・ドイツ語に対応しています。',
  toggleTitle:'モニターを暗くする',modeExternal:'外部モニターだけ',modeAll:'すべてのモニター',statusAll:'すべての画面はひと休み。Macは作業中。'
});
Object.assign(translations['zh-Hans'], {
  intro:'让房间安静下来，让工作继续。可选择仅调暗外接显示器，或包括内置屏幕在内的所有屏幕，同时防止 Mac 自动睡眠。',
  feature2:'显示器保持通电和连接，让 USB-C 充电可以继续。内置屏幕可以保持显示，也可以一起调暗。',
  step2:'在菜单中选择仅调暗外接显示器，或调暗所有显示器（内置及外接）。再次选择当前模式即可关闭黑屏。',
  a1:'不会关闭电源。Dimlet 用黑色窗口覆盖所选屏幕。请保持显示器电源开启。它不保证节能或关闭 LCD 背光。USB-C 充电取决于硬件。',
  a4:'支持 macOS 13 及以上。仅外接模式会跳过镜像屏幕；所有显示器模式也覆盖内置屏幕。已在 M4 MacBook Air 上测试，Intel 和较早版本仍需更多实机验证。支持英语、日语、简体中文、法语和德语。',
  toggleTitle:'调暗显示器',modeExternal:'仅外接显示器',modeAll:'所有显示器',statusAll:'所有屏幕休息了，Mac 仍在工作。'
});
Object.assign(translations.fr, {
  intro:'La pièce s’apaise, le travail avance. Assombrissez les écrans externes ou tous les écrans, tout en gardant le Mac éveillé.',
  feature2:'Les moniteurs restent alimentés et connectés pour permettre la charge USB-C. Gardez l’écran intégré visible ou assombrissez-le aussi.',
  step2:'Dans le menu, choisissez les écrans externes uniquement ou tous les écrans, intégré compris. Sélectionnez à nouveau le mode actif pour désactiver le masquage.',
  a1:'Non. Dimlet recouvre les écrans choisis de fenêtres noires. Laissez les moniteurs allumés. Il ne garantit ni économie d’énergie ni extinction du rétroéclairage LCD. La charge USB-C dépend du matériel.',
  a4:'Compatible avec macOS 13+. Le mode externe exclut les écrans en miroir ; le mode tous les écrans inclut l’écran intégré. Testé sur MacBook Air M4. Intel et les anciennes versions de macOS nécessitent davantage de tests. Cinq langues sont disponibles : anglais, japonais, chinois simplifié, français et allemand.',
  toggleTitle:'Assombrir les écrans',modeExternal:'Écrans externes',modeAll:'Tous les écrans',statusAll:'Tous les écrans se reposent. Le Mac travaille.'
});
Object.assign(translations.de, {
  intro:'Der Raum wird ruhiger, die Arbeit geht weiter. Dunkle nur externe Monitore oder alle Bildschirme ab und halte deinen Mac wach.',
  feature2:'Monitore bleiben eingeschaltet und verbunden, damit USB-C-Laden weiter möglich ist. Das interne Display kann sichtbar bleiben oder ebenfalls abgedunkelt werden.',
  step2:'Wähle im Menü nur externe Monitore oder alle Monitore inklusive internem Display. Wähle den aktiven Modus erneut, um die Abdunklung auszuschalten.',
  a1:'Nein. Dimlet verdeckt die gewählten Bildschirme mit schwarzen Fenstern. Lass die Monitore eingeschaltet. Energieeinsparungen oder eine dunkle LCD-Hintergrundbeleuchtung sind nicht garantiert. USB-C-Laden hängt von der Hardware ab.',
  a4:'Ab macOS 13. Der externe Modus lässt gespiegelte Displays aus; der Modus für alle Monitore schließt das interne Display ein. Getestet auf M4 MacBook Air. Intel und ältere macOS-Versionen benötigen weitere Praxistests. Fünf Sprachen: Englisch, Japanisch, vereinfachtes Chinesisch, Französisch und Deutsch.',
  toggleTitle:'Monitore abdunkeln',modeExternal:'Nur externe Monitore',modeAll:'Alle Monitore',statusAll:'Alle Bildschirme ruhen. Der Mac arbeitet.'
});
const nodes = [...document.querySelectorAll('[data-i18n]')];
const english = Object.fromEntries(nodes.map(node => [node.dataset.i18n, node.innerText]));
english.statusAll = 'All screens resting. Your Mac, still working.';
english.statusOn = 'External screens resting. Your Mac, still working.';
const languageSelect = document.getElementById('language');
const toggle = document.getElementById('blackout-toggle');
const demo = document.getElementById('demo');
let language = 'en';
let blackout = false;
let mode = 'externalOnly';
const modeButtons = [...document.querySelectorAll('[data-mode]')];
function copy(key) { return (translations[language] || english)[key] || english[key]; }
function updateDemo() {
  demo.dataset.blackout = String(blackout);
  demo.dataset.mode = mode;
  modeButtons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.mode === mode)));
  toggle.setAttribute('aria-checked', String(blackout));
  toggle.setAttribute('aria-label', copy('toggleTitle'));
  document.getElementById('demo-status').textContent = copy(blackout ? (mode === 'allDisplays' ? 'statusAll' : 'statusOn') : 'statusOff');
}
function setLanguage(value) {
  language = Object.hasOwn(translations, value) ? value : 'en';
  document.documentElement.lang = language;
  languageSelect.value = language;
  nodes.forEach(node => { node.textContent = copy(node.dataset.i18n); });
  document.getElementById('guide-link').href = language === 'ja'
    ? 'https://github.com/onodela2000/dimlet/blob/main/README.ja.md'
    : 'https://github.com/onodela2000/dimlet#install';
  updateDemo();
}
languageSelect.addEventListener('change', () => {
  setLanguage(languageSelect.value);
  try { localStorage.setItem('dimlet.site.language', language); } catch { /* The site also works without storage. */ }
});
modeButtons.forEach(button => button.addEventListener('click', () => { mode = button.dataset.mode; updateDemo(); }));
toggle.addEventListener('click', () => { blackout = !blackout; updateDemo(); });
let savedLanguage = 'en';
try { savedLanguage = localStorage.getItem('dimlet.site.language') || 'en'; } catch { /* English remains the default. */ }
setLanguage(savedLanguage);
