import 'package:coaching_app/modules/splash/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/service_locator.dart';
import '../../startup/dashboard/dashboard.dart';
import '../authentication/pages/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(sl())..init(),
      child: BlocBuilder<SplashCubit, SplashState>(
          builder: (context, state) {
            if (state == SplashState.authenticated) {
              return Dashboard();
            } else if (state == SplashState.unauthenticated) {
              return LoginPage();
            }
            return Scaffold(
              body: Center(
                child: Image.asset(
                  'assets/images/png/app-logo.png', width: 235, height: 180,),
              ),
            );
          }
      ),
    );
  }
}
