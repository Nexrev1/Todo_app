import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan SharedPreferences
import 'main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light; // Default tema adalah terang

  @override
  void initState() {
    super.initState();
    _loadTheme(); // Memuat tema yang tersimpan
  }

  // Fungsi untuk memuat tema dari SharedPreferences
  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bool isDarkTheme = prefs.getBool('isDarkTheme') ?? false; // Default terang
      _themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // Fungsi untuk mengubah tema dan menyimpannya
  void _toggleTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    await prefs.setBool('isDarkTheme', isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData.light(), // Tema terang
      darkTheme: ThemeData.dark(), // Tema gelap
      themeMode: _themeMode, // Mode tema mengikuti pengaturan pengguna
      home: MainPage(toggleTheme: _toggleTheme), // Luluskan fungsi untuk mengubah tema
      debugShowCheckedModeBanner: false, // Menonaktifkan banner debug
    );
  }
}
