import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/politic_profile/bloc.dart';
import '../../core/routing/route_names.dart';
import '../../i18n/i18n.dart';
import '../../widget/centered_loading.dart';
import '../../widget/default_bottombar.dart';
import 'widget/politic_action_buttons.dart';
import 'widget/politic_activities.dart';
import 'widget/politic_additional_info.dart';
import 'widget/politic_personal_info.dart';

class PoliticProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DefaultBottombar(SEARCH_POLITIC_PAGE),
      body: BlocBuilder<PoliticProfileBloc, PoliticProfileState>(
        builder: (_, state) {
          if (state is GetPoliticInfoSuccess) {
            final politic = state.politic;
            final lastActivities = state.lastActivities;
            return SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    PoliticPersonalInfo(politic),
                    const SizedBox(height: 14),
                    PoliticActionButtons(),
                    const SizedBox(height: 16),
                    PoliticAdditionalInfo(politic),
                    const SizedBox(height: 26),
                    const Divider(),
                    Container(
                      child: Expanded(
                        child: PoliticActivities(lastActivities),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is GetPoliticInfoFailed) {
            return const Center(
              child: Text(ERROR_FETCHING_POLITIC_INFO),
            );
          } else {
            return CenteredLoading();
          }
        },
      ),
    );
  }
}