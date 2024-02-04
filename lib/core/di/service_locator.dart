import 'package:coaching_app/modules/chat/repository/predefined_chat_repository.dart';
import 'package:coaching_app/modules/forget_password/repo/forget_pass_repo.dart';
import 'package:coaching_app/modules/goal/repo/add_goal_repo.dart';
import 'package:coaching_app/modules/journal/repo/journals_repo.dart';
import 'package:coaching_app/modules/notes/repo/notes_repo.dart';
import 'package:coaching_app/modules/profile/repo/change_password_repo.dart';
import 'package:coaching_app/modules/profile/repo/get_goals_repo.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/flavors/flavors.dart';
import '../../modules/authentication/repo/auth_repository.dart';
import '../../modules/chat/repository/chat_repository.dart';
import '../core.dart';
import '../notifications/cloud_messaging_service.dart';
import '../notifications/local_notification_service.dart';

final sl = GetIt.instance;

Future<void> initDependencies(AppEnv appEnv) async {
  sl.registerSingleton(Flavors()..initConfig(appEnv));
  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());

  // modules
  sl.registerSingletonWithDependencies<StorageService>(
    () => StorageService(sl()),
    dependsOn: [SharedPreferences],
  );
  sl.registerLazySingleton<NetworkService>(
    () => NetworkService(sl(), dio: Dio()),
  );

  // notifications
  sl.registerLazySingleton<CloudMessagingService>(
      () => CloudMessagingService());
  sl.registerLazySingleton<LocalNotificationsService>(
      () => LocalNotificationsService());

  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl(), sl()));
  sl.registerLazySingleton<ChangePasswordRepository>(() => ChangePasswordRepository());
  sl.registerLazySingleton<JournalsRepository>(() => JournalsRepository());
  sl.registerLazySingleton<AddGoalRepository>(() => AddGoalRepository());
  sl.registerLazySingleton<GetGoalsRepository>(() => GetGoalsRepository());
  sl.registerLazySingleton<ForgetPasswordRepository>(() => ForgetPasswordRepository());
  sl.registerLazySingleton<NotesRepository>(() => NotesRepository());
  sl.registerLazySingleton<ChatRepository>(() => ChatRepository());
  sl.registerLazySingleton<PredefinedChatRepository>(() => PredefinedChatRepository());
}
