"use client";
import { useState } from "react";

type Paper = { title:string; venue:string; year:string; type:string; authors:string; link:string };
export function PublicationIndex({ publications }: { publications: Paper[] }) {
  const [year,setYear]=useState("All"); const [type,setType]=useState("All");
  const years=["All",...Array.from(new Set(publications.map(p=>p.year))).sort().reverse()];
  const types=["All","Journal","Conference","Workshop"];
  const shown=publications.filter(p=>(year==="All"||p.year===year)&&(type==="All"||p.type===type));
  return <section className="publication-index">
    <div className="filters"><div><span>Year</span>{years.map(x=><button className={year===x?"active":""} onClick={()=>setYear(x)} key={x}>{x}</button>)}</div><div><span>Type</span>{types.map(x=><button className={type===x?"active":""} onClick={()=>setType(x)} key={x}>{x}</button>)}</div></div>
    <p className="result-count">{shown.length.toString().padStart(2,"0")} records</p>
    <div className="archive-list">{shown.map((paper,i)=><article key={paper.title}><span>{paper.year}<small>{paper.type}</small></span><div><small>{paper.venue}</small><h2>{paper.title}</h2><p>{paper.authors}</p></div><a href={paper.link} aria-label={`Open ${paper.title}`}>↗</a></article>)}</div>
  </section>;
}
