import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:frontend/core/constants/app_colors.dart';
import '../controllers/users_controller.dart';

class UsersSectionHeaderWidget extends StatelessWidget {
  const UsersSectionHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final UsersController controller = Get.find<UsersController>();

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Usuários',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      '${controller.users.length} usuário(s) encontrado(s)',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed('/users/create');
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Novo Usuário',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
