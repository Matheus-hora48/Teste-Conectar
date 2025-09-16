import 'package:flutter/material.dart';
import 'users_filters_widget.dart';

class UsersBasicDataTabWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final bool isExpanded;
  final VoidCallback onToggle;

  const UsersBasicDataTabWidget({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, right: 16, left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: UsersFiltersWidget(
        nameController: nameController,
        emailController: emailController,
        isExpanded: isExpanded,
        onToggle: onToggle,
      ),
    );
  }
}
