import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:together/screens/all_messages.dart';
import 'package:together/screens/event_details.dart';
import 'package:together/screens/find_location.dart';
import 'package:together/screens/home_screen.dart';
import 'package:together/screens/reminders.dart';
import 'package:together/screens/select_category.dart';
import 'package:together/screens/user_profile.dart';

class CustomNavigationBar extends StatefulWidget {
  CustomNavigationBar({Key? key, required this.index}) : super(key: key);
  int index = 2;
  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 2);

  List<Widget> _buildScreens() {
    return [
      myAllMessages(),
      UserProfileScreen(),
      HomeScreen(),
      FindLocationScreen(),
      Reminders()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.chat,
          size: 30,
        ),
        title: ("Chats"),
        activeColorPrimary: Color(0xFF142867),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.person,
          size: 30,
        ),
        title: ("Profile"),
        activeColorPrimary: Color(0xFF142867),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home,
          size: 30,
        ),
        title: ("Home"),
        activeColorPrimary: Color(0xFF142867),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.manage_search_outlined,
          size: 30,
        ),
        title: ("Search"),
        activeColorPrimary: Color(0xFF142867),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.notifications,
          size: 30,
        ),
        title: ("Reminders"),
        activeColorPrimary: Color(0xFF142867),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      navBarHeight: 80,
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
