import Link from "next/link";
import { notFound } from "next/navigation";
import { PrizePoolCard } from "@/components/prize-pool-card";
import { RegistrationPreview } from "@/components/registration-preview";
import { TournamentRoadmap } from "@/components/tournament-roadmap";
import { formatFormat, formatMoney, formatTournamentDate, roadmapLabel } from "@/lib/format";
import { tournaments } from "@/services/tournament-seed";

export function generateStaticParams() {
  return tournaments.map((tournament) => ({ id: tournament.id }));
}

export default async function TournamentDetailsPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const tournament = tournaments.find((item) => item.id === id);
  if (!tournament) notFound();

  return (
    <div className="shell page-section">
      <Link href="/tournaments" className="back-link">← All tournaments</Link>
      <section className="detail-hero">
        <div className="detail-copy">
          <div className="card-topline">
            <span className={`status status-${tournament.status.toLowerCase()}`}><span className="status-dot" />{tournament.status.replaceAll("_", " ")}</span>
            <span className="format-label">{formatFormat(tournament.format)}</span>
          </div>
          <span className="section-eyebrow">TOURNAMENT · {tournament.id.toUpperCase()}</span>
          <h1>{tournament.name}</h1>
          <p>{tournament.description}</p>
          <div className="detail-facts">
            <div><span>Entry fee</span><strong>{formatMoney(tournament.entryFeeMinor, tournament.currency)}</strong></div>
            <div><span>Starts</span><strong>{formatTournamentDate(tournament.startTime)}</strong></div>
            <div><span>Format</span><strong>{formatFormat(tournament.format)}</strong></div>
            <div><span>Time control</span><strong>{tournament.timeControl}</strong></div>
          </div>
        </div>
        <div className="detail-sidebar">
          <PrizePoolCard tournament={tournament} />
          <RegistrationPreview tournament={tournament} />
        </div>
      </section>
      <section className="section detail-section">
        <div className="section-heading">
          <div><span className="section-eyebrow">FOLLOW THE ACTION</span><h2>Tournament <span>roadmap.</span></h2></div>
          <span className="live-note"><span className="status-dot" /> {tournament.status === "LIVE" ? "Live now" : "Bracket preview"}</span>
        </div>
        <div className="panel bracket-panel">
          <div className="bracket-summary"><span>{roadmapLabel(tournament.format)}</span><strong>{tournament.registeredPlayers} players · {formatMoney(tournament.entryFeeMinor, tournament.currency)} entry</strong></div>
          <TournamentRoadmap format={tournament.format} />
        </div>
      </section>
      <section className="rules-strip">
        <span className="rule-icon" aria-hidden="true">♜</span>
        <div><strong>Fair play, always.</strong><p>All prize figures shown are previews. Confirmed awards, tournament results, and payouts require server-side verification.</p></div>
      </section>
    </div>
  );
}
