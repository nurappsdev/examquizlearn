import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nailed_quiz_app/features/profile/subscription/views/subscription_view.dart';

void main() {
  testWidgets('payment method dialog returns stripe selection', (tester) async {
    SubscriptionPaymentMethod? selectedMethod;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (_, __) {
          return MaterialApp(
            home: Builder(
              builder: (context) {
                return Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        selectedMethod =
                            await showDialog<SubscriptionPaymentMethod>(
                              context: context,
                              builder: (_) =>
                                  const SubscriptionPaymentMethodDialog(),
                            );
                      },
                      child: const Text('Open'),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Stripe pay'), findsOneWidget);
    expect(find.text('Apple pay'), findsOneWidget);

    await tester.tap(find.text('Stripe pay'));
    await tester.pumpAndSettle();

    expect(selectedMethod, SubscriptionPaymentMethod.stripe);
  });
}
