import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_router/simple_router.dart';

import '../../../bloc/blocs.dart';
import '../../../core/routing/route_names.dart';
import '../../../i18n/i18n.dart';
import '../../../model/models.dart';
import '../../../widget/button_follow_unfollow.dart';
import '../../../widget/card_base.dart';
import '../../../widget/not_found.dart';
import '../../../widget/photo_politic.dart';
import '../../pages.dart';

class SearchPoliticsList extends StatelessWidget {
  SearchPoliticsList(this.politicos);

  final List<PoliticoModel> politicos;

  @override
  Widget build(BuildContext context) {
    return politicos.isNotEmpty
        ? _buildList(context)
        : NotFound(msg: NO_RESULTS_FROM_SEARCH);
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      key: const ValueKey('politics-list'),
      separatorBuilder: (_, i) => const Divider(
        height: 1,
        indent: 8,
        endIndent: 8,
      ),
      itemCount: politicos.length,
      itemBuilder: (_, i) => _buildCard(context, politicos[i]),
    );
  }

  Widget _buildCard(BuildContext context, PoliticoModel politico) {
    final bloc = context.bloc<SearchPoliticBloc>();

    return CardBase(
      key: ValueKey(politico.id),
      crossAxisAlignment: CrossAxisAlignment.center,
      slotLeft: PhotoPolitic(urlPhoto: politico.urlFoto),
      slotCenter: _buildCardContent(context, politico),
      slotRight: ButtonFollowUnfollow(
        isFollow: bloc.isPoliticBeingFollowed(politico),
        key: const ValueKey('follow-unfollow-btn'),
        onPressed: () => bloc.add(
          FollowUnfollowSearchPolitic(
            user: context.bloc<UserBloc>().user,
            politico: politico,
          ),
        ),
      ),
      onTap: () => SimpleRouter.forward(
        PoliticProfilePageConnected(politico.id),
        name: POLITIC_PROFILE_PAGE,
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, PoliticoModel politico) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 2,
      children: <Widget>[
        Text(
          politico.nomeEleitoral,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$POLITIC · ${politico.siglaPartido}'
          ' · ${politico.siglaUf}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
