import 'package:flutter/material.dart';

import 'app/app_shell.dart';
import 'app/theme/app_theme.dart';
import 'features/play/play_page.dart';
import 'features/profile/profile_page.dart';
import 'features/ranking/ranking_page.dart';
import 'features/tournaments/tournaments_page.dart';

void main() {
  runApp(const DabaKhaloApp());
}

class DabaKhaloApp extends StatelessWidget {
  const DabaKhaloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DABA KHALO',
      theme: AppTheme.dark,
      home: const AppShell(
        pages: [
          HomePage(),
          TournamentsPage(),
          PlayPage(),
          RankingPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
          children: [
            _buildHeader(),
            const SizedBox(height: 18),
            _buildPlayerCard(),
            const SizedBox(height: 20),
            _buildSectionHeader('Quick Play', 'Start a game'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    icon: Icons.bolt,
                    title: 'Blitz',
                    subtitle: '3 + 2',
                    onTap: () {
                      _showMessage(context, 'Blitz game coming soon');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionCard(
                    icon: Icons.timer_outlined,
                    title: 'Rapid',
                    subtitle: '10 + 0',
                    onTap: () {
                      _showMessage(context, 'Rapid game coming soon');
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Upcoming Tournaments', 'View all'),
            const SizedBox(height: 10),
            _TournamentCard(
              title: 'DABA GOLD CUP',
              subtitle: '32 Players • Blitz',
              prize: '৳50,000',
              date: 'Today',
            ),
            const SizedBox(height: 10),
            _TournamentCard(
              title: 'WEEKEND BLITZ',
              subtitle: '64 Players • 3 + 2',
              prize: '৳25,000',
              date: 'Tomorrow',
            ),
            const SizedBox(height: 10),
            _TournamentCard(
              title: 'RAPID CHAMPIONSHIP',
              subtitle: '128 Players • Rapid',
              prize: '৳75,000',
              date: 'Sat',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
                blurRadius: 16,
              ),
            ],
          ),
          child: const Icon(Icons.emoji_events, color: Colors.black, size: 25),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DABA KHALO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Chess Tournament Arena',
                style: TextStyle(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF151515),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(
            Icons.notifications_none,
            color: Colors.white70,
            size: 21,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF30270F), Color(0xFF151515)],
        ),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD4AF37),
              border: Border.all(color: const Color(0xFFFFE79A), width: 1.5),
            ),
            child: const Icon(Icons.person, color: Colors.black, size: 30),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                SizedBox(height: 3),
                Text(
                  'Daba Player',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Rating 1200',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          action,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E1E1E),
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;

  const SimplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080808),
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title coming soon',
          style: const TextStyle(color: Colors.white54, fontSize: 16),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(icon, color: const Color(0xFFD4AF37), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 9),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TournamentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String prize;
  final String date;

  const _TournamentCard({
    required this.title,
    required this.subtitle,
    required this.prize,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF211B0C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: Color(0xFFD4AF37),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                prize,
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(color: Colors.white38, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
