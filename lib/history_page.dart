import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main_page.dart'; // Pastikan untuk mengimpor model Todo

class HistoryPage extends StatelessWidget {
  final List<Todo> completedTodos;

  HistoryPage({required this.completedTodos});

  @override
  Widget build(BuildContext context) {
    // Mengambil tema saat ini dari context untuk mendukung tema gelap
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Tugas',
          style: TextStyle(color: theme.appBarTheme.titleTextStyle?.color ?? Colors.white), // Menggunakan warna dari tema
        ),
        backgroundColor: theme.appBarTheme.backgroundColor ?? Colors.teal, // Menggunakan warna AppBar dari tema
        automaticallyImplyLeading: false, // Menonaktifkan tombol kembali
      ),
      body: completedTodos.isEmpty
          ? Center(
        child: Text(
          'Tidak ada tugas yang diselesaikan',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color), // Menggunakan warna teks dari tema
        ),
      )
          : ListView.builder(
        itemCount: completedTodos.length,
        itemBuilder: (context, index) {
          final todo = completedTodos[index];
          return ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: theme.textTheme.bodyLarge?.color, // Menggunakan warna teks dari tema
              ),
            ),
            subtitle: Text(
              'Diselesaikan pada: ${DateFormat('dd-MM-yyyy').format(todo.completedDate!)}',
              style: TextStyle(color: theme.textTheme.bodySmall?.color), // Menggunakan warna subtitle dari tema
            ),
          );
        },
      ),
    );
  }
}
