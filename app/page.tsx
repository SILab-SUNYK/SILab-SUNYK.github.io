import Link from "next/link";
import { news, publications, research, site } from "./site-content";

function Mark() {
  return <span className="mark" aria-hidden="true"><i /><b /><em /></span>;
}

export default function Home() {
  return (
    <main>
      <div className="topbar">
        <span>{site.affiliation} · Incheon, South Korea</span>
        <a href={`mailto:${site.email}`}><i className="status-dot" /> We are recruiting</a>
      </div>

      <header className="nav shell">
        <a className="brand" href="#top" aria-label="SIL home"><Mark /><span><strong>SIL</strong><small>Spatial Intelligence Lab</small></span></a>
        <nav aria-label="Main navigation">
          <a href="#research">Research</a><Link href="/publications">Publications</Link><Link href="/team">Team</Link><a href="#news">News</a>
        </nav>
        <a className="contact-link" href={`mailto:${site.email}`}>Contact ↗</a>
      </header>

      <section className="hero" id="top">
        <div className="hero-copy">
          <p className="eyebrow">Perception / Geometry / Interaction</p>
          <h1>Machines that understand <em>space.</em></h1>
          <p className="lede">{site.description}</p>
          <div className="hero-foot"><span>Directed by {site.director}</span><a href="#research">Explore our work ↓</a></div>
        </div>
        <div className="scene" aria-label="Abstract spatial scene graph visualization">
          <span className="scene-label">LIVE SCENE GRAPH / SIL—001</span><span className="coordinates">X 37.52 / Y 126.98 / Z 024</span>
          <div className="orbit orbit-one" /><div className="orbit orbit-two" /><div className="axis" />
          <div className="volume"><i /></div>
          <span className="node node-a" /><span className="node node-b" /><span className="node node-c" /><span className="node node-d" />
          <span className="tag tag-a">CAMERA / ACTIVE</span><span className="tag tag-b">SEMANTIC NODE</span>
        </div>
      </section>

      <section className="section shell" id="research">
        <div className="section-title"><p>01 / Research areas</p><h2>Building intelligence with a sense of place.</h2></div>
        <div className="research-grid">
          {research.map((item, i) => <article className="research-card" key={item.title}><div className={`focus-visual visual-${i + 1}`} aria-hidden="true"><i /><i /><i /><b /><b /><em /></div><span>0{i + 1}</span><h3>{item.title}</h3><p>{item.description}</p><small>{item.tags.join(" · ")}</small></article>)}
        </div>
      </section>

      <section className="feature" id="publications">
        <div className="feature-intro"><p className="eyebrow">02 / Selected work</p><h2>From pixels<br />to <em>places.</em></h2><p>We publish open, reproducible research at the intersection of 3D vision, learning, and robotics.</p><a href={`mailto:${site.email}`}>Collaborate with us ↗</a></div>
        <div className="publication-list">
          {publications.slice(0,3).map((paper, i) => <article key={paper.title}><span className="paper-index">P—0{i + 1}</span><div><small>{paper.type} · {paper.venue} · {paper.year}</small><h3>{paper.title}</h3><p>{paper.authors}</p></div><a href={paper.link} aria-label={`Read ${paper.title}`}>↗</a></article>)}
          <Link className="all-publications" href="/publications">Browse all publications <span>Year & type index ↗</span></Link>
        </div>
      </section>

      <section className="people shell" id="people">
        <div className="section-title"><p>03 / People</p><h2>Different disciplines.<br />One shared coordinate system.</h2></div>
        <div className="people-copy"><p>Led by {site.director}, SIL brings together researchers in computer vision, machine learning, 3D perception, and collaborative robotics.</p><Link className="button" href="/team">Meet the team <span>↗</span></Link><a className="button" href={`mailto:${site.email}`}>Join SIL <span>↗</span></a></div>
      </section>

      <section className="news shell" id="news">
        <div className="section-title"><p>04 / Field notes</p><h2>News from the lab.</h2></div>
        <div className="news-list">
          {news.map(item => <Link href={`/news/${item.slug}`} key={item.slug}><time>{item.date}</time><span><small>{item.category}</small><strong>{item.title}</strong></span><b>↗</b></Link>)}
        </div>
      </section>

      <footer><div><Mark /><strong>SIL</strong></div><p>Intelligence begins<br />with a sense of place.</p><div><a href={`mailto:${site.email}`}>{site.email}</a><small>© {new Date().getFullYear()} Spatial Intelligence Lab</small></div></footer>
    </main>
  );
}
