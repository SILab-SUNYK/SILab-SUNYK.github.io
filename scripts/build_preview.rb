require "yaml"
require "fileutils"

ROOT = File.expand_path("..", __dir__)
OUT = File.join(ROOT, "_site")
FileUtils.rm_rf(OUT)
FileUtils.mkdir_p(OUT)
FileUtils.cp_r(File.join(ROOT, "assets"), File.join(OUT, "assets"))
pubs = YAML.load_file(File.join(ROOT, "_data/publications.yml"))
team = YAML.load_file(File.join(ROOT, "_data/team.yml"))

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
  <!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>#{title} · SIL</title><script>try{if(localStorage.getItem('sil-theme')!=='light')document.documentElement.dataset.theme='dark'}catch(e){document.documentElement.dataset.theme='dark'}</script><link rel="stylesheet" href="/assets/css/style.css"><link rel="stylesheet" href="/assets/css/publications.css"><link rel="stylesheet" href="/assets/css/theme.css"></head><body>
  #{header}<main>#{body}</main>
  <footer class="site-footer wrap"><div><b>SIL</b><span>Spatial Intelligence Lab</span></div><p>Machines that understand space.</p><div><a href="mailto:francoisbernar.rameau@stonybrook.edu">Contact ↗</a><small>SUNY Korea · Stony Brook University</small></div></footer><script src="/assets/js/theme.js"></script></body></html>
  HTML
end

home = links(strip_front(File.read(File.join(ROOT, "index.html"))))
cards = pubs.first(3).map do |p|
  image = p['image'] ? %(<figure><img src="#{p['image']}" alt="#{p['image_alt'] || p['title']}"></figure>) : ""
  %(<a href="#{p['link']}" class="#{p['image'] ? 'has-paper-image' : ''}">#{image}<span>#{p['type']}<b>#{p['venue']} · #{p['year']}</b></span><div><h3>#{p['title']}</h3><p>#{p['authors']}</p></div><i>↗</i></a>)
end.join
home.sub!(/\{% for paper.*?\{% endfor %\}/m, cards)
File.write(File.join(OUT, "index.html"), wrap("Home", home))

pub_body = links(strip_front(File.read(File.join(ROOT, "publications.html"))))
archive = pubs.group_by { |p| p['year'] }.map do |year, list|
  items = list.map do |p|
    image = p['image'] ? %(<figure><img src="#{p['image']}" alt="#{p['image_alt'] || p['title']}"></figure>) : ""
    %(<a class="archive-paper #{p['image'] ? 'has-paper-image' : ''}" data-type="#{p['type']}" href="#{p['link']}">#{image}<span>#{p['type']}<b>#{p['venue']}</b></span><div><h3>#{p['title']}</h3><p>#{p['authors']}</p></div><i>↗</i></a>)
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
    members.map { |p| %(<a class="person" href="#{p['link']}"><div class="portrait"><span>FR</span><i></i><i></i></div><div><small>#{p['role']}</small><h3>#{p['name']}</h3><p>#{p['interests']}</p></div><b>↗</b></a>) }.join
  end
  %(<div class="team-row"><h2>#{group}</h2><div>#{people}</div></div>)
end.join
team_body.sub!(/\{% assign groups.*?\{% endfor %\}<\/section>/m, "#{groups}</section>")
FileUtils.mkdir_p(File.join(OUT, "team"))
File.write(File.join(OUT, "team/index.html"), wrap("Team", team_body))
