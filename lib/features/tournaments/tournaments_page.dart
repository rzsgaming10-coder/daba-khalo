import 'package:flutter/material.dart';

import '../../core/models/tournament_models.dart';
import 'tournament_details_page.dart';

class TournamentsPage extends StatefulWidget {
  const TournamentsPage({super.key});

  @override
  State<TournamentsPage> createState() => _TournamentsPageState();
}

class _TournamentsPageState extends State<TournamentsPage> {
  int selectedTab = 0;

  final List<String> tabs = const ['Upcoming', 'Live', 'Completed'];

  final List<TournamentCardData> upcomingTournaments = const [
    TournamentCardData(
      title: 'DABA GOLD CUP',
      subtitle: 'Swiss • 7 Rounds • 10 + 0',
      prize: '৳50,000',
      players: '128 Players',
      time: 'Today • 8:00 PM',
      status: 'Registration Open',
      icon: Icons.emoji_events,
      stake: 20,
      entryFee: 500,
      prizePool: 50000,
    ),
    TournamentCardData(
      title: 'WEEKEND BLITZ',
      subtitle: 'Swiss • 9 Rounds • 3 + 0',
      prize: '৳20,000',
      players: '96 Players',
      time: 'Tomorrow • 4:00 PM',
      status: 'Registration Open',
      icon: Icons.bolt,
      stake: 10,
      entryFee: 200,
      prizePool: 20000,
    ),
    TournamentCardData(
      title: 'RAPID CHAMPIONSHIP',
      subtitle: 'Swiss • 8 Rounds • 10 + 5',
      prize: '৳35,000',
      players: '160 Players',
      time: '26 Oct • 7:00 PM',
      status: 'Registration Open',
      icon: Icons.speed,
      stake: 50,
      entryFee: 350,
      prizePool: 35000,
    ),
    TournamentCardData(
      title: 'NIGHT ARENA',
      subtitle: 'Arena • 60 Minutes • 5 + 0',
      prize: '৳15,000',
      players: '80 Players',
      time: '27 Oct • 10:00 PM',
      status: 'Coming Soon',
      icon: Icons.nightlight_round,
      stake: 100,
      entryFee: 150,
      prizePool: 15000,
    ),
  ];

  final List<TournamentCardData> liveTournaments = const [
    TournamentCardData(
      title: 'DABA RAPID',
      subtitle: 'Swiss • Round 5 of 7 • 10 + 0',
      prize: '৳30,000',
      players: '120 Players',
      time: 'Round 5 Live',
      status: 'LIVE NOW',
      icon: Icons.flash_on,
      live: true,
      stake: 20,
      entryFee: 300,
      prizePool: 30000,
    ),
    TournamentCardData(
      title: 'BLITZ ARENA',
      subtitle: 'Arena • 3 + 0 • 45 Minutes',
      prize: '৳10,000',
      players: '72 Players',
      time: 'Round in progress',
      status: 'LIVE NOW',
      icon: Icons.bolt,
      live: true,
      stake: 10,
      entryFee: 100,
      prizePool: 10000,
    ),
  ];

  final List<TournamentCardData> completedTournaments = const [
    TournamentCardData(
      title: 'NEW YEAR CUP',
      subtitle: 'Swiss • 7 Rounds • 10 + 0',
      prize: '৳40,000',
      players: '128 Players',
      time: 'Completed • 20 Oct',
      status: 'Completed',
      icon: Icons.emoji_events,
      stake: 50,
      entryFee: 400,
      prizePool: 40000,
    ),
    TournamentCardData(
      title: 'BEGINNER CUP',
      subtitle: 'Swiss • 5 Rounds • 10 + 0',
      prize: '৳8,000',
      players: '64 Players',
      time: 'Completed • 18 Oct',
      status: 'Completed',
      icon: Icons.school,
      stake: 20,
      entryFee: 80,
      prizePool: 8000,
    ),
  ];

  List<TournamentCardData> get currentTournaments {
    if (selectedTab == 0) {
      return upcomingTournaments;
    }

    if (selectedTab == 1) {
      return liveTournaments;
    }

    return completedTournaments;
  }

  void openTournamentDetails(TournamentCardData tournament) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TournamentDetailsPage(tournamentName: tournament.title);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tournaments = currentTournaments;

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: tournaments.isEmpty
                  ? _EmptyTournamentState(tabName: tabs[selectedTab])
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: tournaments.length,
                      itemBuilder: (context, index) {
                        final tournament = tournaments[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TournamentCard(
                            tournament: tournament,
                            onTap: () {
                              openTournamentDetails(tournament);
                            },
                          ),
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
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tournaments',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Find your next chess challenge',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          _HeaderIconButton(
            icon: Icons.search,
            onPressed: () {
              _showSearchMessage();
            },
          ),
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.tune,
            onPressed: () {
              _showFilterMessage();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final selected = selectedTab == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTab = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFD4AF37)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.white54,
                      fontSize: 12,
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

  void _showSearchMessage() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF171717),
          title: const Text(
            'Search Tournaments',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          content: TextField(
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Tournament name...',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF222222),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'CLOSE',
                style: TextStyle(color: Color(0xFFD4AF37)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFilterMessage() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tournament Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                _FilterOption(
                  icon: Icons.emoji_events_outlined,
                  title: 'Prize Pool',
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
                _FilterOption(
                  icon: Icons.speed_outlined,
                  title: 'Time Control',
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
                _FilterOption(
                  icon: Icons.account_tree_outlined,
                  title: 'Tournament Format',
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TournamentCard extends StatelessWidget {
  final TournamentCardData tournament;
  final VoidCallback onTap;

  const TournamentCard({
    super.key,
    required this.tournament,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLive = tournament.live;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isLive
                  ? Colors.redAccent.withValues(alpha: 0.35)
                  : Colors.white10,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: isLive
                          ? Colors.redAccent.withValues(alpha: 0.12)
                          : const Color(0xFFD4AF37).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isLive
                            ? Colors.redAccent.withValues(alpha: 0.25)
                            : const Color(0xFFD4AF37).withValues(alpha: 0.20),
                      ),
                    ),
                    child: Icon(
                      tournament.icon,
                      color: isLive
                          ? Colors.redAccent
                          : const Color(0xFFD4AF37),
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tournament.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          tournament.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
              const SizedBox(height: 15),
              Container(height: 1, color: Colors.white10),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: _SmallTournamentInfo(
                      icon: Icons.emoji_events_outlined,
                      value: tournament.prize,
                      label: 'Prize',
                    ),
                  ),
                  Expanded(
                    child: _SmallTournamentInfo(
                      icon: Icons.people_outline,
                      value: tournament.players,
                      label: 'Players',
                    ),
                  ),
                  Expanded(
                    child: _SmallTournamentInfo(
                      icon: Icons.schedule,
                      value: tournament.time,
                      label: 'Schedule',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isLive
                          ? Colors.redAccent.withValues(alpha: 0.12)
                          : const Color(0xFFD4AF37).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isLive) ...[
                          const Icon(
                            Icons.circle,
                            size: 7,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          tournament.status,
                          style: TextStyle(
                            color: isLive
                                ? Colors.redAccent
                                : const Color(0xFFD4AF37),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFD4AF37),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(
                      isLive ? 'VIEW LIVE' : 'VIEW DETAILS',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallTournamentInfo extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SmallTournamentInfo({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFD4AF37)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(color: Colors.white38, fontSize: 8),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _HeaderIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF161616),
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(11),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
      ),
    );
  }
}

class _FilterOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _FilterOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFFD4AF37), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white38),
    );
  }
}

class _EmptyTournamentState extends StatelessWidget {
  final String tabName;

  const _EmptyTournamentState({required this.tabName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events_outlined,
              size: 60,
              color: Color(0xFFD4AF37),
            ),
            const SizedBox(height: 15),
            Text(
              'No $tabName tournaments',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'New tournaments will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0x73FFFFFF), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class TournamentCardData {
  final String title;
  final String subtitle;
  final String prize;
  final String players;
  final String time;
  final String status;
  final IconData icon;
  final bool live;
  final int stake;
  final int entryFee;
  final int prizePool;

  const TournamentCardData({
    required this.title,
    required this.subtitle,
    required this.prize,
    required this.players,
    required this.time,
    required this.status,
    required this.icon,
    required this.stake,
    required this.entryFee,
    required this.prizePool,
    this.live = false,
  });

  TournamentPrizePlan get prizePlan => TournamentPrizePlan(
        name: title,
        entryFee: entryFee,
        playerCount: prizePool ~/ entryFee,
        stake: stake,
      );
}
