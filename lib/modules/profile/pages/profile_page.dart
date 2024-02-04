import 'dart:io';

import 'package:coaching_app/components/components.dart';
import 'package:coaching_app/config/config.dart';
import 'package:coaching_app/constants/app_colors.dart';
import 'package:coaching_app/modules/authentication/pages/login_page.dart';
import 'package:coaching_app/modules/authentication/repo/auth_repository.dart';
import 'package:coaching_app/modules/goal/page/add_goal.dart';
import 'package:coaching_app/modules/journal/widgets/journal_text_widget.dart';
import 'package:coaching_app/modules/profile/cubit/get_goals/get_goals_cubit.dart';
import 'package:coaching_app/modules/profile/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/custom_appbar.dart';
import '../../../core/di/service_locator.dart';
import '../../../utils/display/dialogs/dialog_utils.dart';
import '../../../utils/display/display_utils.dart';
import '../../authentication/cubit/auth_cubit/auth_cubit.dart';
import '../widget/circular_cached_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = [
    Tab(
      text: 'Short Terms Goal',
    ),
    Tab(
      text: 'Long Terms Goal',
    ),
  ];

  late String profileUrl;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    profileUrl = _repository.user.profile != null
        ? sl<Flavors>().config.imageBaseUrl + _repository.user.profile
        : 'assets/images/png/placeholder.jpg';
    super.initState();
    context.read<GetGoalsCubit>().fetchGoals();
  }

  AuthRepository _repository = sl<AuthRepository>();

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        backgroundColor: AppColors.darkGrey1,
        actions: [
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.authStatus == AuthStatus.loggingOut) {
                DisplayUtils.showLoader();
              } else if (state.authStatus == AuthStatus.unauthenticated) {
                DisplayUtils.removeLoader();
                NavRouter.pushAndRemoveUntil(context, LoginPage());
                DisplayUtils.showToast(context, 'Logged out successfully');
              }
            },
            builder: (context, state) {
              return IconButton(
                onPressed: () async {
                  bool res = await DialogUtils.confirmationDialog(
                    context: context,
                    title: 'Logout?',
                    content: 'Are you sure, you want to logout?',
                  );
                  if (res) {
                    context.read<AuthCubit>().logout();
                  }
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    profileUrl.contains('http')
                        ? Hero(
                            tag: 'profile_image',
                            child: CircularCachedImage(
                              imageUrl: profileUrl,
                              width: 70,
                              height: 70,
                            ),
                          )
                        : SizedBox(
                            height: 70,
                            width: 70,
                            child: CircleAvatar(
                              backgroundImage: profileUrl.contains('assets/')
                                  ? AssetImage(profileUrl) as ImageProvider
                                  : FileImage(
                                      File(profileUrl),
                                    ),
                            ),
                          ),
                    SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _repository.user.fullName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  NavRouter.push(context, EditProfilePage())
                                      .then((value) {
                                    profileUrl = _repository.user.profile !=
                                            null
                                        ? sl<Flavors>().config.imageBaseUrl +
                                            _repository.user.profile
                                        : 'assets/images/profile.jpeg';
                                    setState(() {});
                                  });
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.zero,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.darkGrey3,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _repository.user.personalInfo.isNotEmpty
                        ? _repository.user.personalInfo
                        : 'Personal Introduction',
                    maxLines: 3,
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: AppColors.darkGrey2,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16) +
                      EdgeInsets.only(top: 8),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.darkGrey3,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.black),
                      labelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      unselectedLabelColor: AppColors.greyText,
                      tabs: _tabs,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<GetGoalsCubit, GetGoalsState>(
                    builder: (context, state) {
                      if (state.getGoalsStatus == GetGoalsStatus.loading) {
                        return Center(
                          child: LoadingIndicator(),
                        );
                      }
                      if (state.getGoalsStatus == GetGoalsStatus.success) {
                        return TabBarView(
                          controller: _tabController,
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              itemCount: state.goals.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return state.goals[index].goalType == 0
                                    ? JournalTextWidget(
                                        text: state.goals[index].description,
                                        textStyle: TextStyle(),
                                      )
                                    : EmptyWidget();
                              },
                            ),
                            ListView.builder(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 16),
                              itemCount: state.goals.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return state.goals[index].goalType == 1
                                    ? JournalTextWidget(
                                        text: state.goals[index].description,
                                        textStyle: TextStyle(),
                                      )
                                    : EmptyWidget();
                              },
                            )
                          ],
                        );
                      }
                      if (state.getGoalsStatus == GetGoalsStatus.failure) {
                        return Center(
                          child: Text(state.failure.message),
                        );
                      }
                      return EmptyWidget();
                    },
                  ),
                )
              ],
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavRouter.push(context, AddGoal()).then((value) {
            context.read<GetGoalsCubit>().fetchGoals();
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: AppColors.secondary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
