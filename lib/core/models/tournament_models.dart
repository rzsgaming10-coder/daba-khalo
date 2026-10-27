import 'package:advanced_chess_board/advanced_chess_board.dart';
import 'package:flutter/material.dart';

class TournamentChessController extends ChessBoardController {
  TournamentChessController({this.maxIllegalMoves = 5});

  final int maxIllegalMoves;
  int illegalMoveAttempts = 0;
  bool autoLossTriggered = false;

  @override
  bool makeMove({
    required String from,
    required String to,
    String? promotion,
    bool notify = true,
  }) {
    final moveAccepted = super.makeMove(
      from: from,
      to: to,
      promotion: promotion,
      notify: notify,
    );

    if (!moveAccepted) {
      illegalMoveAttempts += 1;
      if (illegalMoveAttempts >= maxIllegalMoves) {
        autoLossTriggered = true;
      }
    }

    return moveAccepted;
  }

  String get antiCheatStatus {
    if (autoLossTriggered) {
      return 'Auto-loss triggered: $maxIllegalMoves illegal moves reached';
    }
    return 'Illegal moves: $illegalMoveAttempts/$maxIllegalMoves';
  }
}

class TournamentPrizePlan {
  const TournamentPrizePlan({
    required this.name,
    required this.entryFee,
    required this.playerCount,
    required this.stake,
  });

  final String name;
  final int entryFee;
  final int playerCount;
  final int stake;

  static const List<int> supportedStakes = [10, 20, 50, 100];

  int get totalPrizePool => playerCount * entryFee;

  int _share(int percent) => ((totalPrizePool * percent) / 100).round();

  int get adminCut => _share(20);
  int get firstPrize => _share(30);
  int get secondPrize => _share(20);
  int get thirdPrize => _share(15);
  int get fourthPrize => _share(10);
  int get fifthPrize => _share(5);

  List<TournamentPayout> get payoutBreakdown => [
    TournamentPayout(
      label: 'Admin',
      amount: adminCut,
      percent: 20,
      color: const Color(0xFFB0B0B0),
    ),
    TournamentPayout(
      label: '1st',
      amount: firstPrize,
      percent: 30,
      color: const Color(0xFFD4AF37),
    ),
    TournamentPayout(
      label: '2nd',
      amount: secondPrize,
      percent: 20,
      color: const Color(0xFFCACACA),
    ),
    TournamentPayout(
      label: '3rd',
      amount: thirdPrize,
      percent: 15,
      color: const Color(0xFFC08D5B),
    ),
    TournamentPayout(
      label: '4th',
      amount: fourthPrize,
      percent: 10,
      color: const Color(0xFF90A4FF),
    ),
    TournamentPayout(
      label: '5th',
      amount: fifthPrize,
      percent: 5,
      color: const Color(0xFF7BE1AE),
    ),
  ];

  String get stakeLabel => '৳$stake';

  static TournamentPrizePlan fromTournamentCard({
    required String title,
    required int entryFee,
    required int playerCount,
    required int stake,
  }) {
    return TournamentPrizePlan(
      name: title,
      entryFee: entryFee,
      playerCount: playerCount,
      stake: stake,
    );
  }
}

class TournamentPayout {
  const TournamentPayout({
    required this.label,
    required this.amount,
    required this.percent,
    required this.color,
  });

  final String label;
  final int amount;
  final int percent;
  final Color color;
}

class TournamentResultEntry {
  const TournamentResultEntry({
    required this.playerId,
    required this.name,
    required this.position,
    required this.points,
    required this.wins,
    required this.losses,
    required this.illegalMoves,
    this.isCurrentPlayer = false,
  });

  final String playerId;
  final String name;
  final int position;
  final int points;
  final int wins;
  final int losses;
  final int illegalMoves;
  final bool isCurrentPlayer;
}

class TournamentRoadmapPoint {
  const TournamentRoadmapPoint({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.position,
    required this.points,
    required this.isCurrentPlayer,
  });

  final String label;
  final String title;
  final String subtitle;
  final int position;
  final int points;
  final bool isCurrentPlayer;
}

List<TournamentResultEntry> buildDefaultTournamentResults({
  String currentPlayerId = 'DABA-9000',
}) {
  return const [
    TournamentResultEntry(
      playerId: 'DABA-1021',
      name: 'KnightMaster',
      position: 1,
      points: 42,
      wins: 7,
      losses: 1,
      illegalMoves: 0,
    ),
    TournamentResultEntry(
      playerId: 'DABA-2088',
      name: 'RoyalKnight',
      position: 2,
      points: 39,
      wins: 6,
      losses: 2,
      illegalMoves: 1,
    ),
    TournamentResultEntry(
      playerId: 'DABA-3140',
      name: 'GoldenBishop',
      position: 3,
      points: 36,
      wins: 5,
      losses: 3,
      illegalMoves: 0,
    ),
    TournamentResultEntry(
      playerId: 'DABA-4401',
      name: 'DabaPlayer',
      position: 4,
      points: 32,
      wins: 5,
      losses: 3,
      illegalMoves: 2,
    ),
    TournamentResultEntry(
      playerId: 'DABA-5350',
      name: 'CheckMate',
      position: 5,
      points: 29,
      wins: 4,
      losses: 4,
      illegalMoves: 1,
    ),
    TournamentResultEntry(
      playerId: 'DABA-9000',
      name: 'Your ID',
      position: 6,
      points: 27,
      wins: 4,
      losses: 4,
      illegalMoves: 0,
      isCurrentPlayer: true,
    ),
  ];
}

List<TournamentRoadmapPoint> buildRoadMap({
  required List<TournamentResultEntry> results,
  required String currentPlayerId,
}) {
  final current = results.firstWhere(
    (entry) => entry.playerId == currentPlayerId,
    orElse: () => results.first,
  );

  return results
      .map(
        (entry) => TournamentRoadmapPoint(
          label: 'Rank ${entry.position}',
          title: entry.name,
          subtitle: '${entry.points} pts • ${entry.wins}W/${entry.losses}L',
          position: entry.position,
          points: entry.points,
          isCurrentPlayer: entry.playerId == current.playerId,
        ),
      )
      .toList();
}

class AntiCheatTracker {
  AntiCheatTracker({this.maxIllegalMoves = 5});

  final int maxIllegalMoves;
  int illegalMoveCount = 0;
  bool autoLossTriggered = false;

  bool recordIllegalMove() {
    illegalMoveCount += 1;
    if (illegalMoveCount >= maxIllegalMoves) {
      autoLossTriggered = true;
      return true;
    }
    return false;
  }

  String get statusText {
    if (autoLossTriggered) {
      return 'Auto-loss triggered: 5 illegal moves reached';
    }
    return 'Illegal moves: $illegalMoveCount/$maxIllegalMoves';
  }
}
