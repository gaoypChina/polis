import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/blocs.dart';
import '../../core/domain/model/models.dart';
import '../../core/i18n/i18n.dart';
import '../../widget/error_container.dart';
import '../../widget/loading.dart';
import '../../widget/text_title.dart';
import 'widget/expenses_by_month.dart';
import 'widget/see_expenses_button.dart';

class PoliticExpensesAnalysisPage extends StatelessWidget {
  PoliticExpensesAnalysisPage(this.politico);

  final PoliticoModel politico;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PoliticExpensesAnalysisBloc,
            PoliticExpensesAnalysisState>(builder: (_, state) {
          if (state is GetPoliticExpensesDataSuccess) {
            final totalDespesasAno = state.totalDespesasAnuais;
            return Column(
              children: <Widget>[
                const SizedBox(height: 8),
                TextTitle(EXPENSES_ANALYSIS),
                const SizedBox(height: 8),
                TextTitle(
                  '$EXPENSES_BY_MONTH_ON_YEAR ${totalDespesasAno.ano}',
                  fontSize: 12,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: ExpensesByMonth(
                      despesasPorMes: totalDespesasAno.despesasPorMes,
                    ),
                  ),
                ),
                SeeExpensesButton(politico),
              ],
            );
          } else if (state is LoadingPoliticExpensesData) {
            return const Loading();
          }
          return const ErrorContainer();
        }),
      ),
    );
  }
}
