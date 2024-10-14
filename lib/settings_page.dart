import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final Function onSettingsChanged; // Callback function
  final Function(bool) toggleTheme; // Callback untuk tema gelap/terang

  SettingsPage({required this.onSettingsChanged, required this.toggleTheme}); // Constructor

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _nameController = TextEditingController();
  late SharedPreferences prefs;
  bool _isLoading = false; // Indikator loading
  bool _isDarkTheme = false; // Variabel untuk tema gelap

  @override
  void initState() {
    super.initState();
    _loadSettings(); // Memuat nama pengguna dan pengaturan tema ketika halaman diinisialisasi
  }

  // Fungsi untuk memuat nama pengguna dan tema dari SharedPreferences
  void _loadSettings() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('username') ?? '';
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false; // Memuat pengaturan tema
    });
  }

  // Fungsi untuk menyimpan nama pengguna ke SharedPreferences
  Future<void> _saveName() async {
    setState(() {
      _isLoading = true; // Menampilkan indikator loading saat menyimpan
    });
    await prefs.setString('username', _nameController.text);
    // Memanggil callback untuk memuat ulang nama di MainPage
    widget.onSettingsChanged();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nama pengguna disimpan')),
    );
    // Memuat nama baru setelah disimpan
    _loadSettings();
    setState(() {
      _isLoading = false; // Menyembunyikan indikator loading setelah selesai
    });
  }

  // Fungsi untuk menyimpan status tema gelap
  Future<void> _saveTheme(bool isDarkTheme) async {
    await prefs.setBool('isDarkTheme', isDarkTheme);
    widget.toggleTheme(isDarkTheme); // Memanggil fungsi untuk mengubah tema
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false, // Menonaktifkan tombol kembali
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Tema Gelap',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: _isDarkTheme,
                onChanged: (value) {
                  setState(() {
                    _isDarkTheme = value;
                    _saveTheme(value); // Simpan perubahan tema ke SharedPreferences
                  });
                },
              ),
            ),
            Divider(), // Menambahkan garis pemisah antara pengaturan
            ListTile(
              title: Text(
                'Notifikasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Switch(
                value: true, // Ganti dengan logika untuk mengelola notifikasi
                onChanged: (value) {
                  // Tambahkan logika untuk mengubah pengaturan notifikasi
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text(
                'Nama Pengguna',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Masukkan Nama Pengguna',
                ),
              ),
              trailing: IconButton(
                icon: _isLoading
                    ? CircularProgressIndicator() // Tampilkan indikator loading saat menyimpan
                    : Icon(Icons.save),
                onPressed: () async {
                  if (!_isLoading) { // Pastikan tidak ada penyimpanan yang sedang berlangsung
                    await _saveName(); // Memanggil fungsi simpan ketika ditekan
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
