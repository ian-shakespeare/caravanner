import "package:caravanner/theme/colors.dart";
import "package:flutter/material.dart";

class TextInput extends StatelessWidget {
  final String hintText;
  const TextInput({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          filled: true,
          fillColor: CColors.faded,
          hintText: hintText,
          hintStyle: TextStyle(color: CColors.onSurface)),
    );
  }
}
