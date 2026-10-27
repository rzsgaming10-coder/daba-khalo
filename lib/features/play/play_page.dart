import 'dart:async';
import 'dart:math' as math;

import 'package:advanced_chess_board/advanced_chess_board.dart';
import 'package:flutter/material.dart';

import '../../core/models/tournament_models.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  static const _gold = Color(0xFFD4AF37);
  static const _startingSeconds = 10 * 60;

  final TournamentChessController _controller = TournamentChessController();
  Timer? _clockTimer;
  List<String> _sanMoves = [];
  int _whiteSeconds = _startingSeconds;
  int _blackSeconds = _startingSeconds;
  bool _boardFlipped = false;
  bool _resetting = false;
  String? _localEndReason;
  String? _winner;
  final AntiCheatTracker _antiCheatTracker = AntiCheatTracker(maxIllegalMoves: 5);

  bool get _isGameOver => _controller.isGameOver || _localEndReason != null;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handlePositionChanged);
    _startClock();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _controller
      ..removeListener(_handlePositionChanged)
      ..dispose();
    super.dispose();
  }

  void _tickClock(Timer timer) {
    if (!mounted || _isGameOver) return;

    setState(() {
      if (_controller.playerColor == PlayerColor.white) {
        _whiteSeconds--;
        if (_whiteSeconds <= 0) {
          _whiteSeconds = 0;
          _endGame(reason: 'White ran out of time', winner: 'Black');
        }
      } else {
        _blackSeconds--;
        if (_blackSeconds <= 0) {
          _blackSeconds = 0;
          _endGame(reason: 'Black ran out of time', winner: 'White');
        }
      }
    });
  }

  void _handlePositionChanged() {
    if (!mounted || _resetting) return;

    setState(() {
      _sanMoves = List<String>.from(_controller.game.getHistory());
      _localEndReason = null;
      _winner = null;

      if (_controller.autoLossTriggered && !_isGameOver) {
        _endGame(
          reason: 'Auto-loss for 5 illegal moves',
          winner: _controller.playerColor == PlayerColor.white ? 'Black' : 'White',
        );
      }

      if (_controller.isGameOver) {
        _setEngineGameResult();
        _clockTimer?.cancel();
      } else if (_clockTimer?.isActive != true) {
        _startClock();
      }
    });
  }

  void _setEngineGameResult() {
    if (_controller.isCheckmate) {
      _winner = _controller.playerColor == PlayerColor.white
          ? 'Black'
          : 'White';
      _localEndReason = 'Checkmate';
    } else if (_controller.isStalemate) {
      _localEndReason = 'Draw by stalemate';
    } else if (_controller.game.insufficient_material) {
      _localEndReason = 'Draw by insufficient material';
    } else if (_controller.game.in_threefold_repetition) {
      _localEndReason = 'Draw by threefold repetition';
    } else {
      _localEndReason = 'Draw by the 50-move rule';
    }
  }

  void _endGame({required String reason, String? winner}) {
    _clockTimer?.cancel();
    _localEndReason = reason;
    _winner = winner;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildPlayerBar(
              name: 'Opponent',
              rating: '1248',
              seconds: _blackSeconds,
              color: PlayerColor.black,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxBoardWidth = math.max(
                    0.0,
                    constraints.maxWidth - 24,
                  );
                  final maxBoardHeight = math.max(
                    0.0,
                    constraints.maxHeight - 214,
                  );
                  final boardSize = math.min(
                    720.0,
                    math.min(maxBoardWidth, maxBoardHeight),
                  );

                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildModeAndStatus(),
                              const SizedBox(height: 8),
                              SizedBox.square(
                                dimension: boardSize,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _gold.withValues(alpha: 0.55),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: AdvancedChessBoard(
                                    controller: _controller,
                                    boardOrientation: _boardFlipped
                                        ? PlayerColor.black
                                        : PlayerColor.white,
                                    boardTheme: const BoardTheme(
                                      lightSquareColor: Color(0xFFF0E6C8),
                                      darkSquareColor: Color(0xFF70482F),
                                      selectionColor: Color(0x99D4AF37),
                                      lastMoveHighlightColor: Color(0x70D4AF37),
                                      legalDestinationColor: Color(0x665A3E24),
                                      kingCheckColor: Color(0x99E53935),
                                      kingCheckmateColor: Color(0xCCB71C1C),
                                      coordinateLabelColor: Color(0xFF5A3E24),
                                      dragLegalRingColor: Color(0xFFD4AF37),
                                    ),
                                    enableMoves: !_isGameOver,
                                    highlightLastMove: true,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildPlayerBar(
                                name: 'You',
                                rating: '1200',
                                seconds: _whiteSeconds,
                                color: PlayerColor.white,
                              ),
                              const SizedBox(height: 10),
                              _buildControls(),
                              const SizedBox(height: 14),
                              _buildGameDetails(),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildTopBar() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF101010),
        border: Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Play Chess',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: _undoMove,
            tooltip: 'Undo move (local practice)',
            icon: const Icon(Icons.undo, color: Colors.white70),
          ),
          IconButton(
            onPressed: () {
              setState(() => _boardFlipped = !_boardFlipped);
            },
            tooltip: 'Flip board',
            icon: const Icon(Icons.flip, color: Colors.white70),
          ),
          IconButton(
            onPressed: _resetGame,
            tooltip: 'Restart',
            icon: const Icon(Icons.refresh, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerBar({
    required String name,
    required String rating,
    required int seconds,
    required PlayerColor color,
  }) {
    final active = !_isGameOver && _controller.playerColor == color;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF151515),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF222222),
              border: Border.all(color: active ? _gold : Colors.white10),
            ),
            child: Icon(
              Icons.person,
              color: active ? _gold : Colors.white38,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rating $rating',
                  style: const TextStyle(color: Colors.white38, fontSize: 9),
                ),
              ],
            ),
          ),
          _buildClock(seconds, active),
        ],
      ),
    );
  }

  Widget _buildClock(int seconds, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF252525) : const Color(0xFF191919),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? _gold.withValues(alpha: 0.45) : Colors.white10,
        ),
      ),
      child: Text(
        _formatTime(seconds),
        style: TextStyle(
          color: active ? Colors.white : Colors.white38,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildModeAndStatus() {
    final status = _statusText;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _controller.isInCheck && !_controller.isGameOver
              ? Colors.redAccent.withValues(alpha: 0.55)
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _controller.isGameOver ? Icons.flag : Icons.sports_esports,
            size: 16,
            color: _controller.isGameOver ? _gold : Colors.white54,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              status,
              style: TextStyle(
                color: _controller.isInCheck && !_controller.isGameOver
                    ? Colors.redAccent
                    : Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Text(
            'LOCAL PRACTICE',
            style: TextStyle(
              color: _gold,
              fontSize: 8,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }

  String get _statusText {
    if (_winner != null) return '$_winner wins — $_localEndReason';
    if (_localEndReason != null) return _localEndReason!;
    if (_controller.autoLossTriggered) {
      return _controller.antiCheatStatus;
    }
    if (_controller.isCheckmate) {
      return '${_controller.playerColor == PlayerColor.white ? 'White' : 'Black'} is checkmated';
    }
    if (_controller.isInCheck) {
      return '${_controller.playerColor == PlayerColor.white ? 'White' : 'Black'} to move — check';
    }
    return '${_controller.playerColor == PlayerColor.white ? 'White' : 'Black'} to move';
  }

  Widget _buildControls() {
    return Row(
      children: [
        Expanded(
          child: _controlButton(
            icon: Icons.handshake_outlined,
            label: 'DRAW',
            onTap: _offerLocalDraw,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _controlButton(
            icon: Icons.flag_outlined,
            label: 'RESIGN',
            danger: true,
            onTap: _showResignDialog,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _controlButton(
            icon: Icons.chat_bubble_outline,
            label: 'CHAT',
            onTap: () => _showMessage('Chat is unavailable in local practice.'),
          ),
        ),
      ],
    );
  }

  Widget _controlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    return SizedBox(
      height: 42,
      child: OutlinedButton.icon(
        onPressed: _isGameOver ? null : onTap,
        icon: Icon(
          icon,
          size: 15,
          color: danger ? Colors.redAccent : Colors.white60,
        ),
        label: Text(
          label,
          style: TextStyle(
            color: danger ? Colors.redAccent : Colors.white60,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          side: BorderSide(
            color: danger
                ? Colors.redAccent.withValues(alpha: 0.25)
                : Colors.white10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildGameDetails() {
    final whiteCaptures = _capturedPieceNames(white: true);
    final blackCaptures = _capturedPieceNames(white: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _detailsCard(
          title: 'CAPTURED PIECES',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _capturedRow('White', whiteCaptures),
              const SizedBox(height: 5),
              _capturedRow('Black', blackCaptures),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _detailsCard(title: 'MOVE HISTORY', child: _buildMoveList()),
      ],
    );
  }

  List<String> _capturedPieceNames({required bool white}) {
    final pieces = <String>[];
    for (final entry in _controller.history) {
      final captured = entry.move.captured;
      if (captured == null) continue;

      final capturedByWhite = entry.move.color.name == 'WHITE';
      if (white != capturedByWhite) continue;
      pieces.add(_pieceName(captured.name));
    }
    return pieces;
  }

  Widget _capturedRow(String side, List<String> pieces) {
    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(
            side,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ),
        Expanded(
          child: Text(
            pieces.isEmpty ? '—' : pieces.join('  ·  '),
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildMoveList() {
    if (_sanMoves.isEmpty) {
      return const Text(
        'No moves yet',
        style: TextStyle(color: Colors.white38, fontSize: 11),
      );
    }

    final rows = <Widget>[];
    for (var index = 0; index < _sanMoves.length; index += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              SizedBox(
                width: 34,
                child: Text(
                  '${index ~/ 2 + 1}.',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ),
              Expanded(
                child: Text(
                  _sanMoves[index],
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              Expanded(
                child: Text(
                  index + 1 < _sanMoves.length ? _sanMoves[index + 1] : '',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }

  Widget _detailsCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _gold,
              fontSize: 9,
              letterSpacing: 0.7,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  String _pieceName(String piece) {
    switch (piece.toLowerCase()) {
      case 'p':
        return 'Pawn';
      case 'n':
        return 'Knight';
      case 'b':
        return 'Bishop';
      case 'r':
        return 'Rook';
      case 'q':
        return 'Queen';
      case 'k':
        return 'King';
      default:
        return piece;
    }
  }

  void _undoMove() {
    if (_localEndReason != null && !_controller.isGameOver) return;
    if (_controller.history.isEmpty) return;
    _controller.undo();
  }

  void _resetGame() {
    _resetting = true;
    _controller.resetBoard();
    _resetting = false;
    _clockTimer?.cancel();

    setState(() {
      _whiteSeconds = _startingSeconds;
      _blackSeconds = _startingSeconds;
      _sanMoves = [];
      _localEndReason = null;
      _winner = null;
    });
    _startClock();
  }

  void _startClock() {
    _clockTimer?.cancel();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), _tickClock);
  }

  Future<void> _offerLocalDraw() async {
    final agree = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF171717),
        title: const Text(
          'End as a draw?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        content: const Text(
          'This ends the local practice game as a draw.',
          style: TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('AGREE'),
          ),
        ],
      ),
    );
    if (agree == true && mounted && !_isGameOver) {
      setState(() => _endGame(reason: 'Draw by agreement'));
    }
  }

  Future<void> _showResignDialog() async {
    final resign = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF171717),
        title: const Text(
          'Resign game?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        content: const Text(
          'The side whose turn it is will resign.',
          style: TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'RESIGN',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (resign != true || !mounted || _isGameOver) return;
    final winner = _controller.playerColor == PlayerColor.white
        ? 'Black'
        : 'White';
    setState(() => _endGame(reason: 'Resignation', winner: winner));
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

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
