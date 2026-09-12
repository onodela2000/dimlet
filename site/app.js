'use strict';
// Language pages are complete HTML documents; JavaScript only powers the demo.
const languageSelect = document.getElementById('language');
if (languageSelect) languageSelect.addEventListener('change', () => {
  const option = languageSelect.selectedOptions[0];
  if (option?.dataset.url) window.location.assign(option.dataset.url);
});
const toggle = document.getElementById('blackout-toggle');
const demo = document.getElementById('demo');
if (toggle && demo) {
  const status = document.getElementById('demo-status');
  const buttons = [...document.querySelectorAll('[data-mode]')];
  let mode = 'externalOnly';
  let blackout = false;
  function render() {
    demo.dataset.mode = mode;
    demo.dataset.blackout = String(blackout);
    toggle.setAttribute('aria-checked', String(blackout));
    buttons.forEach(button => button.setAttribute('aria-pressed', String(button.dataset.mode === mode)));
    status.textContent = !blackout ? status.dataset.off : mode === 'allDisplays' ? status.dataset.all : status.dataset.external;
  }
  buttons.forEach(button => button.addEventListener('click', () => { mode = button.dataset.mode; render(); }));
  toggle.addEventListener('click', () => { blackout = !blackout; render(); });
  render();
}
