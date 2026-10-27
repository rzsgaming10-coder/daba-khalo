import Link from "next/link";

export default function AdminPage() {
  return (
    <div className="shell page-section">
      <Link href="/" className="back-link">← Daba Khalo</Link>
      <div className="page-heading admin-heading">
        <span className="section-eyebrow">RESTRICTED AREA</span>
        <h1>Admin access <span>unavailable.</span></h1>
        <p>Administrative controls are disabled until secure authentication and server-side role authorization are connected.</p>
      </div>
      <section className="panel admin-locked">
        <span className="locked-icon" aria-hidden="true">♜</span>
        <div><strong>No admin data or controls are exposed.</strong><p>Connect a trusted session provider and enforce the ADMIN role on the server before enabling tournament, payment, or payout management.</p></div>
        <Link className="button button-outline" href="/tournaments">Back to tournaments</Link>
      </section>
    </div>
  );
}
