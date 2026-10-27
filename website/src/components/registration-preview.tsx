"use client";

import { useEffect, useState } from "react";
import { calculatePrizeDistribution } from "@/lib/prize-engine";
import { formatMoney } from "@/lib/format";
import { tournamentRepository } from "@/services/tournament-repository";
import type { Tournament } from "@/types/tournament";

export function RegistrationPreview({ tournament: initialTournament }: { tournament: Tournament }) {
  const [tournament, setTournament] = useState(initialTournament);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");
  const result = calculatePrizeDistribution(tournament);
  const isOpen = tournament.status === "REGISTRATION_OPEN";
  const isFull = tournament.registeredPlayers >= tournament.maximumPlayers;

  useEffect(
    () =>
      tournamentRepository.subscribe((updated) => {
        if (updated.id === initialTournament.id) setTournament(updated);
      }),
    [initialTournament.id],
  );

  async function previewRegistration() {
    setMessage("");
    setError("");
    try {
      const updated = await tournamentRepository.register(tournament.id);
      setTournament(updated);
      setMessage("Local preview updated. No account, payment, or confirmed seat was created.");
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : "Could not update the local preview.");
    }
  }

  return (
    <section className="panel registration-panel">
      <div className="section-eyebrow">CLAIM YOUR SEAT</div>
      <div className="registration-price"><span>Entry fee</span><strong>{formatMoney(tournament.entryFeeMinor, tournament.currency)}</strong></div>
      <p>Prize pool preview: <strong className="gold-text">{formatMoney(result.prizePoolMinor, tournament.currency)}</strong></p>
      <button
        type="button"
        className="button button-gold button-block"
        onClick={previewRegistration}
        disabled={!isOpen || isFull}
      >
        {isFull ? "Tournament full" : isOpen ? "Preview registration" : "Registration closed"}
        <span aria-hidden="true">→</span>
      </button>
      <p className="preview-disclaimer">UI preview only. Payment and registration services are not connected; no payment is collected or seat confirmed.</p>
      {message && <p className="inline-success" role="status">{message}</p>}
      {error && <p className="inline-warning" role="alert">{error}</p>}
    </section>
  );
}
