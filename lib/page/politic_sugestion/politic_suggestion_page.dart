import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_router/simple_router.dart';

import '../../bloc/politic_suggestion/bloc.dart';
import '../../core/routing/route_names.dart';
import '../../widget/centered_loading.dart';
import '../timeline/timeline_page.dart';
import 'widget/politics_sugestion.dart';

class PoliticSuggestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = context.bloc<PoliticSuggestionBloc>();
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer(
          bloc: _bloc,
          listener: (_, state) {
            if (state is SavedSuggestedPolitics) {
              SimpleRouter.forwardAndReplace(
                TimelinePage(),
                name: TIMELINE_PAGE,
              );
            }
          },
          builder: (_, state) {
            if (state is LoadingFetch || state is LoadingSaveFollowPolitics) {
              return CenteredLoading();
            } else if (state is FetchSuggestedPoliticsSuccess ||
                state is ChangedPoliticsFollowingStatus) {
              return PoliticsSuggestion();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
