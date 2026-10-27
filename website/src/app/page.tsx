import Link from "next/link";
import { TournamentCard } from "@/components/tournament-card";
import { calculatePrizeDistribution } from "@/lib/prize-engine";
import { formatMoney } from "@/lib/format";
import { tournaments } from "@/services/tournament-seed";

export default function HomePage() {
  const featured = tournaments.find((tournament) => tournament.featured) ?? tournaments[0];
  const totalPrize = tournaments.reduce(
    (sum, tournament) => sum + calculatePrizeDistribution(tournament).prizePoolMinor,
    0,
  );
  return (
    <>
      <section className="hero">
        <div className="hero-grid" aria-hidden="true" />
        <div className="shell hero-content">
          <div className="hero-copy">
            <span className="eyebrow"><span className="eyebrow-line" /> BANGLADESH&apos;S CHESS ARENA</span>
            <h1>Play.<br />Compete.<br /><span>Conquer.</span></h1>
            <p>Every move writes your story. Find your next tournament, face the field, and earn your place at the top.</p>
            <div className="hero-actions">
              <Link className="button button-gold" href="/tournaments">Explore tournaments <span aria-hidden="true">↗</span></Link>
              <Link className="button button-outline" href="/rankings">View rankings</Link>
            </div>
            <div className="hero-trust"><span className="trust-mark">♟</span><span>Built for the next generation of chess.</span></div>
          </div>
          <div className="hero-feature">
            <div className="feature-orbit" aria-hidden="true"><span>♞</span></div>
            <div className="featured-tag"><span className="live-pulse" /> FEATURED TOURNAMENT</div>
            <h2>{featured.name}</h2>
            <p>{featured.timeControl} · {featured.registeredPlayers} players registered</p>
            <div className="feature-prize"><span>PRIZE POOL</span><strong>{formatMoney(calculatePrizeDistribution(featured).prizePoolMinor)}</strong></div>
            <Link className="feature-link" href={`/tournaments/${featured.id}`}>Discover the tournament <span aria-hidden="true">→</span></Link>
            <span className="feature-index">01 <i /> 04</span>
          </div>
        </div>
        <div className="shell hero-stats">
          <div><strong>1,284</strong><span>Players in the arena</span></div>
          <div><strong>24</strong><span>Tournaments hosted</span></div>
          <div><strong>{formatMoney(totalPrize)}</strong><span>Prize pool in play</span></div>
          <div className="stats-note"><span className="live-pulse" /> 1 tournament live now</div>
        </div>
      </section>
      <section className="section shell">
        <div className="section-heading">
          <div><span className="section-eyebrow">THE ARENA</span><h2>Find your next <span>challenge.</span></h2></div>
          <Link className="text-link" href="/tournaments">All tournaments <span aria-hidden="true">→</span></Link>
        </div>
        <div className="tournament-grid">
          {tournaments.slice(0, 3).map((tournament) => <TournamentCard key={tournament.id} tournament={tournament} />)}
        </div>
      </section>
      <section className="join-banner shell">
        <div><span className="section-eyebrow">YOUR NEXT MOVE</span><h2>The board is waiting.</h2><p>Choose a tournament. Bring your best game.</p></div>
        <Link className="button button-gold" href="/tournaments">Enter the arena <span aria-hidden="true">↗</span></Link>
      </section>
    </>
  );
}
