import { TournamentExplorer } from "@/components/tournament-explorer";
import { tournaments } from "@/services/tournament-seed";

export default function TournamentsPage() {
  return (
    <div className="shell page-section">
      <div className="page-heading">
        <span className="section-eyebrow">THE COMPETITION</span>
        <h1>Every game has <span>stakes.</span></h1>
        <p>Find your field, study the prize pool, and make your next move.</p>
      </div>
      <TournamentExplorer tournaments={tournaments} />
    </div>
  );
}
