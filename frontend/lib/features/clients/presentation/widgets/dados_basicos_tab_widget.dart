import 'package:flutter/material.dart';
import 'client_filters_widget.dart';

class DadosBasicosTabWidget extends StatefulWidget {
  final bool isFiltersExpanded;
  final VoidCallback onToggle;
  final TextEditingController nameController;
  final TextEditingController cnpjController;
  final TextEditingController cidadeController;

  const DadosBasicosTabWidget({
    super.key,
    required this.isFiltersExpanded,
    required this.onToggle,
    required this.nameController,
    required this.cnpjController,
    required this.cidadeController,
  });

  @override
  State<DadosBasicosTabWidget> createState() => _DadosBasicosTabWidgetState();
}

class _DadosBasicosTabWidgetState extends State<DadosBasicosTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ClientFiltersWidget(
            isExpanded: widget.isFiltersExpanded,
            onToggle: widget.onToggle,
            nameController: widget.nameController,
            cnpjController: widget.cnpjController,
            cidadeController: widget.cidadeController,
          ),
        ],
      ),
    );
  }
}
