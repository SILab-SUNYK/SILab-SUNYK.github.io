export const site = {
  email: "francoisbernar.rameau@stonybrook.edu",
  director: "Prof. Francois Rameau",
  affiliation: "SUNY Korea · Stony Brook University",
  personalWebsite: "https://frameau.xyz",
  description: "We develop computer vision and robotics systems that perceive, reconstruct, and collaborate within the 3D world—from privacy-preserving localization to connected robots.",
};

export const research = [
  { title: "3D Vision & Localization", description: "Recovering geometry and camera pose from visual observations, with robust and privacy-aware representations of place.", tags: ["3D vision", "Visual localization"] },
  { title: "Connected Robotics", description: "Enabling autonomous agents to perceive, communicate, and collaborate in shared and changing environments.", tags: ["Robotics", "Multi-agent systems"] },
  { title: "Learning for Visual Systems", description: "Building reliable visual learning methods for domain adaptation, matching, omnidirectional imaging, and automotive applications.", tags: ["Deep learning", "Visual perception"] },
];

export const publications = [
  { title: "Seeing Through the Weights: Privacy Leakage in Scene Coordinate Regression", venue: "ECCV", year: "2026", type: "Conference", authors: "O. Nasypanyi, J. Cho, U. Ozbulak, B. Kang, F. Rameau", link: "https://frameau.xyz" },
  { title: "Dual-Foundation Models for Unsupervised Domain Adaptation", venue: "ICPR", year: "2026", type: "Conference", authors: "Y. Cheon, A. Balasubramanian, F. Rameau", link: "https://frameau.xyz" },
  { title: "Token-Based Detection of Spurious Correlations in Vision Transformers", venue: "TMLR", year: "2026", type: "Journal", authors: "S. Kang, E. T. Anzaku, W. De Neve, A. Van Messem, J. Vankerschaver, F. Rameau, U. Ozbulak", link: "https://frameau.xyz" },
  { title: "Pixel-Accurate Epipolar Guided Matching", venue: "3DV", year: "2026", type: "Conference", authors: "O. Nasypanyi, F. Rameau", link: "https://frameau.xyz" },
];

export const team = [
  { name: "Francois Rameau", role: "Professor", detail: "Lab Director · Assistant Professor, SUNY Korea", interests: "3D vision · Visual localization · Connected robotics", link: "https://frameau.xyz" },
];

export const news = [
  { slug: "eccv-2026", date: "06.19.26", category: "Publication", title: "Privacy-preserving visual localization accepted to ECCV 2026", excerpt: "Our work on privacy leakage in scene coordinate regression has been accepted to ECCV 2026.", body: ["Our work on privacy-preserving visual localization has been accepted to ECCV 2026.", "Congratulations to Oleksii Nasypanyi and Jaemin Cho for this fantastic work on understanding what scene-coordinate regression models reveal about their training environments."] },
  { slug: "cvpr-reviewer", date: "05.20.26", category: "Recognition", title: "Outstanding Reviewer at CVPR 2026", excerpt: "Prof. Francois Rameau was recognized among the Outstanding Reviewers for CVPR 2026.", body: ["Prof. Francois Rameau was recognized among the Outstanding Reviewers for CVPR 2026.", "Rigorous and constructive peer review is an essential part of building a healthy computer-vision research community."] },
  { slug: "icpr-2026", date: "04.01.26", category: "Publication", title: "Domain adaptation work accepted to ICPR 2026", excerpt: "Our work on dual-foundation models for unsupervised domain adaptation has been accepted to ICPR 2026.", body: ["Our work on unsupervised domain adaptation has been accepted to ICPR 2026.", "The project studies how complementary foundation models can help visual systems adapt to new domains without target labels."] },
];

export type NewsItem = (typeof news)[number];
