import { describe, expect, it } from "vitest";
import {
  calculateGrossAmount,
  calculatePrizeDistribution,
  calculateTier,
  getPrizeForPosition,
  validatePrizeDistribution,
} from "./prize-engine";
import type { Tournament, TournamentPrizeConfig } from "../types/tournament";

function tournament(prizeConfig: TournamentPrizeConfig, overrides: Partial<Tournament> = {}): Tournament {
  return {
    id: "test",
    name: "Test tournament",
    description: "",
    entryFeeMinor: 1_000,
    currency: "BDT",
    registeredPlayers: 20,
    minimumPlayers: 2,
    maximumPlayers: 64,
    startTime: "2026-11-01T10:00:00Z",
    registrationDeadline: "2026-11-01T09:00:00Z",
    format: "SWISS",
    timeControl: "5 + 0",
    status: "REGISTRATION_OPEN",
    prizeConfig,
    ...overrides,
  };
}

describe("prize engine", () => {
  it("calculates gross registration in integer minor units", () => {
    expect(calculateGrossAmount(1_000, 20)).toBe(20_000);
    expect(calculateGrossAmount(0, 20)).toBe(0);
    expect(() => calculateGrossAmount(1.5, 2)).toThrow(RangeError);
    expect(() => calculateGrossAmount(Number.MAX_SAFE_INTEGER, 2)).toThrow(RangeError);
  });

  it("allocates percentage shares from the live gross amount", () => {
    const config: TournamentPrizeConfig = {
      mode: "PERCENTAGE",
      adminShareBasisPoints: 2_000,
      prizes: [
        { position: 1, basisPoints: 3_000 },
        { position: 2, basisPoints: 2_000 },
        { position: 3, basisPoints: 1_500 },
        { position: 4, basisPoints: 1_000 },
        { position: 5, basisPoints: 500 },
      ],
    };
    const result = calculatePrizeDistribution(tournament(config));
    expect(result.grossAmountMinor).toBe(20_000);
    expect(result.adminShareMinor).toBe(4_000);
    expect(result.prizePoolMinor).toBe(16_000);
    expect(result.remainingAmountMinor).toBe(0);
    expect(getPrizeForPosition(result, 1)).toBe(6_000);
    expect(getPrizeForPosition(result, 5)).toBe(1_000);
  });

  it("keeps rounding remainders and rejects percentage over-allocation", () => {
    const rounded = calculatePrizeDistribution(
      tournament({
        mode: "PERCENTAGE",
        adminShareBasisPoints: 3_333,
        prizes: [{ position: 1, basisPoints: 3_333 }],
      }, { entryFeeMinor: 1, registeredPlayers: 1 }),
    );
    expect(rounded.remainingAmountMinor).toBe(1);

    const invalid = validatePrizeDistribution({
      mode: "PERCENTAGE",
      adminShareBasisPoints: 7_000,
      prizes: [{ position: 1, basisPoints: 4_000 }],
    }, 20_000);
    expect(invalid).toMatch(/exceeds available/i);
  });

  it("validates fixed amounts and preserves unallocated funds", () => {
    const config: TournamentPrizeConfig = {
      mode: "FIXED_AMOUNT",
      adminShareMinor: 2_000,
      prizes: [{ position: 1, amountMinor: 5_000 }, { position: 2, amountMinor: 3_000 }],
    };
    const result = calculatePrizeDistribution(tournament(config));
    expect(result.remainingAmountMinor).toBe(10_000);
    expect(validatePrizeDistribution({
      ...config,
      prizes: [...config.prizes, { position: 3, amountMinor: 11_000 }],
    }, 20_000)).toMatch(/exceeds available/i);
  });

  it("selects tiers at boundaries and surfaces missing tiers", () => {
    const tiers = [
      { minimumPlayers: 10, maximumPlayers: 19, adminShareBasisPoints: 2_000, prizes: [{ position: 1, basisPoints: 8_000 }] },
      { minimumPlayers: 20, adminShareBasisPoints: 2_000, prizes: [{ position: 1, basisPoints: 8_000 }] },
    ];
    expect(calculateTier(tiers, 19)).toBe(tiers[0]);
    expect(calculateTier(tiers, 20)).toBe(tiers[1]);
    expect(calculatePrizeDistribution(tournament({ mode: "TIERED_PRIZE", tiers }, { registeredPlayers: 9 })).error)
      .toMatch(/no prize tier/i);
    const overlappingConfig: TournamentPrizeConfig = {
      mode: "TIERED_PRIZE",
      tiers: [
        { minimumPlayers: 10, maximumPlayers: 20, adminShareBasisPoints: 0, prizes: [] },
        { minimumPlayers: 20, adminShareBasisPoints: 0, prizes: [] },
      ],
    };
    expect(validatePrizeDistribution(overlappingConfig, 10_000)).toMatch(/must not overlap/i);
    expect(calculatePrizeDistribution(tournament(overlappingConfig)).error).toMatch(/must not overlap/i);
  });
});
