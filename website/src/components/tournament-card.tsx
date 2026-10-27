import Link from "next/link";
import { calculatePrizeDistribution } from "@/lib/prize-engine";
import { formatFormat, formatMoney, formatTournamentDate } from "@/lib/format";
import type { Tournament } from "@/types/tournament";

export function TournamentCard({ tournament }: { tournament: Tournament }) {
  const prize = calculatePrizeDistribution(tournament);
  const seatsLeft = Math.max(0, tournament.maximumPlayers - tournament.registeredPlayers);
  return (
    <article className="tournament-card">
      <div className="card-topline">
        <span className={`status status-${tournament.status.toLowerCase()}`}>
          <span className="status-dot" />{statusLabel(tournament.status)}
        </span>
        <span className="format-label">{formatFormat(tournament.format)}</span>
      </div>
      <Link className="card-title-link" href={`/tournaments/${tournament.id}`}>
        <h3>{tournament.name}</h3>
      </Link>
      <p className="card-description">{tournament.description}</p>
      <div className="card-facts">
        <div><span>Entry</span><strong>{formatMoney(tournament.entryFeeMinor, tournament.currency)}</strong></div>
        <div><span>Players</span><strong>{tournament.registeredPlayers}<small> / {tournament.maximumPlayers}</small></strong></div>
        <div><span>Prize pool</span><strong className="gold-text">{formatMoney(prize.prizePoolMinor, tournament.currency)}</strong></div>
      </div>
      <div className="card-bottom">
        <span className="muted"><span aria-hidden="true">◷</span> {formatTournamentDate(tournament.startTime)}</span>
        <span className="seats-left">{seatsLeft} seats left</span>
      </div>
      <Link className="button button-block button-quiet" href={`/tournaments/${tournament.id}`}>
        View tournament <span aria-hidden="true">→</span>
      </Link>
    </article>
  );
}

function statusLabel(status: Tournament["status"]): string {
  return status === "REGISTRATION_OPEN"
    ? "Registration open"
    : status.charAt(0) + status.slice(1).toLowerCase().replaceAll("_", " ");
}
