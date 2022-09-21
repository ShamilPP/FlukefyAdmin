import 'package:flutter/material.dart';

class OutlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool numberKeyboard;
  final void Function(String)? onChanged;
  final int? maxLines;
  final String? suffixText;

  const OutlinedTextField({
    Key? key,
    required this.hint,
    required this.controller,
    this.numberKeyboard = false,
    this.onChanged,
    this.maxLines,
    this.suffixText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: numberKeyboard ? TextInputType.number : null,
          decoration: InputDecoration(
              hintText: hint, labelText: hint, border: const OutlineInputBorder(), suffixText: suffixText),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
