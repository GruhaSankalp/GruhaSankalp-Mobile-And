import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gruhasankalp_mobile/main.dart';

void main() {
  testWidgets('GruhaSankalp app launch smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: GruhaSankalpApp(),
      ),
    );

    // Initial frame renders splash brand identity
    expect(find.text('GruhaSankalp'), findsOneWidget);
  });
}
