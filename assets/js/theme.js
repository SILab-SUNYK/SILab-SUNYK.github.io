(function () {
  var root = document.documentElement;
  var button = document.querySelector('.theme-toggle');
  if (!button) return;
  function updateButton() {
    var dark = root.dataset.theme === 'dark';
    button.setAttribute('aria-pressed', String(dark));
    button.setAttribute('aria-label', dark ? 'Switch to light theme' : 'Switch to dark theme');
    button.querySelector('b').textContent = dark ? 'Light' : 'Dark';
  }
  button.addEventListener('click', function () {
    var dark = root.dataset.theme !== 'dark';
    if (dark) root.dataset.theme = 'dark'; else delete root.dataset.theme;
    try { localStorage.setItem('sil-theme', dark ? 'dark' : 'light'); } catch (e) {}
    updateButton();
  });
  updateButton();
})();
