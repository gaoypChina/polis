import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polis/bloc/blocs.dart';
import 'package:polis/model/models.dart';
import 'package:polis/page/page_connected.dart';
import 'package:polis/page/politic_profile/widget/politic_additional_info.dart';

import '../mock.dart';
import 'utils.dart';

void main() {
  MockPoliticProfileBloc mockPoliticProfileBloc;

  group('PoliticAdditionalInfo tests', () {
    setUp(() {
      mockPoliticProfileBloc = MockPoliticProfileBloc();
    });

    testWidgets('should build without exploding', (tester) async {
      await tester.pumpWidget(
        connectedWidget(
          PageConnected<PoliticProfileBloc>(
            bloc: mockPoliticProfileBloc,
            page: Scaffold(
              body: PoliticAdditionalInfo(
                PoliticoModel(
                  id: '1',
                  quantidadeSeguidores: 8.0,
                ),
              ),
            ),
          ),
        ),
      );
    });

    testWidgets('should go to followers page when clicking qtd',
        (tester) async {
      await tester.pumpWidget(
        connectedWidget(
          PageConnected<PoliticProfileBloc>(
            bloc: mockPoliticProfileBloc,
            page: Scaffold(
              body: PoliticAdditionalInfo(
                PoliticoModel(
                  id: '1',
                  quantidadeSeguidores: 8.0,
                ),
              ),
            ),
          ),
        ),
      );
      final followersCountButton =
          find.byKey(const ValueKey('followers-count-btn'));
      expect(followersCountButton, findsOneWidget);
      await tester.tap(followersCountButton);
      await tester.pumpAndSettle();
    });
  });
}