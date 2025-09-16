import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_colors.dart';
import 'package:frontend/features/clients/presentation/widgets/clients_section_header_widget.dart';
import 'package:get/get.dart';
import '../../domain/models/client.dart';
import '../controllers/clients_controller.dart';

class ClientsTableWidget extends StatelessWidget {
  const ClientsTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ClientsController controller = Get.find<ClientsController>();

    return Obx(() {
      if (controller.isLoading) {
        return const Expanded(
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF2ECC71)),
          ),
        );
      }

      if (controller.clients.isEmpty) {
        return const Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhum cliente encontrado',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha:  0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const ClientsSectionHeaderWidget(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Razão social',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'CNPJ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Nome na fachada',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Tags',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Conecta Plus',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    itemCount: controller.clients.length,
                    itemBuilder: (context, index) {
                      final client = controller.clients[index];

                      return InkWell(
                        onTap: () => Get.toNamed('/clients/edit/${client.id}'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),

                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  client.companyName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  client.cnpj,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  client.storeFrontName,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  '-',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      client.status,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getStatusText(client.status),
                                    style: TextStyle(
                                      color: _getStatusColor(client.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'Não',
                                  style: TextStyle(color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Color _getStatusColor(ClientStatus status) {
    switch (status) {
      case ClientStatus.ativo:
        return Colors.green;
      case ClientStatus.inativo:
        return Colors.red;
      case ClientStatus.pendente:
        return Colors.orange;
    }
  }

  String _getStatusText(ClientStatus status) {
    switch (status) {
      case ClientStatus.ativo:
        return 'Ativo';
      case ClientStatus.inativo:
        return 'Inativo';
      case ClientStatus.pendente:
        return 'Pendente';
    }
  }
}
