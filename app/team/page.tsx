import Link from "next/link";
import { site, team } from "../site-content";

const groups=[
  { title:"Professor", members:team },
  { title:"PhD students", members:[] },
  { title:"Master’s students", members:[] },
];
export default function TeamPage(){return <main className="index-page team-page">
  <header className="sub-nav"><Link href="/">SIL <span>Spatial Intelligence Lab</span></Link><nav><Link href="/publications">Publications</Link><Link href="/#research">Research</Link><Link href="/">Home ↗</Link></nav></header>
  <section className="index-hero"><p className="eyebrow">People / SIL</p><h1>Team</h1><p>Researchers building machines that understand and collaborate in the spatial world.</p></section>
  <section className="team-groups">{groups.map(group=><div className="team-group" key={group.title}><h2>{group.title}<sup>{group.members.length}</sup></h2>{group.members.length?group.members.map(person=><a className="person-card" href={person.link} key={person.name}><div className="portrait-placeholder"><span>FR</span><i /><i /><i /></div><div><small>{person.role}</small><h3>{person.name}</h3><p>{person.detail}</p><em>{person.interests}</em></div><b>↗</b></a>):<div className="empty-group"><p>Profiles will be added here.</p><a href={`mailto:${site.email}`}>Interested in joining? ↗</a></div>}</div>)}</section>
  </main>}
