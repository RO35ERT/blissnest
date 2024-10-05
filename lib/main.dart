import 'package:blissnest/core/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/navigation/routes.dart';
import 'theme/colors.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const BlissNestApp(),
    ),
  );
}

class BlissNestApp extends StatelessWidget {
  const BlissNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlissNest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: peachColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: peachColor,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: orangeColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      initialRoute: '/', // Define the initial route
      routes: routes, // Use the routes defined in routes.dart
    );
  }
}
