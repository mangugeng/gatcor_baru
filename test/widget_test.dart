// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gatcor/screens/order/trip_history_screen.dart';
import 'package:gatcor/models/trip_history_model.dart';

void main() {
  testWidgets('TripHistoryScreen displays trip history correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: const TripHistoryScreen(),
      ),
    );

    // Verify that the app bar title is displayed
    expect(find.text('Riwayat Perjalanan'), findsOneWidget);

    // Verify that trip items are displayed
    final trips = TripHistoryModel.exampleTrips;
    expect(find.byType(ListView), findsOneWidget);

    // Verify that each trip's details are displayed
    for (final trip in trips) {
      // Check driver name
      expect(find.text(trip.driverName), findsOneWidget);
      
      // Check vehicle info
      expect(find.text('${trip.driverVehicle} • ${trip.driverPlateNumber}'), findsOneWidget);
      
      // Check rating
      expect(find.text(trip.rating.toString()), findsOneWidget);
      
      // Check locations
      expect(find.text(trip.order.pickupLocation), findsOneWidget);
      expect(find.text(trip.order.destinationLocation), findsOneWidget);
      
      // Check price
      expect(find.text('Rp ${trip.order.price.toStringAsFixed(0)}'), findsOneWidget);
      
      // Check date
      final dateText = '${trip.completedAt.day}/${trip.completedAt.month}/${trip.completedAt.year}';
      expect(find.text(dateText), findsOneWidget);
      
      // Check comment if exists
      if (trip.comment != null) {
        expect(find.text(trip.comment!), findsOneWidget);
      }
    }

    // Verify that the back button is present
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });
}
