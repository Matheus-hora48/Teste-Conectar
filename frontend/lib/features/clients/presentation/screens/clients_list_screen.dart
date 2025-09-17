import 'package:flutter/material.dart';
import '../widgets/clients_table_widget.dart';
import '../widgets/dados_basicos_tab_widget.dart';
import '../../../../core/widgets/main_app_bar_widget.dart';

class ClientsListScreen extends StatefulWidget {
  const ClientsListScreen({super.key});

  @override
  State<ClientsListScreen> createState() => _ClientsListScreenState();
}

class _ClientsListScreenState extends State<ClientsListScreen> {
  final _nameFilterController = TextEditingController();
  final _cnpjFilterController = TextEditingController();
  final _cidadeFilterController = TextEditingController();
  bool _isFiltersExpanded = false;

  @override
  void dispose() {
    _nameFilterController.dispose();
    _cnpjFilterController.dispose();
    _cidadeFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBarWidget(currentTab: 'clientes'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Dados Básicos',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Container(height: 2, width: 130, color: Colors.black87),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.all(16),
            child: DadosBasicosTabWidget(
              isFiltersExpanded: _isFiltersExpanded,
              onToggle: () {
                setState(() {
                  _isFiltersExpanded = !_isFiltersExpanded;
                });
              },
              nameController: _nameFilterController,
              cnpjController: _cnpjFilterController,
              cidadeController: _cidadeFilterController,
            ),
          ),

          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
              child: const ClientsTableWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
