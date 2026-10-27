"use client";

import { useState } from "react";
import { TournamentBracket } from "@/components/tournament-bracket";
import type { TournamentFormat } from "@/types/tournament";

const swissRounds = [
  [{ board: 1, white: "N. Rahman", black: "A. Hossain", result: "1 – 0" }, { board: 2, white: "T. Ahmed", black: "S. Karim", result: "½ – ½" }, { board: 3, white: "M. Chowdhury", black: "F. Islam", result: "—" }],
  [{ board: 1, white: "N. Rahman", black: "T. Ahmed", result: "—" }, { board: 2, white: "A. Hossain", black: "M. Chowdhury", result: "—" }, { board: 3, white: "S. Karim", black: "R. Hasan", result: "—" }],
  [{ board: 1, white: "T. Ahmed", black: "A. Hossain", result: "—" }, { board: 2, white: "N. Rahman", black: "S. Karim", result: "—" }, { board: 3, white: "F. Islam", black: "I. Khan", result: "—" }],
  [{ board: 1, white: "N. Rahman", black: "M. Chowdhury", result: "—" }, { board: 2, white: "A. Hossain", black: "S. Karim", result: "—" }, { board: 3, white: "T. Ahmed", black: "F. Islam", result: "—" }],
  [{ board: 1, white: "Top seed", black: "Second seed", result: "—" }, { board: 2, white: "Third seed", black: "Fourth seed", result: "—" }],
];

const standings = [
  { rank: 1, name: "N. Rahman", points: 4.5, wins: 4, draws: 1, losses: 0 },
  { rank: 2, name: "A. Hossain", points: 4, wins: 4, draws: 0, losses: 1 },
  { rank: 3, name: "T. Ahmed", points: 3.5, wins: 3, draws: 1, losses: 1 },
  { rank: 4, name: "S. Karim", points: 3, wins: 3, draws: 0, losses: 2 },
];

export function TournamentRoadmap({ format }: { format: TournamentFormat }) {
  if (format === "SWISS") return <SwissRoadmap />;
  if (format === "ROUND_ROBIN") return <RoundRobinRoadmap />;
  return (
    <div>
      {format === "DOUBLE_ELIMINATION" && (
        <p className="roadmap-note">The bracket below illustrates the opening winner&apos;s bracket. Match results and loser-bracket progression are not connected to a tournament server.</p>
      )}
      <TournamentBracket />
      <p className="roadmap-note">Illustrative 8-player layout with sample players. Live fixtures and advancement are server-authoritative.</p>
    </div>
  );
}

function SwissRoadmap() {
  const [selectedRound, setSelectedRound] = useState(0);
  const matches = swissRounds[selectedRound];
  return (
    <div className="swiss-roadmap">
      <div className="swiss-round-picker" role="tablist" aria-label="Swiss tournament rounds">
        {swissRounds.map((round, index) => (
          <button
            aria-selected={selectedRound === index}
            className={`swiss-round-button ${selectedRound === index ? "selected" : ""}`}
            key={index}
            onClick={() => setSelectedRound(index)}
            role="tab"
            type="button"
          >
            <span>ROUND {index + 1}</span><strong>{round.length} boards</strong>
          </button>
        ))}
        <span className="swiss-final-step">Final standings</span>
      </div>
      <div className="swiss-round-content" role="tabpanel">
        <div className="swiss-round-title">
          <div><span className="section-eyebrow">ROUND {selectedRound + 1} · SAMPLE FIXTURES</span><h3>{selectedRound === 4 ? "Final round" : "Pairings & results"}</h3></div>
          <span className="format-label">20 player field</span>
        </div>
        <div className="pairing-list">
          {matches.map((match) => (
            <div className="pairing-row" key={match.board}>
              <span className="pairing-board">BOARD {String(match.board).padStart(2, "0")}</span>
              <strong>{match.white}</strong><span className="pairing-vs">vs</span><strong>{match.black}</strong>
              <span className="pairing-result">{match.result}</span>
            </div>
          ))}
        </div>
        <p className="roadmap-note">Sample roadmap only. Official pairings, scores, and standings must come from the tournament service.</p>
      </div>
    </div>
  );
}

function RoundRobinRoadmap() {
  return (
    <div className="round-robin">
      <div className="round-robin-heading"><span className="section-eyebrow">GROUP TABLE · SAMPLE DATA</span><span className="format-label">All-play-all</span></div>
      <div className="ranking-table-wrap">
        <table className="ranking-table">
          <thead><tr><th>Rank</th><th>Player</th><th>Points</th><th>Wins</th><th>Draws</th><th>Losses</th></tr></thead>
          <tbody>{standings.map((player) => (
            <tr key={player.rank}><td><span className={`rank-number ${player.rank === 1 ? "rank-podium" : ""}`}>{String(player.rank).padStart(2, "0")}</span></td><td><strong>{player.name}</strong></td><td className="gold-text">{player.points}</td><td>{player.wins}</td><td>{player.draws}</td><td>{player.losses}</td></tr>
          ))}</tbody>
        </table>
      </div>
      <p className="roadmap-note">Sample standings only. Official results and tie-break rules are not connected.</p>
    </div>
  );
}
