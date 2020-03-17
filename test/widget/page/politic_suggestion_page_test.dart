import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:image_test_utils/image_test_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:polis/bloc/blocs.dart';
import 'package:polis/core/service/locator.dart';
import 'package:polis/i18n/i18n.dart';
import 'package:polis/model/politico_model.dart';
import 'package:polis/model/user_model.dart';
import 'package:polis/page/page_connected.dart';
import 'package:polis/page/pages.dart';
import 'package:polis/page/politic_sugestion/politic_suggestion_page_connected.dart';
import 'package:polis/page/politic_sugestion/widget/politics_suggested_grid.dart';
import 'package:polis/widget/politic_suggested.dart';

import '../../mock.dart';
import '../utils.dart';

void main() {
  setUpAll(initLocator);

  group('PoliticSuggestionPage tests', () {
    testWidgets('should build without exploding', (tester) async {
      await tester.pumpWidget(
        connectedWidget(PoliticSuggestionPageConnected()),
      );
    });

    testWidgets('should show loading when loading state', (tester) async {
      final mockPoliticSuggestionBloc = MockPoliticSuggestionBloc();
      when(mockPoliticSuggestionBloc.state).thenReturn(LoadingFetch());
      await tester.pumpWidget(
        connectedWidget(
          PageConnected<PoliticSuggestionBloc>(
            bloc: mockPoliticSuggestionBloc,
            page: PoliticSuggestionPage(),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should call SavePoliticsToFollow when click on button',
        (tester) async {
      provideMockedNetworkImages(() async {
        final politicos = [
          PoliticoModel(
            id: '1',
            nomeEleitoral: 'nome',
            urlFoto:
                'https://smalltotall.info/wp-content/uploads/2017/04/google-favicon-vector-400x400.png',
          ),
          PoliticoModel(
            id: '2',
            nomeEleitoral: 'nome2',
            urlFoto:
                'https://smalltotall.info/wp-content/uploads/2017/04/google-favicon-vector-400x400.png',
          ),
        ];
        final mockPoliticSuggestionBloc = MockPoliticSuggestionBloc();
        when(mockPoliticSuggestionBloc.politics).thenReturn(politicos);
        when(mockPoliticSuggestionBloc.state)
            .thenReturn(FetchSuggestedPoliticsSuccess(politicos));
        when(mockPoliticSuggestionBloc.isPoliticBeenFollowed(any))
            .thenReturn(true);
        final mockUserBloc = MockUserBloc();
        when(mockUserBloc.user).thenReturn(UserModel(userId: '1'));
        await tester.pumpWidget(
          connectedWidget(
            PageConnected<UserBloc>(
              bloc: mockUserBloc,
              page: PageConnected<PoliticSuggestionBloc>(
                bloc: mockPoliticSuggestionBloc,
                page: PoliticSuggestionPage(),
              ),
            ),
          ),
        );
        final readyButton = find.text(READY);
        expect(readyButton, findsOneWidget);
        await tester.tap(readyButton);
        verify(mockPoliticSuggestionBloc.add(SavePoliticsToFollow(userId: '1')))
            .called(1);
      });
    });

    testWidgets('should show PoliticsSuggestedGrid when fetch success',
        (tester) async {
      final mockPoliticSuggestionBloc = MockPoliticSuggestionBloc();
      when(mockPoliticSuggestionBloc.politics).thenReturn([]);
      when(mockPoliticSuggestionBloc.state)
          .thenReturn(FetchSuggestedPoliticsSuccess([]));
      when(mockPoliticSuggestionBloc.isPoliticBeenFollowed(any))
          .thenReturn(true);
      await tester.pumpWidget(
        connectedWidget(
          PageConnected<PoliticSuggestionBloc>(
            bloc: mockPoliticSuggestionBloc,
            page: PoliticSuggestionPage(),
          ),
        ),
      );
      expect(find.byType(PoliticsSuggestedGrid), findsOneWidget);
    });

    testWidgets('should show 2 PoliticSuggested when the list has 2 items',
        (tester) async {
      provideMockedNetworkImages(() async {
        final politicos = [
          PoliticoModel(
            id: '1',
            nomeEleitoral: 'nome',
            urlFoto: '',
          ),
          PoliticoModel(
            id: '2',
            nomeEleitoral: 'nome2',
            urlFoto: '',
          ),
        ];
        final mockPoliticSuggestionBloc = MockPoliticSuggestionBloc();
        when(mockPoliticSuggestionBloc.politics).thenReturn(politicos);
        when(mockPoliticSuggestionBloc.state)
            .thenReturn(FetchSuggestedPoliticsSuccess(politicos));
        when(mockPoliticSuggestionBloc.isPoliticBeenFollowed(any))
            .thenReturn(true);
        await tester.pumpWidget(
          connectedWidget(
            PageConnected<PoliticSuggestionBloc>(
              bloc: mockPoliticSuggestionBloc,
              page: PoliticSuggestionPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(PoliticsSuggestedGrid), findsOneWidget);
        expect(find.byType(PoliticSuggested), findsNWidgets(2));
      });
    });

    testWidgets('should call unfollow event when click on unfollow button',
        (tester) async {
      provideMockedNetworkImages(() async {
        final politicos = [
          PoliticoModel(
            id: '1',
            nomeEleitoral: 'nome',
            urlFoto: '',
          ),
        ];
        final mockPoliticSuggestionBloc = MockPoliticSuggestionBloc();
        when(mockPoliticSuggestionBloc.politics).thenReturn(politicos);
        when(mockPoliticSuggestionBloc.state)
            .thenReturn(FetchSuggestedPoliticsSuccess(politicos));
        when(mockPoliticSuggestionBloc.isPoliticBeenFollowed(any))
            .thenReturn(true);
        await tester.pumpWidget(
          connectedWidget(
            PageConnected<PoliticSuggestionBloc>(
              bloc: mockPoliticSuggestionBloc,
              page: PoliticSuggestionPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final politicoCard = find.byType(PoliticSuggested);
        expect(politicoCard, findsOneWidget);
        final followButton = find.byType(GFButton);
        expect(followButton, findsOneWidget);
        expect(find.text(STOP_FOLLOWING), findsOneWidget);
        await tester.tap(followButton);
        await tester.pumpAndSettle();
        verify(
          mockPoliticSuggestionBloc.add(
            FollowOrUnfollowPolitic(
              PoliticoModel(
                id: '1',
                nomeEleitoral: 'nome',
                urlFoto: '',
              ),
            ),
          ),
        ).called(1);
      });
    });

    testWidgets('should call follow event when click on follow button',
        (tester) async {
      provideMockedNetworkImages(() async {
        final politicos = [
          PoliticoModel(
            id: '1',
            nomeEleitoral: 'nome',
            urlFoto: '',
          ),
        ];
        final mockPoliticSuggestionBloc = MockPoliticSuggestionBloc();
        when(mockPoliticSuggestionBloc.politics).thenReturn(politicos);
        when(mockPoliticSuggestionBloc.state)
            .thenReturn(FetchSuggestedPoliticsSuccess(politicos));
        when(mockPoliticSuggestionBloc.isPoliticBeenFollowed(any))
            .thenReturn(false);
        await tester.pumpWidget(
          connectedWidget(
            PageConnected<PoliticSuggestionBloc>(
              bloc: mockPoliticSuggestionBloc,
              page: PoliticSuggestionPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final politicoCard = find.byType(PoliticSuggested);
        expect(politicoCard, findsOneWidget);
        final followButton = find.byType(GFButton);
        expect(followButton, findsOneWidget);
        expect(find.text(FOLLOW), findsOneWidget);
        await tester.tap(followButton);
        await tester.pumpAndSettle();
        verify(
          mockPoliticSuggestionBloc.add(
            FollowOrUnfollowPolitic(
              PoliticoModel(
                id: '1',
                nomeEleitoral: 'nome',
                urlFoto: '',
              ),
            ),
          ),
        ).called(1);
      });
    });
  });
}
