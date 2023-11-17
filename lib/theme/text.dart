import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "colors.dart";

class CText {
  static Widget heading(String text, {Color? color, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.rubik(
        fontSize: 52,
        fontWeight: FontWeight.w600,
        color: color ?? CColors.white,
      ),
    );
  }

  static Widget subheading(String text, {Color? color, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.rubik(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: color ?? CColors.white,
      ),
    );
  }

  static Widget title(String text, {Color? color, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.rubik(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color ?? CColors.white,
      ),
    );
  }

  static Widget subtitle(String text, {Color? color, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: color ?? CColors.white,
      ),
    );
  }

  static Widget superlabel(String text, {Color? color, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? const Color(0x80FFFFFF),
      ),
    );
  }

  static Widget label(String text, {Color? color, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.rubik(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: color ?? CColors.white,
      ),
    );
  }

  static Widget sublabel(String text, {Color? color, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.rubik(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: color ?? const Color(0x80FFFFFF),
      ),
    );
  }

  static Widget paragraph(String text, {Color? color, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.rubik(
        fontSize: 18,
        fontWeight: FontWeight.w300,
        color: color ?? CColors.white,
      ),
    );
  }

  static Widget button(String text, {Color? color, TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.left,
      style: GoogleFonts.rubik(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: color ?? CColors.white,
      ),
    );
  }
}
