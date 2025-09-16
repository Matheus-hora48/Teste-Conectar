import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/headed_page_widget.dart';
import '../widgets/users_table_widget.dart';
import '../widgets/users_basic_data_tab_widget.dart';
import '../../../../core/widgets/main_app_bar_widget.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  final _nameFilterController = TextEditingController();
  final _emailFilterController = TextEditingController();
  bool _isFiltersExpanded = false;

  @override
  void initState() {
    super.initState();

    _nameFilterController.addListener(() {});
    _emailFilterController.addListener(() {});
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    _emailFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBarWidget(currentTab: 'usuarios'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadedPageWidget(),
          UsersBasicDataTabWidget(
            nameController: _nameFilterController,
            emailController: _emailFilterController,
            isExpanded: _isFiltersExpanded,
            onToggle: () {
              setState(() {
                _isFiltersExpanded = !_isFiltersExpanded;
              });
            },
          ),
          const Expanded(child: UsersTableWidget()),
        ],
      ),
    );
  }
}
