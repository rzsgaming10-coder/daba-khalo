import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  final String tournamentName;
  final String entryFee;
  final String prizePool;

  const RegistrationPage({
    super.key,
    this.tournamentName = 'DABA GOLD CUP',
    this.entryFee = '৳500',
    this.prizePool = '৳50,000',
  });

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String selectedPaymentMethod = 'Wallet';
  bool acceptedRules = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tournament Registration',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TournamentSummary(
                tournamentName: widget.tournamentName,
                entryFee: widget.entryFee,
                prizePool: widget.prizePool,
              ),

              const SizedBox(height: 22),

              const Text(
                'Player Information',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              const _PlayerInformationCard(),

              const SizedBox(height: 22),

              const Text(
                'Payment Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              _PaymentOption(
                title: 'DABA Wallet',
                subtitle: 'Use your DABA KHALO wallet balance',
                icon: Icons.account_balance_wallet_outlined,
                selected: selectedPaymentMethod == 'Wallet',
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'Wallet';
                  });
                },
              ),

              const SizedBox(height: 10),

              _PaymentOption(
                title: 'Payment Gateway',
                subtitle: 'Secure online payment',
                icon: Icons.credit_card_outlined,
                selected: selectedPaymentMethod == 'Gateway',
                onTap: () {
                  setState(() {
                    selectedPaymentMethod = 'Gateway';
                  });
                },
              ),

              const SizedBox(height: 22),

              const Text(
                'Registration Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              _SummaryCard(entryFee: widget.entryFee),

              const SizedBox(height: 20),

              _RulesCheckbox(
                value: acceptedRules,
                onChanged: (value) {
                  setState(() {
                    acceptedRules = value;
                  });
                },
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: acceptedRules ? _confirmRegistration : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    disabledBackgroundColor: const Color(0xFF292929),
                    foregroundColor: Colors.black,
                    disabledForegroundColor: Colors.white30,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'CONFIRM REGISTRATION',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Center(
                child: Text(
                  'Your registration will be confirmed after payment verification.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRegistration() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF171717),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Color(0xFFD4AF37),
            size: 48,
          ),
          title: const Text(
            'Registration Ready',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
          content: const Text(
            'The real payment and registration verification system will be connected here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, height: 1.4),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'DONE',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TournamentSummary extends StatelessWidget {
  final String tournamentName;
  final String entryFee;
  final String prizePool;

  const _TournamentSummary({
    required this.tournamentName,
    required this.entryFee,
    required this.prizePool,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2B2410), Color(0xFF151515)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.12),
              border: Border.all(color: const Color(0xFFD4AF37)),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Color(0xFFD4AF37),
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tournamentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Prize Pool $prizePool',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'ENTRY',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                entryFee,
                style: const TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerInformationCard extends StatelessWidget {
  const _PlayerInformationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: const Column(
        children: [
          _PlayerRow(icon: Icons.person_outline, title: 'Player', value: 'You'),
          _PlayerRow(icon: Icons.star_outline, title: 'Rating', value: '1200'),
          _PlayerRow(
            icon: Icons.public,
            title: 'Platform',
            value: 'DABA KHALO',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _PlayerRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isLast;

  const _PlayerRow({
    required this.icon,
    required this.title,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2B2410) : const Color(0xFF111111),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: selected ? const Color(0xFFD4AF37) : Colors.white10,
              width: selected ? 1.2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFD4AF37).withValues(alpha: 0.15)
                      : const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: selected ? const Color(0xFFD4AF37) : Colors.white54,
                ),
              ),
              const SizedBox(width: 12),
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
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0x73FFFFFF),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? const Color(0xFFD4AF37) : Colors.white30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String entryFee;

  const _SummaryCard({required this.entryFee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _SummaryRow(title: 'Tournament Entry', value: entryFee),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white10),
          const SizedBox(height: 12),
          _SummaryRow(title: 'Service Fee', value: '৳0'),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white10),
          const SizedBox(height: 12),
          _SummaryRow(title: 'Total', value: entryFee, highlight: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool highlight;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: highlight ? Colors.white : Colors.white54,
              fontSize: highlight ? 14 : 12,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlight ? const Color(0xFFD4AF37) : Colors.white,
            fontSize: highlight ? 16 : 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _RulesCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _RulesCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: (newValue) {
              onChanged(newValue ?? false);
            },
            activeColor: const Color(0xFFD4AF37),
            checkColor: Colors.black,
            side: const BorderSide(color: Colors.white38),
          ),
          const SizedBox(width: 5),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 11),
              child: Text(
                'I agree to the tournament rules, fair-play policy, and registration terms.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
