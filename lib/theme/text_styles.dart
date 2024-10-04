import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static final TextStyle header = GoogleFonts.poppins(
    color: orangeColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle body = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 16,
  );

  static final TextStyle button = GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}
