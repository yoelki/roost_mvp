import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_bloc.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_event.dart';
import 'package:roost_mvp/presentation/blocs/auth/auth_state.dart';
import 'package:roost_mvp/presentation/widgets/app_drawer.dart';
import 'package:roost_mvp/domain/entities/user_entity.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    final user = UserEntity(id: '1', email: 'test@test.com');

    // Mock the stream
    when(() => mockAuthBloc.stream)
        .thenAnswer((_) => Stream.fromIterable([Authenticated(user)]));

    // Mock the state
    when(() => mockAuthBloc.state).thenReturn(Authenticated(user));

    // Mock the close method
    when(() => mockAuthBloc.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>(
        create: (context) => mockAuthBloc,
        child: Builder(
          builder: (context) => Scaffold(
            drawer: const AppDrawer(),
            body: Container(),
          ),
        ),
      ),
    );
  }

  Future<void> openDrawer(WidgetTester tester) async {
    final ScaffoldState scaffoldState = tester.state(find.byType(Scaffold));
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();
  }

  group('AppDrawer', () {
    testWidgets('should render drawer header with app name', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await openDrawer(tester);

      expect(find.text('Roost MVP'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should render all menu items', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await openDrawer(tester);

      expect(find.text('Apps'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Help & Feedback'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('should mark Apps as selected', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await openDrawer(tester);

      final appsTile = tester.widget<ListTile>(
        find.ancestor(
          of: find.text('Apps'),
          matching: find.byType(ListTile),
        ),
      );

      expect(appsTile.selected, true);
    });

    testWidgets('should trigger sign out when sign out is tapped',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await openDrawer(tester);

      await tester.tap(find.text('Sign Out'));
      await tester.pumpAndSettle();

      verify(() => mockAuthBloc.add(SignOutRequested())).called(1);
    });

    testWidgets('should close drawer when menu item is tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await openDrawer(tester);

      await tester.tap(find.text('Apps'));
      await tester.pumpAndSettle();

      expect(find.text('Apps'), findsNothing);
    });
  });
}
