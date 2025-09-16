import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';

class MainAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String currentTab;

  const MainAppBarWidget({super.key, required this.currentTab});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return AppBar(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Conéctar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 20),

          Obx(() {
            if (authController.isLoading) {
              return Row(
                children: [
                  _buildTabButton('Clientes', currentTab == 'clientes', () {
                    Get.toNamed('/clients');
                  }),
                  const SizedBox(width: 16),
                  _buildTabButton('Perfil', currentTab == 'perfil', () {
                    Get.toNamed('/profile');
                  }),
                ],
              );
            }

            final isAdmin = authController.isAdmin;

            if (isAdmin) {
              return Row(
                children: [
                  _buildTabButton('Clientes', currentTab == 'clientes', () {
                    Get.toNamed('/clients');
                  }),
                  const SizedBox(width: 16),
                  _buildTabButton('Usuários', currentTab == 'usuarios', () {
                    Get.toNamed('/users');
                  }),
                  const SizedBox(width: 16),
                  _buildTabButton('Perfil', currentTab == 'perfil', () {
                    Get.toNamed('/profile');
                  }),
                ],
              );
            } else {
              return Row(
                children: [
                  _buildTabButton('Clientes', currentTab == 'clientes', () {
                    Get.toNamed('/clients');
                  }),
                  const SizedBox(width: 16),
                  _buildTabButton('Perfil', currentTab == 'perfil', () {
                    Get.toNamed('/profile');
                  }),
                ],
              );
            }
          }),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
              Get.offAllNamed('/login');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: Colors.white,
            ),
          ),

          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 20,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
