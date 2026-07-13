import Link from "next/link";
import { publications } from "../site-content";
import { PublicationIndex } from "./publication-index";

export default function PublicationsPage() {
  return <main className="index-page">
    <header className="sub-nav"><Link href="/">SIL <span>Spatial Intelligence Lab</span></Link><nav><Link href="/team">Team</Link><Link href="/#research">Research</Link><Link href="/">Home ↗</Link></nav></header>
    <section className="index-hero"><p className="eyebrow">Research output / Archive</p><h1>Publications</h1><p>Peer-reviewed work in 3D vision, visual localization, machine learning, and connected robotics.</p></section>
    <PublicationIndex publications={publications} />
  </main>;
}
