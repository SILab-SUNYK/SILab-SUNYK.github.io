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
  <footer class="site-footer wrap"><div><b>SIL</b><span>Spatial Intelligence Lab</span></div><p>Machines that understand space.</p><div><a href="mailto:francoisbernar.rameau@stonybrook.edu">Contact ↗</a><small>SUNY Korea · Stony Brook University</small></div></footer><script src="/assets/js/theme.js"></script></body></html>
  HTML
end

home = links(strip_front(File.read(File.join(ROOT, "index.html"))))
home.gsub!(/\{\{\s*site\.data\.home\.hero\.image\s*\|\s*relative_url\s*\}\}/, home_data['hero']['image'])
home.gsub!(/\{\{\s*site\.data\.home\.hero\.image_alt\s*\}\}/, home_data['hero']['image_alt'])
home_data['research'].each_with_index do |item, index|
  home.gsub!(/\{\{\s*site\.data\.home\.research\[#{index}\]\.image\s*\|\s*relative_url\s*\}\}/, item['image'])
  home.gsub!(/\{\{\s*site\.data\.home\.research\[#{index}\]\.image_alt\s*\}\}/, item['image_alt'])
end
news_items = news.map do |item|
  image = item['image'] ? %(<figure><img src="#{item['image']}" alt="#{item['image_alt'] || item['title']}"></figure>) : ""
  more = item['link'] ? %(<a href="#{item['link']}">Read more ↗</a>) : ""
  %(<article class="news-item" tabindex="0"><div class="news-summary"><time datetime="#{item['date']}">#{item['display_date']}</time><b>#{item['category']}</b><span>#{item['title']}</span><i aria-hidden="true">＋</i></div><div class="news-reveal"><div><div class="news-detail-layout">#{image}<div><p>#{item['details']}</p>#{more}</div></div></div></div></article>)
end.join
home.sub!(/\{% for item in site\.data\.news %\}.*?\{% endfor %\}/m, news_items)
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
