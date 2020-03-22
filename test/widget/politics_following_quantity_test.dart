import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polis/bloc/blocs.dart';
import 'package:polis/model/user_model.dart';
import 'package:polis/page/user_profile/widget/politics_following_quantity.dart';

import '../mock.dart';
import 'utils.dart';

void main() {
  group('PoliticsFollowingQuantity tests', () {
    testWidgets('should go to UserFollowingPoliticsPage when click quantity',
        (tester) async {
      await tester.pumpWidget(
        connectedWidget(
          BlocProvider.value(
            value: UserBloc(
              user: UserModel(userId: '1'),
              repository: MockUserRepository(),
            ),
            child: PoliticsFollowingQuantity(
              politics: [],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final qtdButton = find.byType(GestureDetector);
      expect(qtdButton, findsOneWidget);
      await tester.tap(qtdButton);
    });
  });
}