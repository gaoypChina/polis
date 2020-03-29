import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:simple_router/simple_router.dart';

import '../bloc/blocs.dart';
import '../core/routing/route_names.dart';
import '../core/service/locator.dart';
import '../core/service/services.dart';
import '../i18n/i18n.dart';
import '../page/pages.dart';

enum DropDownOption { profile, logout }

class DefaultBottombar extends StatelessWidget {
  DefaultBottombar(
    this.routeName, {
    this.onPopCallback = SimpleRouter.back,
  });

  final String routeName;
  final VoidCallback onPopCallback;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            height: 40,
            alignment: Alignment.centerLeft,
            child: routeName == TIMELINE_PAGE
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      POLIS,
                      style: TextStyle(
                        fontFamily: 'Philosopher',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                : _buildButtonBottomAppBar(
                    key: const ValueKey('arrow-back-btn'),
                    icon: FontAwesomeIcons.chevronLeft,
                    padding: const EdgeInsets.only(right: 3),
                    onPressed: onPopCallback,
                  ),
          ),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              children: <Widget>[
                _buildButtonBottomAppBar(
                  icon: FontAwesomeIcons.home,
                  padding: const EdgeInsets.only(right: 3),
                  onPressed: () => SimpleRouter.forward(
                    TimelinePage(),
                    name: TIMELINE_PAGE,
                  ),
                ),
                _buildButtonBottomAppBar(
                  icon: FontAwesomeIcons.search,
                  onPressed: () => SimpleRouter.forward(
                    SearchPoliticPageConnected(),
                    name: SEARCH_POLITIC_PAGE,
                  ),
                ),
                _buildButtonBottomAppBar(
                  icon: FontAwesomeIcons.solidBookmark,
                  onPressed: () => SimpleRouter.forward(
                    FavoritePostsPage(),
                    name: FAVORITE_POSTS_PAGE,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 40,
            alignment: Alignment.centerRight,
            child: _buildUserButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildUserButton(BuildContext context) {
    final user = context.bloc<UserBloc>().user;

    Widget buildButtonContent() {
      return user.photoUrl != null
          ? Padding(
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FancyShimmerImage(
                  imageUrl: user.photoUrl,
                  width: 30,
                  height: 30,
                  boxFit: BoxFit.cover,
                ),
              ),
            )
          : Icon(
              FontAwesomeIcons.solidUserCircle,
              size: 28,
              key: const ValueKey('user-photoless-icon'),
            );
    }

    return Material(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 40,
        height: 40,
        child: PopupMenuButton(
          offset: const Offset(0, -95),
          tooltip: '',
          child: buildButtonContent(),
          onSelected: (selectedValue) {
            if (selectedValue == DropDownOption.profile) {
              SimpleRouter.forward(
                UserProfilePageConnected(),
                name: USER_PROFILE_PAGE,
              );
            } else {
              G<AnalyticsService>().logLogout(user.name);
              G<SharedPreferencesService>().setUser(null);
              SimpleRouter.forwardAndRemoveAll(
                InitialPage(),
                name: INITIAL_PAGE,
              );
            }
          },
          itemBuilder: (context) {
            return <PopupMenuEntry>[
              PopupMenuItem(
                height: 40,
                value: DropDownOption.profile,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 2),
                      child: Icon(
                        FontAwesomeIcons.userAlt,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      PROFILE,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                height: 40,
                value: DropDownOption.logout,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 2, bottom: 1),
                      child: Icon(
                        FontAwesomeIcons.signOutAlt,
                        size: 19,
                        color: Colors.red[400],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      LOGOUT,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red[600],
                      ),
                    ),
                  ],
                ),
              )
            ];
          },
        ),
      ),
    );
  }

  Widget _buildButtonBottomAppBar({
    Widget child,
    IconData icon,
    double iconSize,
    EdgeInsets padding = EdgeInsets.zero,
    Function onPressed,
    Key key,
  }) {
    return Container(
      width: 40,
      height: 40,
      child: FlatButton(
        key: key,
        child: icon != null ? Icon(icon, size: iconSize) : child,
        padding: padding,
        onPressed: onPressed,
      ),
    );
  }
}
