import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:together/screens/chats/all_messages.dart';
import 'package:together/screens/find_location.dart';
import 'package:together/screens/home/home_screen.dart';
import 'package:together/screens/reminders.dart';
import 'package:together/screens/proflle/user_profile.dart';
import 'package:together/utils/colors.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key, required this.index}) : super(key: key);
  final int index;
  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 2);

  List<Widget> _buildScreens() {
    return [
      const MyAllMessages(),
      const UserProfileScreen(),
      const HomeScreen(),
      const MapSample(),
      const Reminders()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.chat,
          size: 30,
        ),
        title: ("Chats"),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.person,
          size: 30,
        ),
        title: ("Profile"),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.home,
          size: 30,
        ),
        title: ("Home"),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.manage_search_outlined,
          size: 30,
        ),
        title: ("Search"),
        activeColorPrimary: AppColor.primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          Icons.notifications,
          size: 30,
        ),
        title: ("Reminders"),
        activeColorPrimary: AppColor.primaryColor,
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
      stateManagement: false,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: const ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
