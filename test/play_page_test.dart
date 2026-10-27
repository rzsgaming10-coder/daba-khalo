import 'package:advanced_chess_board/advanced_chess_board.dart';
import 'package:daba_khalo/features/play/play_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> tapSquare(WidgetTester tester, int row, int column) async {
    final board = tester.getRect(find.byType(AdvancedChessBoard));
    await tester.tapAt(
      Offset(
        board.left + board.width * (column + 0.5) / 8,
        board.top + board.height * (row + 0.5) / 8,
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('local board accepts legal moves and rejects illegal moves', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(const MaterialApp(home: PlayPage()));
    await tester.pumpAndSettle();

    await tapSquare(tester, 6, 4);
    await tapSquare(tester, 4, 4);

    expect(find.text('e4'), findsOneWidget);
    expect(find.text('Black to move'), findsOneWidget);

    await tester.tap(find.byTooltip('Restart'));
    await tester.pumpAndSettle();
    await tapSquare(tester, 6, 4);
    await tapSquare(tester, 3, 4);

    expect(find.text('No moves yet'), findsOneWidget);
    expect(find.text('White to move'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('play screen stays square and has no narrow-screen overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    await tester.pumpWidget(const MaterialApp(home: PlayPage()));
    await tester.pumpAndSettle();

    final board = tester.getSize(find.byType(AdvancedChessBoard));
    expect((board.width - board.height).abs(), lessThan(0.01));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.binding.setSurfaceSize(null);
  });

  test('engine controller supports special moves and draw/game-end rules', () {
    final controller = ChessBoardController();
    addTearDown(controller.dispose);

    controller.loadGameFromFEN('r3k2r/8/8/8/8/8/8/R3K2R w KQkq - 0 1');
    expect(controller.makeMove(from: 'e1', to: 'g1'), isTrue);

    controller.loadGameFromFEN('4k3/8/8/3pP3/8/8/8/4K3 w - d6 0 1');
    expect(controller.makeMove(from: 'e5', to: 'd6'), isTrue);

    controller.loadGameFromFEN('4k3/P7/8/8/8/8/8/4K3 w - - 0 1');
    expect(
      controller.makeMove(from: 'a7', to: 'a8', promotion: 'n'),
      isTrue,
    );
    expect(controller.fen, contains('N'));

    controller.resetBoard();
    for (final move in [
      ('f2', 'f3'),
      ('e7', 'e5'),
      ('g2', 'g4'),
      ('d8', 'h4'),
    ]) {
      expect(controller.makeMove(from: move.$1, to: move.$2), isTrue);
    }
    expect(controller.isInCheck, isTrue);
    expect(controller.isCheckmate, isTrue);
    expect(controller.isGameOver, isTrue);

    controller.loadGameFromFEN('7k/5Q2/6K1/8/8/8/8/8 b - - 0 1');
    expect(controller.isStalemate, isTrue);
    expect(controller.isDraw, isTrue);

    controller.loadGameFromFEN('4k3/8/8/8/8/8/8/4K3 w - - 0 1');
    expect(controller.isDraw, isTrue);

    controller.loadGameFromFEN('4k3/8/8/8/8/8/8/R3K3 w - - 100 51');
    expect(controller.isDraw, isTrue);

    controller.resetBoard();
    for (final move in [
      ('g1', 'f3'),
      ('g8', 'f6'),
      ('f3', 'g1'),
      ('f6', 'g8'),
      ('g1', 'f3'),
      ('g8', 'f6'),
      ('f3', 'g1'),
      ('f6', 'g8'),
    ]) {
      expect(controller.makeMove(from: move.$1, to: move.$2), isTrue);
    }
    expect(controller.isDraw, isTrue);
  });
}
