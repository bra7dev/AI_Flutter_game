import 'package:coaching_app/components/empty_page.dart';
import 'package:coaching_app/modules/chat/chat_screen.dart';
import 'package:coaching_app/modules/journal/pages/journal_page.dart';
import 'package:coaching_app/modules/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/constants.dart';
import 'dashboard_cubit.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    context.read<DashboardCubit>().resetInitialIndex(1);
    super.initState();
  }
  Widget _getCurrentPage(int index) {
    switch (index) {
      case 0:
        return const JournalPage();
      case 1:
        return ChatScreen();
      case 2:
        return const ProfilePage();
      default:
        return const EmptyPage(title: 'Default Page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: _getCurrentPage(currentIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (int index) {
              context.read<DashboardCubit>().changeIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/svg/ic-journal.svg',
                  height: 22,
                  colorFilter: ColorFilter.mode(
                      currentIndex == 0 ? AppColors.secondary : AppColors.white,
                      BlendMode.srcIn),
                ),
                label: 'Journal',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/png/bot.png',
                  height: 22,
                  color:
                      currentIndex == 1 ? AppColors.secondary : AppColors.white,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/svg/ic-profile.svg',
                  height: 22,
                  colorFilter: ColorFilter.mode(
                      currentIndex == 2 ? AppColors.secondary : AppColors.white,
                      BlendMode.srcIn),
                ),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
