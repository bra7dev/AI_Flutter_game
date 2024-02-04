import 'package:bot_toast/bot_toast.dart';
import 'package:coaching_app/config/themes/light_theme.dart';
import 'package:coaching_app/modules/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/unfocus.dart';
import '../../core/di/service_locator.dart';
import '../../modules/authentication/cubit/auth_cubit/auth_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(sl())..init(),
      child: MaterialApp(
        title: 'Coaching App',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        builder: (BuildContext context, Widget? child) {
          child = BotToastInit()(context, child);
          child = UnFocus(child: child);
          return child;
        },
        navigatorObservers: [BotToastNavigatorObserver()],
        home: SplashScreen(),
      ),
    );
  }
}
