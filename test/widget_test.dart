
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chantier_manager/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ChantierManagerApp()));

    // Verify home screen is present
    expect(find.text('Chantier Manager Test'), findsOneWidget);
    expect(find.text('Supervisor: Create Task'), findsOneWidget);
  });
}
