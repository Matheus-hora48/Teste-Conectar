import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:get/get.dart';

class ClientFormAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final TabController tabController;
  final VoidCallback onSave;
  final bool isLoading;

  const ClientFormAppBarWidget({
    super.key,
    required this.title,
    required this.tabController,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Get.back(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.save, size: 18),
            label: Text(
              isLoading ? 'Salvando...' : 'Salvar',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
      bottom: TabBar(
        controller: tabController,
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: AppColors.primaryColor,
        indicatorWeight: 2,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: 'Dados Cadastrais', icon: Icon(Icons.business, size: 20)),
          Tab(
            text: 'Informações Internas',
            icon: Icon(Icons.info_outline, size: 20),
          ),
          Tab(
            text: 'Usuários Atribuídos',
            icon: Icon(Icons.people_outline, size: 20),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}
