#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Render crawlable language pages using only the Python standard library."""
import hashlib
import html
import json
import re
import sys
from pathlib import Path
from urllib.parse import urlsplit, unquote
from html.parser import HTMLParser

ROOT = Path(__file__).resolve().parent.parent
SITE = ROOT / 'site'
DATA = json.loads((ROOT / 'website/locales.json').read_text(encoding='utf-8'))
TEMPLATE = (ROOT / 'website/index.template.html').read_text(encoding='utf-8')
BASE = 'https://onodela2000.github.io/dimlet/'
LANGUAGES = {'en': ('', 'English'), 'ja': ('ja/', '日本語'), 'zh-Hans': ('zh-hans/', '简体中文'), 'fr': ('fr/', 'Français'), 'de': ('de/', 'Deutsch')}
GUIDE = 'ja/mac-usb-c-monitor-charging-screen-off/'
TITLES = {
    'en': 'Darken Mac screens without sleep | USB-C charging & AI tasks | Dimlet',
    'ja': 'Macの画面だけ暗く・スリープさせない｜USB-C充電と作業を続ける Dimlet',
    'zh-Hans': 'Mac 屏幕变暗但不睡眠｜USB-C 充电与后台工作 | Dimlet',
    'fr': 'Assombrir les écrans du Mac sans mise en veille | Dimlet',
    'de': 'Mac-Bildschirme abdunkeln ohne Ruhezustand | Dimlet',
}
DESCRIPTIONS = {language: copy['intro'] + ' ' + copy['compat'] for language, copy in DATA.items()}
DESCRIPTIONS['ja'] = 'USB-CモニターでMacを充電だけしたいのに画面もつく、電源OFFで給電が止まる、AI処理中はスリープさせたくない。Dimletは外部だけ・内蔵も含む全画面を黒表示にする無料Macアプリ。給電やスリープとの違いも解説。'
KEYED = re.compile(r'(<(?P<tag>[a-z0-9]+)\b[^>]*data-i18n="(?P<key>[^"]+)"[^>]*>)(.*?)(</(?P=tag)>)', re.S)

def escape(value):
    return html.escape(str(value), quote=True)

def json_script(value):
    return json.dumps(value, ensure_ascii=False).replace('<', '\\u003c')

def render(language, path=None):
    directory, _ = LANGUAGES[language]
    path = directory if path is None else path
    prefix = '../' * len(Path(path).parts)
    copy = DATA[language]
    page = KEYED.sub(lambda m: m[1] + escape(copy[m['key']]).replace('\n', '<br>') + m[5], TEMPLATE)
    alternatives = '\n  '.join(f'<link rel="alternate" hreflang="{code}" href="{BASE}{folder}">' for code, (folder, _) in LANGUAGES.items())
    alternatives += f'\n  <link rel="alternate" hreflang="x-default" href="{BASE}">'
    links = ' '.join(f'<a href="{prefix}{folder or "./"}" lang="{code}" hreflang="{code}"' + (' aria-current="page"' if code == language else '') + f'>{name}</a>' for code, (folder, name) in LANGUAGES.items())
    schema = {'@context': 'https://schema.org', '@type': 'SoftwareApplication', 'name': 'Dimlet', 'url': BASE + directory, 'description': DESCRIPTIONS[language], 'operatingSystem': 'macOS 13 or later', 'applicationCategory': 'UtilitiesApplication', 'softwareVersion': (ROOT / 'VERSION').read_text().strip(), 'inLanguage': language, 'license': 'https://github.com/onodela2000/dimlet/blob/main/LICENSE', 'downloadUrl': 'https://github.com/onodela2000/dimlet/releases/latest', 'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'USD'}}
    values = {'LANG': language, 'TITLE': escape(TITLES[language]), 'DESCRIPTION': escape(DESCRIPTIONS[language]), 'CANONICAL': BASE + path, 'ASSET_BASE': prefix, 'HOME': prefix + (directory or './'), 'GUIDE_URL': prefix + GUIDE, 'LANGUAGE_LINKS': links, 'ALTERNATES': alternatives, 'SCHEMA': json_script(schema), 'CSS_HASH': hashlib.sha256((SITE / 'style.css').read_bytes()).hexdigest()[:12], 'JS_HASH': hashlib.sha256((SITE / 'app.js').read_bytes()).hexdigest()[:12]}
    for key, value in values.items():
        page = page.replace('{{' + key + '}}', value)
    for code, (folder, _) in LANGUAGES.items():
        page = page.replace(f'<option value="{code}">', f'<option value="{code}" data-url="{prefix}{folder or "./"}"' + (' selected' if code == language else '') + '>')
    page = page.replace('id="demo-status"', 'id="demo-status" data-off="' + escape(copy['statusOff']) + '" data-external="' + escape(copy['statusOn']) + '" data-all="' + escape(copy['statusAll']) + '"')
    page = page.replace('aria-label="Darken monitors"', 'aria-label="' + escape(copy['toggleTitle']) + '"')
    if language == 'ja':
        page = page.replace('id="guide-link" href="https://github.com/onodela2000/dimlet#install"', 'id="guide-link" href="https://github.com/onodela2000/dimlet/blob/main/README.ja.md"')
    assert '{{' not in page, 'Unresolved template field'
    return page

outputs = {Path(folder) / 'index.html': render(language) for language, (folder, _) in LANGUAGES.items()}
article = render('ja', GUIDE)
article_body = (ROOT / 'website/charging-guide.html').read_text(encoding='utf-8').replace('{{HOME}}', '../')
article = re.sub(r'<main id="main">.*?</main>', lambda _: article_body, article, flags=re.S)
article = article.replace('href="#how"', 'href="../#how"')
article = re.sub(r'\s*<link rel="alternate"[^>]+>', '', article)
article_title = 'MacにUSB-Cモニターで充電だけしたい｜画面を消すと給電が止まるときの対処'
article_desc = 'MacBookをUSB-Cで充電だけしたいのに画面がつく、モニターをOFFにすると充電が止まる。待機中給電、macOSのスリープ設定、画面だけ暗くする方法の違いを解説します。'
article = re.sub(r'<title>.*?</title>', '<title>' + article_title + ' | Dimlet</title>', article)
article = re.sub(r'(<meta (?:name="description"|property="og:description") content=")[^"]*', lambda m: m[1] + article_desc, article)
article = re.sub(r'(<meta property="og:title" content=")[^"]*', lambda m: m[1] + article_title, article)
article_schema = {'@context': 'https://schema.org', '@type': 'Article', 'headline': article_title, 'description': article_desc, 'inLanguage': 'ja', 'mainEntityOfPage': BASE + GUIDE, 'datePublished': '2026-09-13', 'dateModified': '2026-09-13', 'author': {'@type': 'Organization', 'name': 'Dimlet', 'url': BASE}}
article = re.sub(r'<script type="application/ld\+json">.*?</script>', lambda _: '<script type="application/ld+json">' + json_script(article_schema) + '</script>', article, flags=re.S)
outputs[Path(GUIDE) / 'index.html'] = article
urls = [BASE + folder for folder, _ in LANGUAGES.values()] + [BASE + GUIDE]
outputs[Path('sitemap.xml')] = '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' + ''.join('  <url><loc>' + escape(url) + '</loc></url>\n' for url in urls) + '</urlset>\n'
outputs[Path('.nojekyll')] = ''

class Inspect(HTMLParser):
    def __init__(self):
        super().__init__(); self.ids = []; self.links = []; self.h1s = 0; self.canonicals = []; self.schemas = []; self.in_schema = False
    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if 'id' in attrs: self.ids.append(attrs['id'])
        if tag == 'h1': self.h1s += 1
        if tag in ('a', 'link', 'img', 'script'):
            ref = attrs.get('href') or attrs.get('src')
            if ref: self.links.append(ref)
        if tag == 'link' and attrs.get('rel') == 'canonical': self.canonicals.append(attrs.get('href'))
        if tag == 'script' and attrs.get('type') == 'application/ld+json': self.in_schema = True
    def handle_data(self, data):
        if self.in_schema: self.schemas.append(json.loads(data))
    def handle_endtag(self, tag):
        if tag == 'script': self.in_schema = False

for path, content in outputs.items():
    if path.suffix != '.html': continue
    info = Inspect(); info.feed(content)
    assert info.h1s == 1 and len(info.canonicals) == 1 and len(info.schemas) == 1, path
    assert len(info.ids) == len(set(info.ids)), ('Duplicate ID', path)
    assert '<html lang=' in content and 'noindex' not in content
    for ref in info.links:
        parsed = urlsplit(ref)
        if parsed.scheme: continue
        target = SITE / path.parent / unquote(parsed.path) if parsed.path else SITE / path
        if not parsed.path or parsed.path.endswith('/'): target = target / 'index.html' if parsed.path else target
        target = target.resolve()
        assert target.is_relative_to(SITE.resolve()), ('Link escapes site', path, ref)
        rel = target.relative_to(SITE.resolve())
        assert rel in outputs or target.is_file(), ('Missing link target', path, ref)
        if parsed.fragment and rel in outputs:
            target_info = Inspect(); target_info.feed(outputs[rel])
            assert parsed.fragment in target_info.ids, ('Missing anchor', path, ref)

check = '--check' in sys.argv
for path, content in outputs.items():
    destination = SITE / path
    if check:
        assert destination.is_file() and destination.read_text(encoding='utf-8') == content, f'Regenerate site with python3 scripts/build_site.py: {path}'
    else:
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_text(content, encoding='utf-8')
print(f'{"Verified" if check else "Built"} five language pages, charging guide, metadata, internal links, schemas, and sitemap.')
