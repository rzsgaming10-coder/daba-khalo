import { tournaments } from "@/services/tournament-seed";
import type { Tournament } from "@/types/tournament";

export interface TournamentRepository {
  list(): Promise<Tournament[]>;
  getById(id: string): Promise<Tournament | undefined>;
  register(tournamentId: string): Promise<Tournament>;
}

export class MockTournamentRepository implements TournamentRepository {
  private readonly records = new Map(
    tournaments.map((tournament) => [tournament.id, { ...tournament }]),
  );
  private readonly listeners = new Set<(tournament: Tournament) => void>();

  async list(): Promise<Tournament[]> {
    return [...this.records.values()].map((tournament) => ({ ...tournament }));
  }

  async getById(id: string): Promise<Tournament | undefined> {
    const tournament = this.records.get(id);
    return tournament ? { ...tournament } : undefined;
  }

  async register(tournamentId: string): Promise<Tournament> {
    const tournament = this.records.get(tournamentId);
    if (!tournament) throw new Error("Tournament not found.");
    if (tournament.status !== "REGISTRATION_OPEN") {
      throw new Error("Registration is not open for this tournament.");
    }
    if (tournament.registeredPlayers >= tournament.maximumPlayers) {
      throw new Error("This tournament has reached its player limit.");
    }

    const updated = { ...tournament, registeredPlayers: tournament.registeredPlayers + 1 };
    this.records.set(tournamentId, updated);
    this.listeners.forEach((listener) => listener({ ...updated }));
    return { ...updated };
  }

  subscribe(listener: (tournament: Tournament) => void): () => void {
    this.listeners.add(listener);
    return () => this.listeners.delete(listener);
  }
}

export const tournamentRepository = new MockTournamentRepository();
