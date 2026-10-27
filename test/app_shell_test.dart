import 'package:daba_khalo/app/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp() {
    return MaterialApp(
      home: AppShell(
        pages: List.generate(5, (index) => Center(child: Text('Page $index'))),
      ),
    );
  }

  testWidgets('app shell switches between primary destinations', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    await tester.pumpWidget(buildApp());

    expect(find.text('Page 0'), findsOneWidget);
    await tester.tap(find.text('Tournaments'));
    await tester.pumpAndSettle();

    expect(find.text('Page 1'), findsOneWidget);
  });

  testWidgets('app shell fits a narrow viewport', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    await tester.pumpWidget(buildApp());

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
