export type TournamentFormat =
  | "SINGLE_ELIMINATION"
  | "DOUBLE_ELIMINATION"
  | "SWISS"
  | "ROUND_ROBIN";

export type CurrencyCode = "BDT" | "USD" | "EUR";

export type TournamentStatus =
  | "DRAFT"
  | "REGISTRATION_OPEN"
  | "REGISTRATION_CLOSED"
  | "READY"
  | "LIVE"
  | "COMPLETED"
  | "CANCELLED"
  | "PAUSED";

export type PrizeMode = "FIXED_AMOUNT" | "PERCENTAGE" | "TIERED_PRIZE";

export interface PrizeAward {
  position: number;
  amountMinor?: number;
  basisPoints?: number;
}

export interface FixedPrizeConfig {
  mode: "FIXED_AMOUNT";
  adminShareMinor: number;
  prizes: PrizeAward[];
}

export interface PercentagePrizeConfig {
  mode: "PERCENTAGE";
  adminShareBasisPoints: number;
  prizes: PrizeAward[];
}

export interface PrizeTier {
  minimumPlayers: number;
  maximumPlayers?: number;
  adminShareBasisPoints: number;
  prizes: PrizeAward[];
}

export interface TieredPrizeConfig {
  mode: "TIERED_PRIZE";
  tiers: PrizeTier[];
}

export type TournamentPrizeConfig =
  | FixedPrizeConfig
  | PercentagePrizeConfig
  | TieredPrizeConfig;

export interface Tournament {
  id: string;
  name: string;
  description: string;
  entryFeeMinor: number;
  currency: CurrencyCode;
  registeredPlayers: number;
  minimumPlayers: number;
  maximumPlayers: number;
  organizer?: string;
  registeredPlayerNames?: string[];
  startTime: string;
  registrationDeadline: string;
  format: TournamentFormat;
  timeControl: string;
  status: TournamentStatus;
  prizeConfig: TournamentPrizeConfig;
  featured?: boolean;
}

export interface PrizeResult {
  grossAmountMinor: number;
  adminShareMinor: number;
  prizePoolMinor: number;
  remainingAmountMinor: number;
  prizes: Array<{ position: number; amountMinor: number }>;
  error?: string;
}

export interface TournamentPlayer {
  id: string;
  name: string;
  rating: number;
}

export interface TournamentMatch {
  id: string;
  round: string;
  status: "UPCOMING" | "LIVE" | "FINAL";
  playerOne: TournamentPlayer | null;
  playerTwo: TournamentPlayer | null;
  scoreOne?: number;
  scoreTwo?: number;
  winnerId?: string;
}

export interface TournamentRegistration {
  id: string;
  tournamentId: string;
  playerId: string;
  entryFeeMinor: number;
  paymentId: string;
  status: "PENDING_PAYMENT" | "CONFIRMED" | "CANCELLED" | "REFUNDED";
  registeredAt: string;
}

export interface TournamentRound {
  id: string;
  tournamentId: string;
  roundNumber: number;
  name: string;
  status: "UPCOMING" | "LIVE" | "COMPLETED";
  matches: TournamentMatch[];
}

export interface TournamentStanding {
  tournamentId: string;
  playerId: string;
  rank: number;
  points: number;
  wins: number;
  draws: number;
  losses: number;
  buchholz?: number;
}

export interface TournamentPayout {
  id: string;
  tournamentId: string;
  playerId: string;
  position: number;
  amountMinor: number;
  status: "PENDING" | "PROCESSING" | "PAID" | "FAILED" | "REFUNDED";
}

export interface TournamentBracketNode {
  matchId: string;
  roundNumber: number;
  participantIds: [string | null, string | null];
  winnerId?: string;
  nextMatchId?: string;
}

export interface TournamentSettings {
  registrationOpensAt: string;
  registrationDeadline: string;
  startTime: string;
  minimumPlayers: number;
  maximumPlayers: number;
  timeControl: string;
  prizeConfig: TournamentPrizeConfig;
}
