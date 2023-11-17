import "package:caravanner/theme/colors.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class CButtonSecondary extends StatelessWidget {
  final String text;
  final Widget leader;
  final void Function() onPressed;
  const CButtonSecondary(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.leader});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0)),
          backgroundColor: MaterialStatePropertyAll<Color>(CColors.onSurface),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            leader,
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: CText.button(text,
                        color: Colors.white, textAlign: TextAlign.center)))
          ],
        ));
  }
}

class CButtonPrimary extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const CButtonPrimary({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          padding: const MaterialStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0)),
          backgroundColor: MaterialStatePropertyAll<Color>(CColors.primary),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: CColors.white,
            ),
          ),
        ));
  }
}
