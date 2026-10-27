import { describe, expect, it } from "vitest";
import { advanceWinner, generateSingleEliminationBracket } from "./bracket-engine";
import type { TournamentPlayer } from "../types/tournament";

const players: TournamentPlayer[] = Array.from({ length: 8 }, (_, index) => ({
  id: `p${index + 1}`,
  name: `Player ${index + 1}`,
  rating: 2000 - index * 10,
}));

describe("single elimination bracket engine", () => {
  it("generates round columns for a power-of-two bracket", () => {
    const rounds = generateSingleEliminationBracket(players);
    expect(rounds.map((round) => round.name)).toEqual(["Quarter-final", "Semi-final", "Final"]);
    expect(rounds.map((round) => round.matches.length)).toEqual([4, 2, 1]);
  });

  it("pads non-power-of-two fields and keeps empty seed slots explicit", () => {
    const rounds = generateSingleEliminationBracket(players.slice(0, 5));
    expect(rounds[0].name).toBe("Quarter-final");
    expect(rounds[0].matches).toHaveLength(4);
    expect(rounds[0].matches[2].playerOne).toBe(players[4]);
    expect(rounds[0].matches[2].playerTwo).toBeNull();
  });

  it("advances only a participant from a completed match", () => {
    const rounds = generateSingleEliminationBracket(players);
    rounds[0].matches[0].status = "FINAL";
    const advanced = advanceWinner(rounds, "r1-m1", players[0].id);
    expect(advanced[1].matches[0].playerOne?.id).toBe(players[0].id);
    expect(rounds[1].matches[0].playerOne).toBeNull();
    expect(() => advanceWinner(rounds, "r1-m2", players[2].id)).toThrow(/confirmed participant/i);
    expect(() => advanceWinner(rounds, "missing", players[0].id)).toThrow(/match not found/i);
  });
});
