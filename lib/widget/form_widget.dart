import 'package:flutter/material.dart';

class ShopWidget {
  Widget buildForm(
      {required TextEditingController controller,
      String? hintText,
      IconData? icon,
      bool? isRequired,
      TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        decoration: InputDecoration(
            helperText: (isRequired ?? false) ? 'required' : 'Optional',
            prefixIcon: icon == null ? null : Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: hintText ?? 'Enter sometext'),
      ),
    );
  }
}
