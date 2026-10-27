import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  int selectedCategory = 0;

  final List<String> categories = ['Global', 'Blitz', 'Rapid', 'Classical'];

  final List<_PlayerRanking> players = const [
    _PlayerRanking(
      rank: 1,
      name: 'Magnus Daba',
      rating: 2458,
      wins: 38,
      losses: 4,
      draws: 8,
      change: 12,
      avatar: Icons.person,
    ),
    _PlayerRanking(
      rank: 2,
      name: 'KnightMaster',
      rating: 2396,
      wins: 35,
      losses: 7,
      draws: 6,
      change: 8,
      avatar: Icons.person,
    ),
    _PlayerRanking(
      rank: 3,
      name: 'GoldenBishop',
      rating: 2352,
      wins: 32,
      losses: 8,
      draws: 9,
      change: -3,
      avatar: Icons.person,
    ),
    _PlayerRanking(
      rank: 4,
      name: 'ChessTiger',
      rating: 2298,
      wins: 29,
      losses: 10,
      draws: 7,
      change: 5,
      avatar: Icons.person,
    ),
    _PlayerRanking(
      rank: 5,
      name: 'RoyalKnight',
      rating: 2241,
      wins: 27,
      losses: 11,
      draws: 8,
      change: 2,
      avatar: Icons.person,
    ),
    _PlayerRanking(
      rank: 6,
      name: 'DabaPlayer',
      rating: 2189,
      wins: 25,
      losses: 13,
      draws: 7,
      change: -1,
      avatar: Icons.person,
    ),
    _PlayerRanking(
      rank: 7,
      name: 'RapidKing',
      rating: 2145,
      wins: 23,
      losses: 14,
      draws: 6,
      change: 7,
      avatar: Icons.person,
    ),
    _PlayerRanking(
      rank: 8,
      name: 'BlackCastle',
      rating: 2108,
      wins: 21,
      losses: 15,
      draws: 7,
      change: -4,
      avatar: Icons.person,
    ),
    _PlayerRanking(
      rank: 9,
      name: 'CheckMate',
      rating: 2067,
      wins: 20,
      losses: 16,
      draws: 5,
      change: 3,
      avatar: Icons.person,
    ),
    _PlayerRanking(
      rank: 10,
      name: 'BoardMaster',
      rating: 2025,
      wins: 18,
      losses: 17,
      draws: 6,
      change: 1,
      avatar: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildCategoryTabs(),
            _buildCurrentPlayerCard(),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 25),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: _RankingPlayerCard(player: players[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rankings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Top players on DABA KHALO',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF151515),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: Colors.white10),
            ),
            child: const Icon(Icons.search, color: Colors.white70, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: List.generate(categories.length, (index) {
            final selected = selectedCategory == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFD4AF37)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.white54,
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCurrentPlayerCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B2410), Color(0xFF141414)],
        ),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD4AF37),
              border: Border.all(color: const Color(0xFFFFE79A), width: 1.5),
            ),
            child: const Icon(Icons.person, color: Colors.black, size: 25),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Ranking',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                SizedBox(height: 3),
                Text(
                  '#128  •  Rating 1200',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+6',
                style: TextStyle(
                  color: Color(0xFF65D98A),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'this month',
                style: TextStyle(color: Colors.white38, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankingPlayerCard extends StatelessWidget {
  final _PlayerRanking player;

  const _RankingPlayerCard({required this.player});

  Color _rankColor() {
    if (player.rank == 1) {
      return const Color(0xFFFFD700);
    }

    if (player.rank == 2) {
      return const Color(0xFFC0C0C0);
    }

    if (player.rank == 3) {
      return const Color(0xFFCD7F32);
    }

    return Colors.white38;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: player.rank <= 3
              ? _rankColor().withValues(alpha: 0.25)
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '#${player.rank}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _rankColor(),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: player.rank <= 3
                  ? _rankColor().withValues(alpha: 0.12)
                  : const Color(0xFF202020),
              border: Border.all(
                color: player.rank <= 3
                    ? _rankColor().withValues(alpha: 0.35)
                    : Colors.white10,
              ),
            ),
            child: Icon(
              player.avatar,
              color: player.rank <= 3 ? _rankColor() : Colors.white54,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${player.wins}W  ${player.losses}L  ${player.draws}D',
                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${player.rating}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    player.change >= 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 10,
                    color: player.change >= 0
                        ? const Color(0xFF65D98A)
                        : Colors.redAccent,
                  ),
                  Text(
                    '${player.change.abs()}',
                    style: TextStyle(
                      color: player.change >= 0
                          ? const Color(0xFF65D98A)
                          : Colors.redAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerRanking {
  final int rank;
  final String name;
  final int rating;
  final int wins;
  final int losses;
  final int draws;
  final int change;
  final IconData avatar;

  const _PlayerRanking({
    required this.rank,
    required this.name,
    required this.rating,
    required this.wins,
    required this.losses,
    required this.draws,
    required this.change,
    required this.avatar,
  });
}
