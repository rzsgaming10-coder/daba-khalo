const players = [
  { rank: 1, name: "Nabil Rahman", id: "DK-1021", rating: 2418, games: 186, winRate: "72%", earnings: "৳ 18,500", change: "+2" },
  { rank: 2, name: "Afsana Hossain", id: "DK-2088", rating: 2386, games: 204, winRate: "68%", earnings: "৳ 15,200", change: "+1" },
  { rank: 3, name: "Tanvir Ahmed", id: "DK-3140", rating: 2342, games: 158, winRate: "65%", earnings: "৳ 12,750", change: "−1" },
  { rank: 4, name: "Sadia Karim", id: "DK-4401", rating: 2298, games: 172, winRate: "63%", earnings: "৳ 9,300", change: "+3" },
  { rank: 5, name: "Mahmud Chowdhury", id: "DK-5350", rating: 2261, games: 141, winRate: "61%", earnings: "৳ 8,100", change: "−1" },
  { rank: 6, name: "Farhan Islam", id: "DK-6225", rating: 2217, games: 129, winRate: "59%", earnings: "৳ 6,450", change: "—" },
];

export default function RankingsPage() {
  return (
    <div className="shell page-section">
      <div className="page-heading">
        <span className="section-eyebrow">THE ORDER OF PLAY</span>
        <h1>Earn your <span>place.</span></h1>
        <p>Rankings reflect tournament performance and verified results.</p>
      </div>
      <div className="ranking-tabs"><span className="ranking-tab active">Global</span><span className="ranking-tab">Blitz</span><span className="ranking-tab">Rapid</span><span className="ranking-tab">Classical</span></div>
      <div className="panel ranking-panel">
        <div className="ranking-table-wrap">
          <table className="ranking-table">
            <thead><tr><th>Rank</th><th>Player</th><th>Rating</th><th>Games</th><th>Win rate</th><th>Tournament earnings</th><th>Change</th></tr></thead>
            <tbody>{players.map((player) => (
              <tr key={player.id}>
                <td><span className={`rank-number ${player.rank <= 3 ? "rank-podium" : ""}`}>{String(player.rank).padStart(2, "0")}</span></td>
                <td><div className="rank-player"><span className="rank-avatar">{player.name.slice(0, 1)}</span><span><strong>{player.name}</strong><small>{player.id}</small></span></div></td>
                <td className="rating-cell">{player.rating}</td><td>{player.games}</td><td>{player.winRate}</td><td className="gold-text">{player.earnings}</td><td className="change-cell">{player.change}</td>
              </tr>
            ))}</tbody>
          </table>
        </div>
        <p className="table-note">Development rankings use sample data and are not connected to a verified game server.</p>
      </div>
    </div>
  );
}
