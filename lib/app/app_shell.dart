import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({required this.pages, super.key});

  final List<Widget> pages;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    assert(widget.pages.length == 5);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: widget.pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events, color: Colors.black),
            label: 'Tournaments',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports, color: Colors.black),
            label: 'Play',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard, color: Colors.black),
            label: 'Ranking',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
