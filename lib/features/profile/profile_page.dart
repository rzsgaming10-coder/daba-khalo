import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notificationsEnabled = true;
  bool soundEnabled = true;

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
            _buildProfileCard(),
            const SizedBox(height: 14),
            _buildStatsCard(),
            const SizedBox(height: 18),
            _buildSectionTitle('Account'),
            const SizedBox(height: 8),
            _buildMenuItem(
              icon: Icons.edit_outlined,
              title: 'Edit Profile',
              subtitle: 'Update your name and profile',
              onTap: _showEditProfileDialog,
            ),
            _buildMenuItem(
              icon: Icons.emoji_events_outlined,
              title: 'My Tournaments',
              subtitle: 'View your registered tournaments',
              onTap: () {
                _showMessage('My Tournaments coming soon');
              },
            ),
            _buildMenuItem(
              icon: Icons.history,
              title: 'Game History',
              subtitle: 'View your recent chess games',
              onTap: () {
                _showMessage('Game History coming soon');
              },
            ),
            const SizedBox(height: 18),
            _buildSectionTitle('Preferences'),
            const SizedBox(height: 8),
            _buildSwitchItem(
              icon: Icons.notifications_none,
              title: 'Notifications',
              subtitle: 'Tournament and game alerts',
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            _buildSwitchItem(
              icon: Icons.volume_up_outlined,
              title: 'Game Sounds',
              subtitle: 'Move and game sound effects',
              value: soundEnabled,
              onChanged: (value) {
                setState(() {
                  soundEnabled = value;
                });
              },
            ),
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              subtitle: 'App and account settings',
              onTap: () {
                _showMessage('Settings coming soon');
              },
            ),
            const SizedBox(height: 18),
            _buildSectionTitle('Support'),
            const SizedBox(height: 8),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help with DABA KHALO',
              onTap: () {
                _showMessage('Help & Support coming soon');
              },
            ),
            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About DABA KHALO',
              subtitle: 'Version 1.0.0',
              onTap: _showAboutDialog,
            ),
            const SizedBox(height: 22),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage your DABA KHALO account',
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
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(Icons.more_horiz, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF30270F), Color(0xFF151515)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD4AF37),
                  border: Border.all(color: const Color(0xFFFFE79A), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.18),
                      blurRadius: 18,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.person, color: Colors.black, size: 36),
              ),
              const SizedBox(width: 15),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daba Player',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '@dabaplayer',
                      style: TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.verified,
                          color: Color(0xFFD4AF37),
                          size: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Verified Player',
                          style: TextStyle(
                            color: Color(0xFFD4AF37),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Column(
                  children: [
                    Text(
                      'RATING',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '1200',
                      style: TextStyle(
                        color: Color(0xFFFFD966),
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: Colors.white10),
          const SizedBox(height: 14),
          Row(
            children: [
              _profileInfo(
                icon: Icons.calendar_today_outlined,
                label: 'Joined',
                value: '2026',
              ),
              _verticalDivider(),
              _profileInfo(
                icon: Icons.emoji_events_outlined,
                label: 'Wins',
                value: '24',
              ),
              _verticalDivider(),
              _profileInfo(
                icon: Icons.sports_esports_outlined,
                label: 'Games',
                value: '42',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white38, size: 17),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(width: 1, height: 40, color: Colors.white10);
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          _statItem(title: '24', subtitle: 'Wins', icon: Icons.trending_up),
          _statItem(title: '10', subtitle: 'Losses', icon: Icons.trending_down),
          _statItem(
            title: '8',
            subtitle: 'Draws',
            icon: Icons.handshake_outlined,
          ),
          _statItem(title: '57%', subtitle: 'Win Rate', icon: Icons.percent),
        ],
      ),
    );
  }

  Widget _statItem({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 17),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white38, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B1B),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: const Color(0xFFD4AF37), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white30,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B1B),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: const Color(0xFFD4AF37), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ),
        trailing: Switch(
          value: value,
          activeThumbColor: const Color(0xFFD4AF37),
          activeTrackColor: const Color(0xFF6E5B18),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: _showLogoutDialog,
        icon: const Icon(Icons.logout, color: Colors.redAccent, size: 19),
        label: const Text(
          'LOG OUT',
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: 'Daba Player');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF171717),
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Display Name',
              labelStyle: const TextStyle(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white12),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD4AF37)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showMessage('Profile updated');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
              ),
              child: const Text(
                'SAVE',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF171717),
          title: const Text(
            'Log Out?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(color: Colors.white60),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'CANCEL',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showMessage(
                  'Logout will be connected to authentication later',
                );
              },
              child: const Text(
                'LOG OUT',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'DABA KHALO',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.emoji_events,
        color: Color(0xFFD4AF37),
        size: 36,
      ),
      children: const [
        Text(
          'A modern chess tournament platform built for competitive players.',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1E1E1E),
      ),
    );
  }
}
