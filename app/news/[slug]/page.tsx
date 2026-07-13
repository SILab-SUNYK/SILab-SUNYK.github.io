import Link from "next/link";
import { notFound } from "next/navigation";
import { news, site } from "../../site-content";

export function generateStaticParams() { return news.map(({ slug }) => ({ slug })); }

export default async function NewsArticle({ params }: { params: Promise<{ slug: string }> }) {
  const { slug } = await params;
  const article = news.find(item => item.slug === slug);
  if (!article) notFound();
  return <main className="article-page">
    <header className="article-nav"><Link href="/">SIL <span>Spatial Intelligence Lab</span></Link><Link href="/#news">All field notes ↙</Link></header>
    <article><p className="eyebrow">{article.category} / {article.date}</p><h1>{article.title}</h1><p className="article-deck">{article.excerpt}</p><div className="article-body">{article.body.map(paragraph => <p key={paragraph}>{paragraph}</p>)}</div></article>
    <footer className="article-footer"><p>Spatial Intelligence Lab</p><a href={`mailto:${site.email}`}>{site.email}</a></footer>
  </main>;
}
