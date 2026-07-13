(function () {
  document.querySelectorAll('[data-news-carousel]').forEach(function (carousel) {
    var slides = Array.prototype.slice.call(carousel.querySelectorAll('[data-news-slide]'));
    var dots = Array.prototype.slice.call(carousel.querySelectorAll('[data-news-dot]'));
    var previous = carousel.querySelector('[data-news-prev]');
    var next = carousel.querySelector('[data-news-next]');
    var current = 0;
    var timer;
    var reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (slides.length < 2) {
      if (previous) previous.hidden = true;
      if (next) next.hidden = true;
      return;
    }

    function show(index) {
      current = (index + slides.length) % slides.length;
      slides.forEach(function (slide, i) {
        var active = i === current;
        slide.classList.toggle('is-active', active);
        slide.setAttribute('aria-hidden', active ? 'false' : 'true');
        slide.querySelectorAll('a').forEach(function (link) { link.tabIndex = active ? 0 : -1; });
      });
      dots.forEach(function (dot, i) { dot.setAttribute('aria-pressed', i === current ? 'true' : 'false'); });
    }

    function stop() { window.clearTimeout(timer); }
    function start() {
      stop();
      if (!reduceMotion && !document.hidden) timer = window.setTimeout(function () { show(current + 1); start(); }, 7000);
    }

    previous.addEventListener('click', function () { show(current - 1); start(); });
    next.addEventListener('click', function () { show(current + 1); start(); });
    dots.forEach(function (dot) { dot.addEventListener('click', function () { show(Number(dot.dataset.newsDot)); start(); }); });
    carousel.addEventListener('mouseenter', stop);
    carousel.addEventListener('mouseleave', start);
    carousel.addEventListener('focusin', stop);
    carousel.addEventListener('focusout', start);
    carousel.addEventListener('keydown', function (event) {
      if (event.key === 'ArrowLeft') { show(current - 1); start(); }
      if (event.key === 'ArrowRight') { show(current + 1); start(); }
    });
    document.addEventListener('visibilitychange', start);
    show(0);
    start();
  });
}());
