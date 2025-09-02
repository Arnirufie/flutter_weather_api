import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cuaca_app/main.dart';

void main() {
  testWidgets('WeatherScreen loads correctly', (WidgetTester tester) async {
    // Build aplikasi
    await tester.pumpWidget(MyApp()); // jangan pakai const

    // Cek AppBar muncul
    expect(find.text('Weather App'), findsOneWidget);

    // Cek loading muncul saat fetch data
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tunggu sampai data selesai load
    await tester.pumpAndSettle();

    // Cek salah satu field cuaca muncul
    expect(find.textContaining('Latitude'), findsOneWidget);
  });
}
