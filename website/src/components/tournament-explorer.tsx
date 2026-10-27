"use client";

import { useMemo, useState } from "react";
import { TournamentCard } from "@/components/tournament-card";
import { calculatePrizeDistribution } from "@/lib/prize-engine";
import type { Tournament, TournamentFormat } from "@/types/tournament";

type StatusFilter = "ALL" | "REGISTRATION_OPEN" | "LIVE" | "COMPLETED";
type EntryFilter = "ALL" | "FREE" | "10" | "20" | "50" | "100";
type PrizeFilter = "ALL" | "0-100" | "100-500" | "500";

export function TournamentExplorer({ tournaments }: { tournaments: Tournament[] }) {
  const [query, setQuery] = useState("");
  const [format, setFormat] = useState<TournamentFormat | "ALL">("ALL");
  const [status, setStatus] = useState<StatusFilter>("ALL");
  const [entry, setEntry] = useState<EntryFilter>("ALL");
  const [prize, setPrize] = useState<PrizeFilter>("ALL");
  const filtered = useMemo(() => {
    const normalized = query.trim().toLowerCase();
    return tournaments.filter((tournament) => {
      const searchText = [
        tournament.name,
        tournament.id,
        tournament.organizer ?? "",
        ...(tournament.registeredPlayerNames ?? []),
      ].join(" ").toLowerCase();
      if (normalized && !searchText.includes(normalized)) return false;
      if (format !== "ALL" && tournament.format !== format) return false;
      if (status !== "ALL" && tournament.status !== status) return false;
      const fee = tournament.entryFeeMinor / 100;
      if (entry === "FREE" && fee !== 0) return false;
      if (entry !== "ALL" && entry !== "FREE") {
        const minimum = Number(entry);
        const maximum = entry === "10" ? 20 : entry === "20" ? 50 : entry === "50" ? 100 : Infinity;
        if (fee < minimum || fee >= maximum) return false;
      }
      const prizeEstimate = calculatePrizeDistribution(tournament).prizePoolMinor / 100;
      if (prize === "0-100" && (prizeEstimate < 0 || prizeEstimate > 100)) return false;
      if (prize === "100-500" && (prizeEstimate <= 100 || prizeEstimate > 500)) return false;
      if (prize === "500" && prizeEstimate <= 500) return false;
      return true;
    });
  }, [entry, format, prize, query, status, tournaments]);

  return (
    <>
      <div className="explorer-filters">
        <label className="search-field"><span aria-hidden="true">⌕</span><input aria-label="Search tournaments" placeholder="Search tournament, organizer, ID or player" value={query} onChange={(event) => setQuery(event.target.value)} /></label>
        <label className="filter-select"><span>FORMAT</span><select value={format} onChange={(event) => setFormat(event.target.value as TournamentFormat | "ALL")}><option value="ALL">All formats</option><option value="SWISS">Swiss</option><option value="SINGLE_ELIMINATION">Knockout</option><option value="DOUBLE_ELIMINATION">Double elimination</option><option value="ROUND_ROBIN">Round robin</option></select></label>
        <label className="filter-select"><span>STATUS</span><select value={status} onChange={(event) => setStatus(event.target.value as StatusFilter)}><option value="ALL">All statuses</option><option value="REGISTRATION_OPEN">Registration open</option><option value="LIVE">Live now</option><option value="COMPLETED">Completed</option></select></label>
        <label className="filter-select"><span>ENTRY FEE</span><select value={entry} onChange={(event) => setEntry(event.target.value as EntryFilter)}><option value="ALL">Any fee</option><option value="FREE">Free</option><option value="10">৳10–19</option><option value="20">৳20–29</option><option value="50">৳50–99</option><option value="100">৳100+</option></select></label>
        <label className="filter-select"><span>PRIZE POOL</span><select value={prize} onChange={(event) => setPrize(event.target.value as PrizeFilter)}><option value="ALL">Any prize</option><option value="0-100">৳0–100</option><option value="100-500">৳100–500</option><option value="500">৳500+</option></select></label>
      </div>
      <p className="result-count" aria-live="polite">{filtered.length} tournament{filtered.length === 1 ? "" : "s"} found</p>
      {filtered.length > 0 ? (
        <div className="tournament-grid tournament-list">
          {filtered.map((tournament) => <TournamentCard key={tournament.id} tournament={tournament} />)}
        </div>
      ) : (
        <div className="panel empty-state"><span aria-hidden="true">♙</span><strong>No tournaments match those filters.</strong><p>Try another search or clear a filter to see more of the arena.</p></div>
      )}
    </>
  );
}
