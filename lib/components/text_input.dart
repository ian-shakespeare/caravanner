import "package:caravanner/theme/colors.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class CTextInput extends StatelessWidget {
  const CTextInput({
    super.key,
    required this.hintText,
    this.controller,
    this.obscureText = false,
    this.autocorrect = false,
    this.maxLines = 1,
    this.maxLength,
    this.enabled,
  });

  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final bool autocorrect;
  final int maxLines;
  final int? maxLength;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      autocorrect: autocorrect,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      cursorColor: const Color.fromARGB(200, 255, 255, 255),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
              width: 0.0, color: Color.fromARGB(0, 255, 255, 255)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
              width: 0.0, color: Color.fromARGB(0, 255, 255, 255)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(
              width: 0.0, color: Color.fromARGB(0, 255, 255, 255)),
        ),
        filled: true,
        fillColor: CColors.onSurface,
        hintText: hintText,
        hintStyle: GoogleFonts.rubik(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: const Color.fromARGB(150, 255, 255, 255)),
      ),
      style: GoogleFonts.rubik(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: const Color.fromARGB(200, 255, 255, 255)),
    );
  }
}
