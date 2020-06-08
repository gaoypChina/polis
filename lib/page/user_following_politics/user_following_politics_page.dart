import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_router/simple_router.dart';

import '../../bloc/blocs.dart';
import '../../core/routing/route_names.dart';
import '../../widget/default_bottombar.dart';
import '../../widget/error_container.dart';
import '../pages.dart';
import 'widget/following_politics_search.dart';
import 'widget/following_politics_skeleton.dart';

class UserFollowingPoliticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: DefaultBottombar(
        USER_FOLLOWING_POLITICS_PAGE,
        withBack: true,
        onPopCallback: () =>
            SimpleRouter.forwardAndReplace(UserProfilePageConnected()),
      ),
      body: SafeArea(
        child:
            BlocConsumer<UserFollowingPoliticsBloc, UserFollowingPoliticsState>(
          listener: (_, state) {},
          builder: (_, state) {
            if (state is FetchPoliticsSuccess) {
              return FollowingPoliticsSearch(state.politics);
            } else if (state is PoliticsFilteredByTerm) {
              return FollowingPoliticsSearch(state.filteredPolitics);
            } else if (state is FollowedPoliticsUpdated) {
              return FollowingPoliticsSearch(state.followedPolitics);
            } else if (state is FetchPoliticsFailed) {
              return const ErrorContainer();
            } else {
              return const FollowingPoliticsSkeleton();
            }
          },
        ),
      ),
    );
  }
}
