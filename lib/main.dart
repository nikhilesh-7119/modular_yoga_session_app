import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modular_yoga_session_app/config/theme.dart';
import 'package:modular_yoga_session_app/pages/homePage/home_page.dart';
import 'package:modular_yoga_session_app/pages/splashPage/splash_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://foeheczywygjscvcedww.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZvZWhlY3p5d3lnanNjdmNlZHd3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0ODQ5MzAsImV4cCI6MjA3MDA2MDkzMH0.loXEZznZfi3GJP2Q338YBuPJxDCYWW1Uyk5oCKoClmA',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Yoga Session App',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: SplashPage(),
    );
  }
}
