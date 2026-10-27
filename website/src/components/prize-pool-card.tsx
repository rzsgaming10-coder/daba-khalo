import { calculatePrizeDistribution } from "@/lib/prize-engine";
import { formatMoney } from "@/lib/format";
import type { Tournament } from "@/types/tournament";

export function PrizePoolCard({ tournament }: { tournament: Tournament }) {
  const result = calculatePrizeDistribution(tournament);
  const progress = Math.min(
    100,
    Math.round((tournament.registeredPlayers / tournament.maximumPlayers) * 100),
  );
  return (
    <section className="panel prize-panel" aria-labelledby="prize-panel-title">
      <div className="section-eyebrow">Live prize estimate</div>
      <div className="prize-headline">
        <h2 id="prize-panel-title">{formatMoney(result.prizePoolMinor, tournament.currency)}</h2>
        <span>prize pool</span>
      </div>
      <p className="subtle-copy">Preview updates with the registration count. Final awards are confirmed by the tournament server.</p>
      <div className="registration-meter">
        <div className="meter-label"><span>Registered players</span><strong>{tournament.registeredPlayers} <small>/ {tournament.maximumPlayers}</small></strong></div>
        <div className="meter-track" role="progressbar" aria-label="Tournament registration" aria-valuenow={tournament.registeredPlayers} aria-valuemin={0} aria-valuemax={tournament.maximumPlayers}>
          <span style={{ width: `${progress}%` }} />
        </div>
      </div>
      <div className="prize-line">
        <span>Organizer share</span>        <strong>{formatMoney(result.adminShareMinor, tournament.currency)}</strong>
      </div>
      <div className="prize-divider" />
      {result.prizes.map((prize) => (
        <div className="prize-line" key={prize.position}>
          <span><span className="medal">{medal(prize.position)}</span> {ordinal(prize.position)} place</span>
          <strong>{formatMoney(prize.amountMinor, tournament.currency)}</strong>
        </div>
      ))}
      {result.error && <p className="inline-warning" role="status">{result.error}</p>}
      {result.remainingAmountMinor > 0 && !result.error && (
        <p className="remaining-copy">Unallocated balance: {formatMoney(result.remainingAmountMinor, tournament.currency)}</p>
      )}
    </section>
  );
}

function ordinal(value: number): string {
  const mod100 = value % 100;
  if (mod100 >= 11 && mod100 <= 13) return `${value}th`;
  return `${value}${({ 1: "st", 2: "nd", 3: "rd" } as Record<number, string>)[value % 10] ?? "th"}`;
}

function medal(position: number): string {
  return position === 1 ? "♛" : position === 2 ? "Ⅱ" : position === 3 ? "Ⅲ" : "·";
}
