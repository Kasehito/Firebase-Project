import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool isRequired;
  final bool isPriceField;
  final int? maxLines;

  const CustomInputField({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.isRequired = true,
    this.isPriceField = false,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Color(0xFFD0F1EB),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixText: isPriceField ? 'Rp ' : null,
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFFF9F1C), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          inputFormatters: isPriceField
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    if (newValue.text.isEmpty) {
                      return newValue;
                    }
                    final number = int.parse(newValue.text);
                    final formatted =
                        NumberFormat.decimalPattern('id').format(number);
                    return TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }),
                ]
              : inputFormatters,
          keyboardType: isPriceField ? TextInputType.number : keyboardType,
          validator: isPriceField
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  final price = int.parse(value.replaceAll('.', ''));
                  if (price <= 0) {
                    return 'Please enter valid price';
                  }
                  return null;
                }
              : validator,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
