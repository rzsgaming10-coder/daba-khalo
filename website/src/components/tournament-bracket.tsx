import { generateSingleEliminationBracket } from "@/lib/bracket-engine";
import type { TournamentPlayer } from "@/types/tournament";

const samplePlayers: TournamentPlayer[] = [
  { id: "p1", name: "N. Rahman", rating: 2148 },
  { id: "p2", name: "A. Hossain", rating: 2071 },
  { id: "p3", name: "T. Ahmed", rating: 2016 },
  { id: "p4", name: "S. Karim", rating: 1988 },
  { id: "p5", name: "M. Chowdhury", rating: 1942 },
  { id: "p6", name: "F. Islam", rating: 1910 },
  { id: "p7", name: "R. Hasan", rating: 1876 },
  { id: "p8", name: "I. Khan", rating: 1844 },
];

export function TournamentBracket() {
  const rounds = generateSingleEliminationBracket(samplePlayers);
  return (
    <div className="bracket-scroll" tabIndex={0} aria-label="Tournament knockout bracket. Scroll horizontally to see all rounds.">
      <div className="bracket">
        {rounds.map((round, roundIndex) => (
          <section className={`bracket-round round-${roundIndex}`} key={round.name}>
            <h3>{round.name}</h3>
            <div className="match-stack">
              {round.matches.map((match) => (
                <article className="match-box" key={match.id}>
                  <div className="match-meta"><span>{match.status === "LIVE" ? "● LIVE" : "BOARD 01"}</span><span>—</span></div>
                  <PlayerRow player={match.playerOne} />
                  <PlayerRow player={match.playerTwo} />
                </article>
              ))}
            </div>
          </section>
        ))}
        <section className="champion-column">
          <h3>Champion</h3>
          <div className="champion-card">
            <span className="trophy" aria-hidden="true">♛</span>
            <span className="champion-label">TITLE HOLDER</span>
            <strong>To be decided</strong>
            <span className="subtle-copy">The final is yet to be played</span>
          </div>
        </section>
      </div>
    </div>
  );
}

function PlayerRow({ player }: { player: TournamentPlayer | null }) {
  return (
    <div className="player-row">
      <span className={`player-initial ${player ? "" : "player-empty"}`} aria-hidden="true">
        {player?.name.slice(0, 1) ?? "—"}
      </span>
      <span className="player-name">{player?.name ?? "Winner of previous match"}</span>
      <span className="player-rating">{player?.rating ?? "—"}</span>
    </div>
  );
}
