// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:user_app/myapp.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/user.dart';

import 'myapp_test.mocks.dart';




@GenerateMocks([http.Client])
void main() {
  testWidgets('when main screen is open , listview is created', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());


    expect(find.text('User list'), findsOneWidget);
       await tester.pumpAndSettle();
       await tester.pump(Duration(seconds: 3));



    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
    //
    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
  group('fetchUserData', (){
    test('returns an album if the http call completes successfully', (){
      final client = MockClient();
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/users'))).thenAnswer((_)
      async =>
          http.Response('{"name": "sneha sanghani","city": "surat", "email" :"snehasanghani@gmail.com"}',200));
      expect( fetchData(client), isA<User>());
    });
    test('throws an exception if the http call completes with an error', (){
      final client = MockClient();
      when(client.get(Uri.parse('https://jsonplaceholder.typicode.com/users'))).thenAnswer((_) async => http.Response('Not found',404));
      expect(fetchData(client), throwsException);
    });
  });
}


