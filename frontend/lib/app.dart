import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/features/profile/presentation/screens/user_profile_screen.dart';
import 'package:frontend/features/profile/presentation/bindings/profile_binding.dart';
import 'package:frontend/features/clients/presentation/bindings/clients_binding.dart';
import 'package:frontend/features/clients/presentation/screens/clients_list_screen.dart';
import 'package:frontend/features/users/presentation/screens/users_list_screen.dart';
import 'package:frontend/features/users/presentation/screens/user_form_screen.dart';
import 'package:frontend/features/users/presentation/bindings/users_binding.dart';
import 'package:frontend/features/notifications/presentation/screens/notification_screen.dart';
import 'package:frontend/features/notifications/presentation/bindings/notification_binding.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:get/get.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/auth_callback_screen.dart';
import 'features/auth/presentation/bindings/auth_binding.dart';
import 'core/bindings/app_binding.dart';
import 'features/clients/presentation/screens/client_form_screen.dart';

class MyApp extends StatelessWidget {
  final String? initialRoute;

  const MyApp({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Conéctar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AppBinding(),
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const SplashScreen(),
      ),
      getPages: [
        GetPage(
          name: '/auth/callback',
          page: () => const AuthCallbackScreen(),
          binding: AuthBinding(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          binding: AuthBinding(),
        ),
        GetPage(name: '/', page: () => const SplashScreen()),
        GetPage(
          name: '/profile',
          page: () => const UserProfileScreen(),
          binding: ProfileBinding(),
        ),
        GetPage(
          name: '/clients',
          page: () => const ClientsListScreen(),
          binding: ClientsBinding(),
        ),
        GetPage(
          name: '/clients/create',
          page: () => const ClientFormScreen(),
          binding: ClientsBinding(),
        ),
        GetPage(
          name: '/clients/edit/:id',
          page: () => ClientFormScreen(
            clientId: int.tryParse(Get.parameters['id'] ?? '0'),
          ),
          binding: ClientsBinding(),
        ),
        GetPage(
          name: '/users',
          page: () => const UsersListScreen(),
          binding: UsersBinding(),
        ),
        GetPage(
          name: '/users/create',
          page: () => const UserFormScreen(),
          binding: UsersBinding(),
        ),
        GetPage(
          name: '/users/edit/:id',
          page: () =>
              UserFormScreen(userId: int.tryParse(Get.parameters['id'] ?? '0')),
          binding: UsersBinding(),
        ),
        GetPage(
          name: '/notifications',
          page: () => const NotificationScreen(),
          binding: NotificationBinding(),
        ),
      ],
      initialRoute: initialRoute ?? '/',
    );
  }
}
