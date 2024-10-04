import 'package:blissnest/presentation/screens/home.dart';
import 'package:blissnest/presentation/screens/login.dart';
import 'package:blissnest/presentation/screens/register.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> routes = {
  '/': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/home': (context) => const HomeScreen(),
};
