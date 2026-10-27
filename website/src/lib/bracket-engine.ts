import type { TournamentMatch, TournamentPlayer } from "@/types/tournament";

export interface BracketRound {
  name: string;
  matches: TournamentMatch[];
}

export function generateSingleEliminationBracket(
  players: TournamentPlayer[],
): BracketRound[] {
  if (players.length < 2) return [];
  const bracketSize = 2 ** Math.ceil(Math.log2(players.length));
  const firstRoundMatchCount = bracketSize / 2;
  const roundCount = Math.log2(bracketSize);
  const rounds: BracketRound[] = [];

  for (let roundIndex = 0; roundIndex < roundCount; roundIndex += 1) {
    const matchCount = firstRoundMatchCount / 2 ** roundIndex;
    rounds.push({
      name: roundName(roundCount - roundIndex, bracketSize),
      matches: Array.from({ length: matchCount }, (_, matchIndex) => ({
        id: `r${roundIndex + 1}-m${matchIndex + 1}`,
        round: roundName(roundCount - roundIndex, bracketSize),
        status: "UPCOMING" as const,
        playerOne: roundIndex === 0 ? players[matchIndex * 2] ?? null : null,
        playerTwo: roundIndex === 0 ? players[matchIndex * 2 + 1] ?? null : null,
      })),
    });
  }
  return rounds;
}

export function advanceWinner(
  rounds: BracketRound[],
  matchId: string,
  winnerId: string,
): BracketRound[] {
  const next = structuredClone(rounds);
  for (let roundIndex = 0; roundIndex < next.length; roundIndex += 1) {
    const matchIndex = next[roundIndex].matches.findIndex((match) => match.id === matchId);
    if (matchIndex < 0) continue;
    const match = next[roundIndex].matches[matchIndex];
    const winner =
      match.playerOne?.id === winnerId
        ? match.playerOne
        : match.playerTwo?.id === winnerId
          ? match.playerTwo
          : undefined;
    if (!winner || match.status !== "FINAL") {
      throw new Error("Only a confirmed participant in a final match can advance.");
    }
    if (roundIndex < next.length - 1) {
      const nextMatch = next[roundIndex + 1].matches[Math.floor(matchIndex / 2)];
      if (matchIndex % 2 === 0) nextMatch.playerOne = winner;
      else nextMatch.playerTwo = winner;
    }
    return next;
  }
  throw new Error("Match not found.");
}

function roundName(roundsRemaining: number, bracketSize: number): string {
  if (roundsRemaining === 1) return "Final";
  if (roundsRemaining === 2) return "Semi-final";
  if (roundsRemaining === 3) return "Quarter-final";
  return `Round of ${2 ** roundsRemaining}`;
}
