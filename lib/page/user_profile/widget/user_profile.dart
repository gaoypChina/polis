import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_router/simple_router.dart';

import '../../../bloc/blocs.dart';
import '../../../bloc/user/user_bloc.dart';
import '../../../core/keys.dart';
import '../../../core/routing/route_names.dart';
import '../../../i18n/label.dart';
import '../../../model/models.dart';
import '../../../widget/text_title.dart';
import '../../pages.dart';
import '../../theme/main_theme.dart';
import 'personal_user_info.dart';
import 'politics_following_quantity.dart';
import 'user_activities.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({this.politicsFollowing, this.userActions});

  final List<PoliticoModel> politicsFollowing;
  final List<AcaoUsuarioModel> userActions;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return ExpandableBottomSheet(
      persistentContentHeight: MediaQuery.of(context).size.height - 460,
      persistentHeader: _buildHeader(),
      expandableContent: _buildPanel(context),
      background: _buildBody(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 6),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.accentColor.withOpacity(.25),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          TextTitle(MY_ACTIVITIES, fontSize: 15),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildPanel(BuildContext context) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: UserActions(actions: widget.userActions),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        _buildLogoutButton(),
        PersonalUserInfo(user: context.bloc<UserBloc>().user),
        const SizedBox(height: 16),
        PoliticsFollowingQuantity(politics: widget.politicsFollowing),
      ],
    );
  }

  Widget _buildLogoutButton() {
    final userBloc = context.bloc<UserBloc>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          key: logoutButtonKey,
          height: 30,
          child: OutlineButton.icon(
            padding: EdgeInsets.zero,
            label: Text(LOGOUT.toUpperCase()),
            icon: FaIcon(
              FontAwesomeIcons.signOutAlt,
              size: 18,
            ),
            color: Colors.red,
            textColor: Colors.red,
            highlightedBorderColor: Colors.red,
            onPressed: () {
              userBloc.add(Logout());
              SimpleRouter.forwardAndRemoveAll(
                InitialPageConnected(),
                name: INITIAL_PAGE,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
