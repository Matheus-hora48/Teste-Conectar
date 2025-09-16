import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:get/get.dart';
import '../../domain/models/user_model.dart';
import '../controllers/users_controller.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_dropdown_widget.dart';

class UsersFiltersWidget extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final TextEditingController nameController;
  final TextEditingController emailController;

  const UsersFiltersWidget({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.nameController,
    required this.emailController,
  });

  @override
  State<UsersFiltersWidget> createState() =>
      _UsersFiltersWidgetState();
}

class _UsersFiltersWidgetState extends State<UsersFiltersWidget> {
  final UsersController _controller = Get.find<UsersController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Column(
        children: [
          InkWell(
            onTap: widget.onToggle,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.primaryColor, size: 20),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filtros',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Text(
                        'Clique e busque seus usuários na página',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const SizedBox(width: 8),
                  Icon(
                    widget.isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
          if (widget.isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 1200) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: widget.nameController,
                                    label: 'Buscar por nome',
                                    onChanged: (value) =>
                                        _controller.setNameFilter(value),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    controller: widget.emailController,
                                    label: 'Buscar por email',
                                    onChanged: (value) =>
                                        _controller.setEmailFilter(value),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => CustomDropdownWidget<UserStatus?>(
                                      value: _controller.statusFilter,
                                      label: 'Status',
                                      hintText: 'Selecione o status',
                                      items: [
                                        const DropdownMenuItem<UserStatus?>(
                                          value: null,
                                          child: Text('Todos'),
                                        ),
                                        ...UserStatus.values.map((status) {
                                          return DropdownMenuItem<UserStatus?>(
                                            value: status,
                                            child: Text(
                                              _getStatusDisplayName(status),
                                            ),
                                          );
                                        }),
                                      ],
                                      onChanged: (value) =>
                                          _controller.setStatusFilter(value),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Obx(
                                    () => CustomDropdownWidget<UserRole?>(
                                      value: _controller.roleFilter,
                                      label: 'Perfil',
                                      hintText: 'Selecione o perfil',
                                      items: [
                                        const DropdownMenuItem<UserRole?>(
                                          value: null,
                                          child: Text('Todos'),
                                        ),
                                        ...UserRole.values.map((role) {
                                          return DropdownMenuItem<UserRole?>(
                                            value: role,
                                            child: Text(
                                              _getRoleDisplayName(role),
                                            ),
                                          );
                                        }),
                                      ],
                                      onChanged: (value) =>
                                          _controller.setRoleFilter(value),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: SizedBox(),
                                ), // Espaço vazio para manter alinhamento
                              ],
                            ),
                          ],
                        );
                      } else if (constraints.maxWidth > 800) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: widget.nameController,
                                    label: 'Buscar por nome',
                                    onChanged: (value) =>
                                        _controller.setNameFilter(value),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    controller: widget.emailController,
                                    label: 'Buscar por email',
                                    onChanged: (value) =>
                                        _controller.setEmailFilter(value),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => CustomDropdownWidget<UserStatus?>(
                                      value: _controller.statusFilter,
                                      label: 'Status',
                                      hintText: 'Selecione o status',
                                      items: [
                                        const DropdownMenuItem<UserStatus?>(
                                          value: null,
                                          child: Text('Todos'),
                                        ),
                                        ...UserStatus.values.map((status) {
                                          return DropdownMenuItem<UserStatus?>(
                                            value: status,
                                            child: Text(
                                              _getStatusDisplayName(status),
                                            ),
                                          );
                                        }),
                                      ],
                                      onChanged: (value) =>
                                          _controller.setStatusFilter(value),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(
                                    () => CustomDropdownWidget<UserRole?>(
                                      value: _controller.roleFilter,
                                      label: 'Perfil',
                                      hintText: 'Selecione o perfil',
                                      items: [
                                        const DropdownMenuItem<UserRole?>(
                                          value: null,
                                          child: Text('Todos'),
                                        ),
                                        ...UserRole.values.map((role) {
                                          return DropdownMenuItem<UserRole?>(
                                            value: role,
                                            child: Text(
                                              _getRoleDisplayName(role),
                                            ),
                                          );
                                        }),
                                      ],
                                      onChanged: (value) =>
                                          _controller.setRoleFilter(value),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            CustomTextField(
                              controller: widget.nameController,
                              label: 'Buscar por nome',
                              onChanged: (value) =>
                                  _controller.setNameFilter(value),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: widget.emailController,
                              label: 'Buscar por email',
                              onChanged: (value) =>
                                  _controller.setEmailFilter(value),
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => CustomDropdownWidget<UserStatus?>(
                                value: _controller.statusFilter,
                                label: 'Status',
                                hintText: 'Selecione o status',
                                items: [
                                  const DropdownMenuItem<UserStatus?>(
                                    value: null,
                                    child: Text('Todos'),
                                  ),
                                  ...UserStatus.values.map((status) {
                                    return DropdownMenuItem<UserStatus?>(
                                      value: status,
                                      child: Text(
                                        _getStatusDisplayName(status),
                                      ),
                                    );
                                  }),
                                ],
                                onChanged: (value) =>
                                    _controller.setStatusFilter(value),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Obx(
                              () => CustomDropdownWidget<UserRole?>(
                                value: _controller.roleFilter,
                                label: 'Perfil',
                                hintText: 'Selecione o perfil',
                                items: [
                                  const DropdownMenuItem<UserRole?>(
                                    value: null,
                                    child: Text('Todos'),
                                  ),
                                  ...UserRole.values.map((role) {
                                    return DropdownMenuItem<UserRole?>(
                                      value: role,
                                      child: Text(_getRoleDisplayName(role)),
                                    );
                                  }),
                                ],
                                onChanged: (value) =>
                                    _controller.setRoleFilter(value),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            widget.nameController.clear();
                            widget.emailController.clear();
                            _controller.clearFilters();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.primaryColor,
                            ),
                            foregroundColor: AppColors.primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Limpar filtros'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 250,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () => _controller.applyFilters(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Buscar'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _getStatusDisplayName(UserStatus status) {
    switch (status) {
      case UserStatus.ativo:
        return 'Ativo';
      case UserStatus.inativo:
        return 'Inativo';
      case UserStatus.pendente:
        return 'Pendente';
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.user:
        return 'Usuário';
    }
  }
}
