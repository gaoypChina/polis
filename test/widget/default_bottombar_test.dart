import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:polis/model/user_model.dart';
import 'package:polis/page/pages.dart';

import '../mock.dart';
import 'utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DefaultBottombar tests', () {
    testWidgets('shoud build without exploding', (tester) async {
      final mockUserBloc = MockUserBloc();
      when(mockUserBloc.user).thenReturn(UserModel());
      await tester.pumpWidget(
        connectedWidget(
          BlocProvider(
            create: (_) => mockUserBloc,
            child: TimelinePage(),
          ),
        ),
      );
    });

    testWidgets('shoud build icons on bottombar and profile photo',
        (tester) async {
      final mockUserBloc = MockUserBloc();
      when(mockUserBloc.user).thenReturn(UserModel());
      await tester.pumpWidget(
        connectedWidget(
          BlocProvider(
            create: (_) => mockUserBloc,
            child: TimelinePage(),
          ),
        ),
      );
      final homeIcon = find.widgetWithIcon(IconButton, Icons.home);
      expect(homeIcon, findsOneWidget);
      final searchIcon = find.widgetWithIcon(IconButton, Icons.search);
      expect(searchIcon, findsOneWidget);
      final bookmarkIcon =
          find.widgetWithIcon(IconButton, Icons.bookmark_border);
      expect(bookmarkIcon, findsOneWidget);
      final profilePhoto = find.byType(FancyShimmerImage);
      expect(profilePhoto, findsOneWidget);
    });

    testWidgets('shoud go to TimelinePage when clicking home icon',
        (tester) async {
      final mockUserBloc = MockUserBloc();
      when(mockUserBloc.user).thenReturn(UserModel());
      await tester.pumpWidget(
        connectedWidget(
          BlocProvider(
            create: (_) => mockUserBloc,
            child: TimelinePage(),
          ),
        ),
      );
      final homeIcon = find.widgetWithIcon(IconButton, Icons.home);
      expect(homeIcon, findsOneWidget);
      await tester.tap(homeIcon);
    });

    testWidgets('shoud go to SearchPoliticPage when clicking search icon',
        (tester) async {
      final mockUserBloc = MockUserBloc();
      when(mockUserBloc.user).thenReturn(UserModel());
      await tester.pumpWidget(
        connectedWidget(
          BlocProvider(
            create: (_) => mockUserBloc,
            child: TimelinePage(),
          ),
        ),
      );
      final searchIcon = find.widgetWithIcon(IconButton, Icons.search);
      expect(searchIcon, findsOneWidget);
      await tester.tap(searchIcon);
    });

    testWidgets('shoud go to TimelinePage when clicking bookmark icon',
        (tester) async {
      final mockUserBloc = MockUserBloc();
      when(mockUserBloc.user).thenReturn(UserModel());
      await tester.pumpWidget(
        connectedWidget(
          BlocProvider(
            create: (_) => mockUserBloc,
            child: TimelinePage(),
          ),
        ),
      );
      final bookmarkIcon =
          find.widgetWithIcon(IconButton, Icons.bookmark_border);
      expect(bookmarkIcon, findsOneWidget);
      await tester.tap(bookmarkIcon);
    });

    testWidgets('shoud go to UserProfilePage when clicking on photo',
        (tester) async {
      final mockUserBloc = MockUserBloc();
      when(mockUserBloc.user).thenReturn(UserModel());
      await tester.pumpWidget(
        connectedWidget(
          BlocProvider(
            create: (_) => mockUserBloc,
            child: TimelinePage(),
          ),
        ),
      );
      final profile = find.byType(ClipRRect);
      expect(profile, findsOneWidget);
      await tester.tap(profile);
    });
  });
}
