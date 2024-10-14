import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTodoPage extends StatefulWidget {
  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  void _saveTodo() {
    final todo = _controller.text;
    final deadline = _selectedDate ?? DateTime.now();

    if (todo.isNotEmpty) {
      Navigator.pop(context, {
        'title': todo,
        'deadline': deadline,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tugas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal, // Ubah warna AppBar menjadi hijau teal
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Tugas',
              style: theme.textTheme.headlineSmall?.copyWith(color: Colors.teal), // Warna teks hijau teal
            ),
            SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Masukkan nama tugas',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'Pilih Tanggal Deadline'
                      : 'Deadline: ${DateFormat('dd-MM-yyyy').format(_selectedDate!)}',
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.teal), // Warna teks hijau teal
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Pilih Tanggal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Warna tombol hijau teal
                    foregroundColor: Colors.white, // Teks kontras putih
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _saveTodo,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Warna tombol hijau teal
                  foregroundColor: Colors.white, // Teks kontras putih
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
