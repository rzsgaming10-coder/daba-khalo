import Link from "next/link";

const links = [
  { href: "/tournaments", label: "Tournaments" },
  { href: "/rankings", label: "Rankings" },
];

export function SiteHeader() {
  return (
    <header className="site-header">
      <div className="shell header-inner">
        <Link className="brand" href="/" aria-label="Daba Khalo home">
          <span className="brand-mark" aria-hidden="true">D</span>
          <span className="brand-copy">
            <strong>DABA KHALO</strong>
            <small>THE CHESS ARENA</small>
          </span>
        </Link>
        <nav className="main-nav" aria-label="Main navigation">
          {links.map((link) => (
            <Link key={link.href} href={link.href}>{link.label}</Link>
          ))}
        </nav>
        <div className="header-actions">
          <Link className="button button-small button-outline" href="/tournaments">
            Join the arena <span aria-hidden="true">↗</span>
          </Link>
        </div>
      </div>
    </header>
  );
}
