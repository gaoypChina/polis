import 'package:flutter/material.dart';

import '../../../model/despesa_model.dart';
import '../../../model/proposta_model.dart';
import 'despesa_tile.dart';

class Timeline extends StatelessWidget {
  Timeline({this.despesas, this.propostas});

  final List<DespesaModel> despesas;
  final List<PropostaModel> propostas;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (_, i) => DespesaTile(despesas[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: despesas.length,
    );
  }
}