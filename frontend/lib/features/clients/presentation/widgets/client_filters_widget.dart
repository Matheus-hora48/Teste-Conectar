import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:get/get.dart';
import '../../domain/models/client.dart';
import '../controllers/clients_controller.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_dropdown_widget.dart';

class ClientFiltersWidget extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final TextEditingController nameController;
  final TextEditingController cnpjController;
  final TextEditingController cidadeController;

  const ClientFiltersWidget({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.nameController,
    required this.cnpjController,
    required this.cidadeController,
  });

  @override
  State<ClientFiltersWidget> createState() => _ClientFiltersWidgetState();
}

class _ClientFiltersWidgetState extends State<ClientFiltersWidget> {
  final ClientsController _controller = Get.find<ClientsController>();

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
                        'Clique e busque seus items na página',
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
                                    controller: widget.cnpjController,
                                    label: 'Buscar por CNPJ',
                                    onChanged: (value) =>
                                        _controller.setCnpjFilter(value),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    controller: widget.cidadeController,
                                    label: 'Buscar por cidade',
                                    onChanged: (value) =>
                                        _controller.setCidadeFilter(value),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: _buildStatusDropdown()),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildActionButtons(),
                          ],
                        );
                      } else if (constraints.maxWidth > 600) {
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
                                    controller: widget.cnpjController,
                                    label: 'Buscar por CNPJ',
                                    onChanged: (value) =>
                                        _controller.setCnpjFilter(value),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: widget.cidadeController,
                                    label: 'Buscar por cidade',
                                    onChanged: (value) =>
                                        _controller.setCidadeFilter(value),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(child: _buildStatusDropdown()),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildActionButtons(),
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
                              controller: widget.cnpjController,
                              label: 'Buscar por CNPJ',
                              onChanged: (value) =>
                                  _controller.setCnpjFilter(value),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: widget.cidadeController,
                              label: 'Buscar por cidade',
                              onChanged: (value) =>
                                  _controller.setCidadeFilter(value),
                            ),
                            const SizedBox(height: 16),
                            _buildStatusDropdown(),
                            const SizedBox(height: 20),
                            _buildActionButtons(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Obx(
      () => CustomDropdownWidget<ClientStatus?>(
        label: 'Buscar por status',
        hintText: 'Selecione',
        value: _controller.statusFilter,
        items: [
          const DropdownMenuItem<ClientStatus?>(
            value: null,
            child: Text('Selecione'),
          ),
          ...ClientStatus.values.map((status) {
            return DropdownMenuItem(
              value: status,
              child: Text(status.name.capitalize ?? ''),
            );
          }),
        ],
        onChanged: (value) => _controller.setStatusFilter(value),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 250,
          height: 40,
          child: OutlinedButton(
            onPressed: () {
              widget.nameController.clear();
              widget.cnpjController.clear();
              widget.cidadeController.clear();
              _controller.clearFilters();
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryColor),
              foregroundColor: AppColors.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Limpar campos',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
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
            child: const Text(
              'Filtrar',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }
}
