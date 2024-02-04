import 'package:coaching_app/modules/authentication/cubit/login_cubit/login_cubit.dart';
import 'package:coaching_app/modules/chat/cubit/chat_cubit.dart';
import 'package:coaching_app/modules/journal/cubit/get_journal/get_journal_cubit.dart';
import 'package:coaching_app/modules/journal/cubit/get_time_slots/get_time_slots_cubit.dart';
import 'package:coaching_app/modules/notes/cubit/get_notes/get_notes_cubit.dart';
import 'package:coaching_app/modules/profile/cubit/get_goals/get_goals_cubit.dart';
import 'package:coaching_app/startup/dashboard/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


import 'config/flavors/flavors.dart';
import 'core/di/service_locator.dart';
import 'modules/authentication/cubit/auth_cubit/auth_cubit.dart';
import 'startup/app/my_app.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  initDependencies(AppEnv.dev);
  await sl.allReady();
  FlutterNativeSplash.remove();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit(sl())),
        BlocProvider<LoginCubit>(create: (_) => LoginCubit(sl())),
        BlocProvider<DashboardCubit>(create: (_) => DashboardCubit()),
        BlocProvider<GetJournalCubit>(create: (_) => GetJournalCubit(sl())),
        BlocProvider<GetNotesCubit>(create: (_) => GetNotesCubit(sl())),
        BlocProvider<GetGoalsCubit>(create: (_) => GetGoalsCubit(sl())),
        BlocProvider<ChatCubit>(create: (_) => ChatCubit(sl(), sl())),
        BlocProvider<GetTimeSlotsCubit>(create: (_) => GetTimeSlotsCubit(sl(), sl())),
      ],
      child: const MyApp(),
    ),
  );
}
