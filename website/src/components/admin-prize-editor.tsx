"use client";

import { useMemo, useState } from "react";
import { calculateGrossAmount, calculatePrizeDistribution, validatePrizeDistribution } from "@/lib/prize-engine";
import { formatMoney } from "@/lib/format";
import { tournaments } from "@/services/tournament-seed";
import type { CurrencyCode, PrizeAward, PrizeTier, Tournament, TournamentPrizeConfig } from "@/types/tournament";

const baseTournament = tournaments[0];
const defaultTiers: PrizeTier[] = [
  { minimumPlayers: 16, maximumPlayers: 31, adminShareBasisPoints: 2_000, prizes: defaultPercentagePrizes() },
  { minimumPlayers: 32, maximumPlayers: 63, adminShareBasisPoints: 2_000, prizes: defaultPercentagePrizes() },
  { minimumPlayers: 64, adminShareBasisPoints: 2_000, prizes: defaultPercentagePrizes() },
];

export function AdminPrizeEditor() {
  const [entryFee, setEntryFee] = useState(baseTournament.entryFeeMinor);
  const [currency, setCurrency] = useState<CurrencyCode>(baseTournament.currency);
  const [players, setPlayers] = useState(baseTournament.registeredPlayers);
  const [maximumPlayers, setMaximumPlayers] = useState(baseTournament.maximumPlayers);
  const [mode, setMode] = useState<TournamentPrizeConfig["mode"]>("PERCENTAGE");
  const [percentageAdmin, setPercentageAdmin] = useState(2_000);
  const [percentagePrizes, setPercentagePrizes] = useState<PrizeAward[]>(defaultPercentagePrizes());
  const [fixedAdmin, setFixedAdmin] = useState(2_000);
  const [fixedPrizes, setFixedPrizes] = useState<PrizeAward[]>([
    { position: 1, amountMinor: 5_000 },
    { position: 2, amountMinor: 3_000 },
    { position: 3, amountMinor: 2_000 },
  ]);
  const [tiers, setTiers] = useState<PrizeTier[]>(defaultTiers);

  const config: TournamentPrizeConfig = useMemo(() => {
    if (mode === "FIXED_AMOUNT") return { mode, adminShareMinor: fixedAdmin, prizes: fixedPrizes };
    if (mode === "TIERED_PRIZE") return { mode, tiers };
    return { mode, adminShareBasisPoints: percentageAdmin, prizes: percentagePrizes };
  }, [fixedAdmin, fixedPrizes, mode, percentageAdmin, percentagePrizes, tiers]);

  const previewTournament: Tournament = { ...baseTournament, entryFeeMinor: entryFee, currency, registeredPlayers: players, maximumPlayers, prizeConfig: config };
  const gross = calculateGrossAmount(entryFee, players);
  const preview = calculatePrizeDistribution(previewTournament);
  const validation = validatePrizeDistribution(config, gross);
  const activeTier = mode === "TIERED_PRIZE"
    ? tiers.find((tier) => players >= tier.minimumPlayers && (tier.maximumPlayers === undefined || players <= tier.maximumPlayers))
    : undefined;
  const valid = !validation && !preview.error;

  function updatePercentagePrize(position: number, value: string) {
    const basisPoints = percentageToBasisPoints(value);
    setPercentagePrizes((current) => current.map((item) => item.position === position ? { ...item, basisPoints } : item));
  }

  function addPrize() {
    if (mode === "FIXED_AMOUNT") {
      setFixedPrizes((current) => [...current, { position: current.length + 1, amountMinor: 0 }]);
    } else if (mode === "PERCENTAGE") {
      setPercentagePrizes((current) => [...current, { position: current.length + 1, basisPoints: 0 }]);
    } else {
      if (!activeTier) return;
      setTiers((current) => current.map((tier) => tier.minimumPlayers === activeTier.minimumPlayers
        ? { ...tier, prizes: [...tier.prizes, { position: tier.prizes.length + 1, basisPoints: 0 }] }
        : tier));
    }
  }

  function removePrize(position: number) {
    const remove = (items: PrizeAward[]) => items.filter((item) => item.position !== position).map((item, index) => ({ ...item, position: index + 1 }));
    if (mode === "FIXED_AMOUNT") setFixedPrizes((current) => remove(current));
    else if (mode === "PERCENTAGE") setPercentagePrizes((current) => remove(current));
    else if (activeTier) setTiers((current) => current.map((tier) => tier.minimumPlayers === activeTier.minimumPlayers ? { ...tier, prizes: remove(tier.prizes) } : tier));
  }

  return (
    <div className="admin-editor-grid">
      <section className="panel editor-controls">
        <div className="editor-subhead"><h3>Prize configuration</h3><span className="preview-badge">NOT SAVED</span></div>
        <label className="field-label">Calculation mode
          <select value={mode} onChange={(event) => setMode(event.target.value as TournamentPrizeConfig["mode"])}>
            <option value="FIXED_AMOUNT">Fixed amount</option>
            <option value="PERCENTAGE">Percentage</option>
            <option value="TIERED_PRIZE">Tiered prize</option>
          </select>
        </label>
        <label className="field-label">Currency
          <select value={currency} onChange={(event) => setCurrency(event.target.value as CurrencyCode)}>
            <option value="BDT">Bangladeshi taka (BDT)</option>
            <option value="USD">US dollar (USD)</option>
            <option value="EUR">Euro (EUR)</option>
          </select>
        </label>
        <div className="form-grid">
          <label className="field-label">Entry fee ({currency})
            <input min="0" step="0.01" type="number" value={(entryFee / 100).toFixed(2)} onChange={(event) => setEntryFee(Math.min(Math.floor(Number.MAX_SAFE_INTEGER / Math.max(1, maximumPlayers)), Math.max(0, toMinorUnits(event.target.value))))} />
          </label>
          <label className="field-label">Registered players
            <input min="0" max={maximumPlayers} step="1" type="number" value={players} onChange={(event) => setPlayers(clampInteger(event.target.value, maximumPlayers))} />
          </label>
          <label className="field-label">Maximum players
            <input min="1" step="1" type="number" value={maximumPlayers} onChange={(event) => {
              const nextMaximum = Math.max(1, clampInteger(event.target.value, 10_000));
              setMaximumPlayers(nextMaximum);
              setPlayers((current) => Math.min(current, nextMaximum));
            }} />
          </label>
        </div>
        <p className="input-hint">Preview inputs only. The backend must recalculate and authorize financial records.</p>
        {mode === "FIXED_AMOUNT" ? (
          <>
            <MoneyEditor label="Organizer share" currency={currency} value={fixedAdmin} onChange={setFixedAdmin} />
            <AwardEditor prizes={fixedPrizes} currency={currency} amountType="money" onChange={(position, value) => setFixedPrizes((current) => current.map((item) => item.position === position ? { ...item, amountMinor: toMinorUnits(value) } : item))} onRemove={removePrize} />
          </>
        ) : mode === "PERCENTAGE" ? (
          <>
            <PercentEditor label="Organizer share" value={percentageAdmin} onChange={setPercentageAdmin} />
            <AwardEditor prizes={percentagePrizes} currency={currency} amountType="percent" onChange={updatePercentagePrize} onRemove={removePrize} />
          </>
        ) : (
          <div className="tier-list">
            <p className="input-hint">Tier ranges and their prize shares are previewed for the selected player count.</p>
            {tiers.map((tier, index) => (
              <div className={`tier-row ${activeTier === tier ? "tier-current" : ""}`} key={tier.minimumPlayers}>
                <label>From<input aria-label={`Tier ${index + 1} minimum players`} min="1" step="1" type="number" value={tier.minimumPlayers} onChange={(event) => setTiers((current) => current.map((item, itemIndex) => itemIndex === index ? { ...item, minimumPlayers: clampInteger(event.target.value, 10_000) } : item))} /></label>
                <label>Through<input aria-label={`Tier ${index + 1} maximum players`} min={tier.minimumPlayers} max={maximumPlayers} step="1" type="number" placeholder="No limit" value={tier.maximumPlayers ?? ""} onChange={(event) => setTiers((current) => current.map((item, itemIndex) => itemIndex === index ? { ...item, maximumPlayers: event.target.value === "" ? undefined : clampInteger(event.target.value, 10_000) } : item))} /></label>
                <button type="button" className="remove-prize" aria-label={`Remove tier ${index + 1}`} disabled={tiers.length < 2} onClick={() => setTiers((current) => current.filter((_, itemIndex) => itemIndex !== index))}>×</button>
                <span>Organizer {tier.adminShareBasisPoints / 100}% · {tier.prizes.length} prize positions</span>
              </div>
            ))}
            <button className="button button-outline" disabled={(tiers.at(-1)?.minimumPlayers ?? 0) >= maximumPlayers} type="button" onClick={() => setTiers((current) => {
              const minimumPlayers = (current.at(-1)?.maximumPlayers ?? current.at(-1)?.minimumPlayers ?? 0) + 1;
              const previous = current.map((tier, index) => index === current.length - 1 ? { ...tier, maximumPlayers: minimumPlayers - 1 } : tier);
              if (minimumPlayers > maximumPlayers) return current;
              return [...previous, { minimumPlayers, adminShareBasisPoints: 2_000, prizes: defaultPercentagePrizes() }];
            })}>
              Add player tier
            </button>
            <div className="tier-editor">
              <strong>Edit selected tier</strong>
              {activeTier ? (
                <>
                  <PercentEditor label="Organizer share" value={activeTier.adminShareBasisPoints} onChange={(value) => setTiers((current) => current.map((tier) => tier === activeTier ? { ...tier, adminShareBasisPoints: value } : tier))} />
                  <AwardEditor prizes={activeTier.prizes} currency={currency} amountType="percent" onChange={(position, value) => setTiers((current) => current.map((tier) => tier.minimumPlayers === activeTier.minimumPlayers ? { ...tier, prizes: tier.prizes.map((item) => item.position === position ? { ...item, basisPoints: percentageToBasisPoints(value) } : item) } : tier))} onRemove={removePrize} />
                </>
              ) : <p className="input-hint">No tier covers {players} players.</p>}
            </div>
          </div>
        )}
        <button className="button button-outline add-prize-button" type="button" onClick={addPrize}>＋ Add prize position</button>
      </section>
      <section className="panel editor-preview" aria-live="polite">
        <div className="section-eyebrow">CALCULATION PREVIEW</div>
        <div className="preview-gross"><span>Gross registration</span><strong>{formatMoney(gross, currency)}</strong></div>
        <p className="input-hint">{players} entries × {formatMoney(entryFee, currency)} per player</p>
        <div className="prize-divider" />
        {mode === "TIERED_PRIZE" && <div className="preview-row"><span>Active tier</span><strong>{activeTier ? `${activeTier.minimumPlayers}–${activeTier.maximumPlayers ?? "+"} players` : "No matching tier"}</strong></div>}
        <div className="preview-row"><span>Organizer share</span><strong>{formatMoney(preview.adminShareMinor, currency)}</strong></div>
        {preview.prizes.map((prize) => (
          <div className="preview-row" key={prize.position}><span>{ordinal(prize.position)} place</span><strong>{formatMoney(prize.amountMinor, currency)}</strong></div>
        ))}
        <div className="preview-row preview-pool"><span>Total player prizes</span><strong>{formatMoney(preview.prizePoolMinor, currency)}</strong></div>
        <div className="preview-row"><span>Unallocated balance</span><strong>{formatMoney(preview.remainingAmountMinor, currency)}</strong></div>
        <div className={`validation-message ${valid ? "validation-good" : "validation-bad"}`} role="status">
          <span aria-hidden="true">{valid ? "✓" : "!"}</span>
          {valid ? "Prize distribution is within available registration funds." : validation ?? preview.error}
        </div>
        {players < baseTournament.minimumPlayers && <p className="inline-warning">Minimum player count has not been reached. The tournament is not ready to start.</p>}
        <p className="input-hint">This local preview is not persisted and is never authoritative for payments or payouts.</p>
      </section>
    </div>
  );
}

function MoneyEditor({ label, currency, value, onChange }: { label: string; currency: CurrencyCode; value: number; onChange: (value: number) => void }) {
  return <label className="field-label">{label} ({currency})<input min="0" step="0.01" type="number" value={(value / 100).toFixed(2)} onChange={(event) => onChange(toMinorUnits(event.target.value))} /></label>;
}

function PercentEditor({ label, value, onChange }: { label: string; value: number; onChange: (value: number) => void }) {
  return <label className="field-label">{label} (%)<input min="0" max="100" step="0.01" type="number" value={(value / 100).toFixed(2)} onChange={(event) => onChange(percentageToBasisPoints(event.target.value))} /></label>;
}

function AwardEditor({ prizes, amountType, currency, onChange, onRemove }: { prizes: PrizeAward[]; amountType: "money" | "percent"; currency: CurrencyCode; onChange: (position: number, value: string) => void; onRemove: (position: number) => void }) {
  return (
    <div className="award-editor">
      <div className="award-editor-heading"><span>Position</span><span>{amountType === "money" ? `Amount (${currency})` : "Share (%)"}</span><span /></div>
      {prizes.map((prize) => (
        <div className="award-editor-row" key={prize.position}>
          <span>{ordinal(prize.position)}</span>
          <input aria-label={`${ordinal(prize.position)} prize ${amountType}`} min="0" step={amountType === "money" ? "0.01" : "0.01"} type="number" value={amountType === "money" ? ((prize.amountMinor ?? 0) / 100).toFixed(2) : ((prize.basisPoints ?? 0) / 100).toFixed(2)} onChange={(event) => onChange(prize.position, event.target.value)} />
          <button type="button" className="remove-prize" aria-label={`Remove ${ordinal(prize.position)} prize`} onClick={() => onRemove(prize.position)}>×</button>
        </div>
      ))}
    </div>
  );
}

function defaultPercentagePrizes(): PrizeAward[] {
  return [
    { position: 1, basisPoints: 3_000 },
    { position: 2, basisPoints: 2_000 },
    { position: 3, basisPoints: 1_500 },
    { position: 4, basisPoints: 1_000 },
    { position: 5, basisPoints: 500 },
  ];
}

function percentageToBasisPoints(value: string): number {
  const parsed = Number(value);
  if (!Number.isFinite(parsed)) return -1;
  const basisPoints = Math.round(parsed * 100);
  return Number.isSafeInteger(basisPoints) ? basisPoints : Number.MAX_SAFE_INTEGER;
}

function toMinorUnits(value: string): number {
  const parsed = Number(value);
  if (!Number.isFinite(parsed)) return -1;
  const minorUnits = Math.round(parsed * 100);
  return Number.isSafeInteger(minorUnits)
    ? minorUnits
    : Math.sign(parsed) * Number.MAX_SAFE_INTEGER;
}

function clampInteger(value: string, maximum: number): number {
  const parsed = Number(value);
  if (!Number.isSafeInteger(parsed) || parsed < 0) return 0;
  return Math.min(parsed, maximum);
}

function ordinal(value: number): string {
  const mod100 = value % 100;
  if (mod100 >= 11 && mod100 <= 13) return `${value}th`;
  return `${value}${({ 1: "st", 2: "nd", 3: "rd" } as Record<number, string>)[value % 10] ?? "th"}`;
}
