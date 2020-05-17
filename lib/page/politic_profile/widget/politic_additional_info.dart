import 'package:flutter/material.dart';
import 'package:simple_router/simple_router.dart';

import '../../../core/routing/route_names.dart';
import '../../../extension/extensions.dart';
import '../../../i18n/i18n.dart';
import '../../../model/models.dart';
import '../../pages.dart';

class PoliticAdditionalInfo extends StatelessWidget {
  PoliticAdditionalInfo(this.politic);

  final PoliticoModel politic;

  int get quantidadeSeguidores => (politic.quantidadeSeguidores ?? 0).toInt();
  double get totalDespesas => (politic.totalDespesas ?? 0).toDouble();
  int get totalProposicoes => (politic.totalProposicoes ?? 0).toInt();
  String get position =>
      '${politic.rankingPosDespesa?.toString()}º' ?? NO_POSITION;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () => SimpleRouter.forward(
                PoliticFollowersPageConnected(politic.id),
                name: POLITIC_FOLLOWERS_PAGE,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    quantidadeSeguidores.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    quantidadeSeguidores == 1 ? FOLLOWER : FOLLOWERS,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: <Widget>[
                Text(
                  totalProposicoes.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  PROPOSERS,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          children: <Widget>[
            Text(
              '${totalDespesas.formatCurrency()} ($position)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              EXPENSES,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
