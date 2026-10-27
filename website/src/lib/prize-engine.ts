import type {
  PrizeAward,
  PrizeResult,
  PrizeTier,
  Tournament,
  TournamentPrizeConfig,
} from "@/types/tournament";

const BASIS_POINTS = 10_000;

export function calculateGrossAmount(
  entryFeeMinor: number,
  registeredPlayers: number,
): number {
  assertNonNegativeInteger(entryFeeMinor, "Entry fee");
  assertNonNegativeInteger(registeredPlayers, "Registered players");
  const gross = BigInt(entryFeeMinor) * BigInt(registeredPlayers);
  if (gross > BigInt(Number.MAX_SAFE_INTEGER)) {
    throw new RangeError("Gross amount exceeds the safe integer limit.");
  }
  return Number(gross);
}

export function calculatePrizePool(tournament: Tournament): number {
  const result = calculatePrizeDistribution(tournament);
  if (result.error) throw new Error(result.error);
  return result.prizePoolMinor;
}

export function calculateAdminShare(tournament: Tournament): number {
  const result = calculatePrizeDistribution(tournament);
  if (result.error) throw new Error(result.error);
  return result.adminShareMinor;
}

export function calculatePrizeDistribution(
  tournament: Tournament,
  registeredPlayers = tournament.registeredPlayers,
): PrizeResult {
  const grossAmountMinor = calculateGrossAmount(
    tournament.entryFeeMinor,
    registeredPlayers,
  );
  const validation = validatePrizeDistribution(tournament.prizeConfig, grossAmountMinor);
  if (validation) {
    return {
      grossAmountMinor,
      adminShareMinor: 0,
      prizePoolMinor: 0,
      remainingAmountMinor: grossAmountMinor,
      prizes: [],
      error: validation,
    };
  }
  const config = resolveConfig(tournament.prizeConfig, registeredPlayers);
  if (!config) {
    return {
      grossAmountMinor,
      adminShareMinor: 0,
      prizePoolMinor: 0,
      remainingAmountMinor: grossAmountMinor,
      prizes: [],
      error: "No prize tier is configured for this player count.",
    };
  }

  let adminShareMinor: number;
  let prizes: Array<{ position: number; amountMinor: number }>;
  if (config.mode === "FIXED_AMOUNT") {
    adminShareMinor = config.adminShareMinor;
    prizes = config.prizes.map((prize) => ({
      position: prize.position,
      amountMinor: prize.amountMinor ?? 0,
    }));
  } else {
    adminShareMinor = percentOf(grossAmountMinor, config.adminShareBasisPoints);
    prizes = config.prizes.map((prize) => ({
      position: prize.position,
      amountMinor: percentOf(grossAmountMinor, prize.basisPoints ?? 0),
    }));
  }

  const distributed =
    adminShareMinor + prizes.reduce((sum, prize) => sum + prize.amountMinor, 0);
  return {
    grossAmountMinor,
    adminShareMinor,
    prizePoolMinor: prizes.reduce((sum, prize) => sum + prize.amountMinor, 0),
    remainingAmountMinor: grossAmountMinor - distributed,
    prizes,
  };
}

export function validatePrizeDistribution(
  config: TournamentPrizeConfig,
  grossAmountMinor: number,
): string | undefined {
  if (!Number.isSafeInteger(grossAmountMinor) || grossAmountMinor < 0) {
    return "Gross amount must be a non-negative safe integer.";
  }

  if (config.mode === "TIERED_PRIZE") {
    const tierError = validateTiers(config.tiers);
    if (tierError) return tierError;
    return config.tiers
      .map((tier) => validatePrizeDistribution(tierAsConfig(tier), grossAmountMinor))
      .find(Boolean);
  }

  if (config.mode === "FIXED_AMOUNT") {
    if (!isAmount(config.adminShareMinor)) {
      return "Admin share must be a non-negative safe integer.";
    }
    if (hasDuplicatePositions(config.prizes)) {
      return "Prize positions must be unique positive integers.";
    }
    if (config.prizes.some((prize) => !isAmount(prize.amountMinor))) {
      return "Prize amounts must be non-negative safe integers.";
    }
    const total =
      config.adminShareMinor +
      config.prizes.reduce((sum, prize) => sum + (prize.amountMinor ?? 0), 0);
    if (!Number.isSafeInteger(total) || total > grossAmountMinor) {
      return "Prize distribution exceeds available registration funds.";
    }
    return undefined;
  }

  if (!isBasisPoints(config.adminShareBasisPoints)) {
    return "Admin share must be between 0% and 100%.";
  }
  if (hasDuplicatePositions(config.prizes)) {
    return "Prize positions must be unique positive integers.";
  }
  if (config.prizes.some((prize) => !isBasisPoints(prize.basisPoints))) {
    return "Prize percentages must be between 0% and 100%.";
  }
  const total =
    config.adminShareBasisPoints +
    config.prizes.reduce((sum, prize) => sum + (prize.basisPoints ?? 0), 0);
  if (total > BASIS_POINTS) {
    return "Prize distribution exceeds available registration funds.";
  }
  return undefined;
}

export function calculateTier(
  tiers: PrizeTier[],
  registeredPlayers: number,
): PrizeTier | undefined {
  return tiers.find(
    (tier) =>
      registeredPlayers >= tier.minimumPlayers &&
      (tier.maximumPlayers === undefined ||
        registeredPlayers <= tier.maximumPlayers),
  );
}

export function getPrizeForPosition(
  result: PrizeResult,
  position: number,
): number {
  return result.prizes.find((prize) => prize.position === position)?.amountMinor ?? 0;
}

function resolveConfig(
  config: TournamentPrizeConfig,
  registeredPlayers: number,
): TournamentPrizeConfig | undefined {
  if (config.mode !== "TIERED_PRIZE") return config;
  const tier = calculateTier(config.tiers, registeredPlayers);
  return tier ? tierAsConfig(tier) : undefined;
}

function tierAsConfig(tier: PrizeTier) {
  return {
    mode: "PERCENTAGE" as const,
    adminShareBasisPoints: tier.adminShareBasisPoints,
    prizes: tier.prizes,
  };
}

function percentOf(amountMinor: number, basisPoints: number): number {
  return Number((BigInt(amountMinor) * BigInt(basisPoints)) / BigInt(BASIS_POINTS));
}

function hasDuplicatePositions(prizes: PrizeAward[]): boolean {
  const positions = new Set<number>();
  for (const prize of prizes) {
    if (!Number.isSafeInteger(prize.position) || prize.position < 1) return true;
    if (positions.has(prize.position)) return true;
    positions.add(prize.position);
  }
  return false;
}

function validateTiers(tiers: PrizeTier[]): string | undefined {
  if (tiers.length === 0) return "Configure at least one prize tier.";
  const sorted = [...tiers].sort((a, b) => a.minimumPlayers - b.minimumPlayers);
  for (const tier of sorted) {
    if (
      !Number.isSafeInteger(tier.minimumPlayers) ||
      tier.minimumPlayers < 1 ||
      (tier.maximumPlayers !== undefined &&
        (!Number.isSafeInteger(tier.maximumPlayers) ||
          tier.maximumPlayers < tier.minimumPlayers))
    ) {
      return "Prize tier player limits are invalid.";
    }
  }
  for (let index = 1; index < sorted.length; index += 1) {
    const previous = sorted[index - 1];
    if (
      previous.maximumPlayers === undefined ||
      previous.maximumPlayers >= sorted[index].minimumPlayers
    ) {
      return "Prize tiers must not overlap.";
    }
  }
  return undefined;
}

function isAmount(value: number | undefined): value is number {
  return value !== undefined && Number.isSafeInteger(value) && value >= 0;
}

function isBasisPoints(value: number | undefined): value is number {
  return (
    value !== undefined &&
    Number.isSafeInteger(value) &&
    value >= 0 &&
    value <= BASIS_POINTS
  );
}

function assertNonNegativeInteger(value: number, label: string): void {
  if (!Number.isSafeInteger(value) || value < 0) {
    throw new RangeError(`${label} must be a non-negative safe integer.`);
  }
}
