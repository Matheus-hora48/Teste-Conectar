import 'package:flutter/material.dart';

class CustomDropdownWidget<T> extends StatelessWidget {
  final String label;
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool enabled;
  final String? errorText;

  const CustomDropdownWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.enabled = true,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade400.withValues(alpha: 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            isDense: true,
            errorText: errorText,
          ),
          items: items,
          onChanged: enabled ? onChanged : null,
          dropdownColor: Colors.white,
          style: TextStyle(
            color: enabled ? Colors.black87 : Colors.grey,
            fontSize: 14,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: enabled ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}

class DropdownOption<T> {
  final T value;
  final String label;
  final Widget? icon;

  const DropdownOption({required this.value, required this.label, this.icon});

  DropdownMenuItem<T> toDropdownMenuItem() {
    return DropdownMenuItem<T>(
      value: value,
      child: Row(
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(label),
        ],
      ),
    );
  }
}

extension DropdownOptionsExtension<T> on List<DropdownOption<T>> {
  List<DropdownMenuItem<T>> toDropdownMenuItems() {
    return map((option) => option.toDropdownMenuItem()).toList();
  }
}
