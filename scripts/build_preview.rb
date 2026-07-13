require "yaml"
require "fileutils"

ROOT = File.expand_path("..", __dir__)
OUT = File.join(ROOT, "_site")
FileUtils.rm_rf(OUT)
FileUtils.mkdir_p(OUT)
FileUtils.cp_r(File.join(ROOT, "assets"), File.join(OUT, "assets"))
pubs = YAML.load_file(File.join(ROOT, "_data/publications.yml"))
team = YAML.load_file(File.join(ROOT, "_data/team.yml"))
home_data = YAML.load_file(File.join(ROOT, "_data/home.yml"))
news = YAML.load_file(File.join(ROOT, "_data/news.yml"))

def strip_front(text)
  text.sub(/\A---.*?---\s*/m, "")
end
def links(text)
  text.gsub(/\{\{\s*'([^']+)'\s*\|\s*relative_url\s*\}\}/, '\\1')
end
def header
  links(File.read(File.join(ROOT, "_includes/header.html")))
end
def wrap(title, body)
  <<~HTML
  <!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>#{title} · SIL</title><script>try{if(localStorage.getItem('sil-theme')!=='light')document.documentElement.dataset.theme='dark'}catch(e){document.documentElement.dataset.theme='dark'}</script><link rel="stylesheet" href="/assets/css/style.css"><link rel="stylesheet" href="/assets/css/publications.css"><link rel="stylesheet" href="/assets/css/theme.css"><link rel="stylesheet" href="/assets/css/home-images.css"><link rel="stylesheet" href="/assets/css/news.css"><link rel="stylesheet" href="/assets/css/team.css"></head><body>
  #{header}<main>#{body}</main>
  <footer class="site-footer wrap"><div><b>SIL</b><span>Spatial Intelligence Lab</span></div><p>Machines that understand space.</p><div><a href="mailto:francoisbernar.rameau@stonybrook.edu">Contact ↗</a><small>SUNY Korea · Stony Brook University</small></div></footer><script src="/assets/js/theme.js"></script><script src="/assets/js/news-carousel.js"></script></body></html>
  HTML
end

home = links(strip_front(File.read(File.join(ROOT, "index.html"))))
home.gsub!(/\{\{\s*site\.data\.home\.hero\.image\s*\|\s*relative_url\s*\}\}/, home_data['hero']['image'])
home.gsub!(/\{\{\s*site\.data\.home\.hero\.image_alt\s*\}\}/, home_data['hero']['image_alt'])
home_data['research'].each_with_index do |item, index|
  home.gsub!(/\{\{\s*site\.data\.home\.research\[#{index}\]\.image\s*\|\s*relative_url\s*\}\}/, item['image'])
  home.gsub!(/\{\{\s*site\.data\.home\.research\[#{index}\]\.image_alt\s*\}\}/, item['image_alt'])
end
carousel_slides = news.first(5).each_with_index.map do |item, index|
  image = item['image'] || home_data['hero']['image']
  alt = item['image_alt'] || home_data['hero']['image_alt']
  more = item['link'] ? %(<a href="#{item['link']}"#{index.zero? ? '' : ' tabindex="-1"'}>Read story ↗</a>) : ""
  %(<article class="hero-news-slide#{index.zero? ? ' is-active' : ''}" data-news-slide aria-hidden="#{index.zero? ? 'false' : 'true'}"><img src="#{image}" alt="#{alt}"><div class="hero-news-shade"></div><div class="hero-news-content"><p><span>#{item['category']}</span><time datetime="#{item['date']}">#{item['display_date']}</time></p><h2>#{item['title']}</h2><div>#{item['details']}</div>#{more}</div></article>)
end.join
carousel_dots = news.first(5).each_index.map do |index|
  %(<button type="button" data-news-dot="#{index}" aria-label="Show news item #{index + 1}" aria-pressed="#{index.zero? ? 'true' : 'false'}"></button>)
end.join
carousel = %(<section class="hero-news" data-news-carousel aria-label="Latest news"><div class="hero-news-slides" aria-live="polite">#{carousel_slides}</div><div class="hero-news-topline"><span>Latest from SIL</span><a href="/news/">All news ↗</a></div><div class="hero-news-controls"><button type="button" data-news-prev aria-label="Previous news item">←</button><div class="hero-news-dots" aria-label="Choose news item">#{carousel_dots}</div><button type="button" data-news-next aria-label="Next news item">→</button></div></section>)
home.sub!(/\{% include news-carousel\.html %\}/, carousel)
cards = pubs.first(3).map do |p|
  image = p['image'] ? %(<figure><img src="#{p['image']}" alt="#{p['image_alt'] || p['title']}"></figure>) : ""
  %(<a href="#{p['link']}" class="#{p['image'] ? 'has-paper-image' : ''}"><div class="paper-meta"><span>#{p['type']}<b>#{p['venue']} · #{p['year']}</b></span>#{image}</div><div><h3>#{p['title']}</h3><p>#{p['authors']}</p><p class="venue-full">#{p['venue_full']}</p></div><i>↗</i></a>)
end.join
home.sub!(/\{% for paper.*?\{% endfor %\}/m, cards)
File.write(File.join(OUT, "index.html"), wrap("Home", home))

pub_body = links(strip_front(File.read(File.join(ROOT, "publications.html"))))
archive = pubs.group_by { |p| p['year'] }.map do |year, list|
  items = list.map do |p|
    image = p['image'] ? %(<figure><img src="#{p['image']}" alt="#{p['image_alt'] || p['title']}"></figure>) : ""
    %(<a class="archive-paper #{p['image'] ? 'has-paper-image' : ''}" data-type="#{p['type']}" href="#{p['link']}"><div class="paper-meta"><span>#{p['type']}<b>#{p['venue']}</b></span>#{image}</div><div><h3>#{p['title']}</h3><p>#{p['authors']}</p><p class="venue-full">#{p['venue_full']}</p></div><i>↗</i></a>)
  end.join
  %(<div class="year-block"><h2>#{year}</h2><div>#{items}</div></div>)
end.join
pub_body.sub!(/\{% assign years.*?\{% endfor %\}<\/section>/m, "#{archive}</section>")
FileUtils.mkdir_p(File.join(OUT, "publications"))
File.write(File.join(OUT, "publications/index.html"), wrap("Publications", pub_body))

team_body = links(strip_front(File.read(File.join(ROOT, "team.html"))))
groups = ["Professor", "PhD Student", "Master Student"].map do |group|
  members = team.select { |p| p['group'] == group }
  people = if members.empty?
    %(<div class="vacancy"><span>Profiles coming soon.</span><a href="mailto:francoisbernar.rameau@stonybrook.edu">Interested in joining? ↗</a></div>)
  else
    members.map do |p|
      portrait = p['image'] ? %(<img src="#{p['image']}" alt="#{p['image_alt'] || p['name']}">) : %(<span>FR</span><i></i><i></i>)
      joined = p['joined'] ? " · Joined #{p['joined']}" : ""
      name = p['link'] ? %(<a href="#{p['link']}">#{p['name']}</a>) : p['name']
      more = p['link'] ? %(<a class="person-link" href="#{p['link']}" aria-label="Visit #{p['name']}'s website">↗</a>) : ""
      %(<article class="person"><div class="portrait">#{portrait}</div><div><small>#{p['role']}#{joined}</small><h3>#{name}</h3><p>#{p['interests']}</p></div>#{more}</article>)
    end.join
  end
  %(<div class="team-row"><h2>#{group}</h2><div>#{people}</div></div>)
end.join
team_body.sub!(/\{% assign groups.*?\{% endfor %\}<\/section>/m, "#{groups}</section>")
FileUtils.mkdir_p(File.join(OUT, "team"))
File.write(File.join(OUT, "team/index.html"), wrap("Team", team_body))

news_body = links(strip_front(File.read(File.join(ROOT, "news.html"))))
news_cards = news.map do |item|
  image = item['image'] ? %(<figure><img src="#{item['image']}" alt="#{item['image_alt'] || item['title']}"></figure>) : ""
  more = item['link'] ? %(<a href="#{item['link']}">Read more ↗</a>) : ""
  %(<article class="news-card"><div class="news-card-meta"><time datetime="#{item['date']}">#{item['display_date']}</time><b>#{item['category']}</b></div><div class="news-card-body"><h2>#{item['title']}</h2><p>#{item['details']}</p>#{more}</div>#{image}</article>)
end.join
news_body.sub!(/\{% for item in site\.data\.news %\}.*?\{% endfor %\}/m, news_cards)
FileUtils.mkdir_p(File.join(OUT, "news"))
File.write(File.join(OUT, "news/index.html"), wrap("News", news_body))
