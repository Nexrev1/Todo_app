import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_todo_page.dart';
import 'history_page.dart';
import 'settings_page.dart';

class Todo {
  String title;
  DateTime deadline;
  bool isCompleted;
  DateTime? completedDate;

  Todo({
    required this.title,
    required this.deadline,
    this.isCompleted = false,
    this.completedDate,
  });
}

class MainPage extends StatefulWidget {
  final Function(bool) toggleTheme;

  MainPage({required this.toggleTheme});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Todo> todos = [];
  List<Todo> completedTodos = [];
  late String _timeString;
  late String _dateString;
  String _username = '';

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime(DateTime.now());
    _dateString = _formatDate(DateTime.now());
    Timer.periodic(Duration(minutes: 1), (Timer t) => _updateTime());
    _loadUsername();
  }

  void _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Pengguna';
    });
  }

  void _updateTime() {
    setState(() {
      _timeString = _formatTime(DateTime.now());
    });
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('EEEE, dd MMMM yyyy').format(dateTime);
  }

  void _navigateToAddTodoPage() async {
    final newTodo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodoPage()),
    );
    if (newTodo != null) {
      setState(() {
        todos.add(Todo(
          title: newTodo['title'],
          deadline: newTodo['deadline'],
        ));
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODO App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _selectedIndex == 1
          ? _buildTaskView()
          : _selectedIndex == 0
          ? HistoryPage(completedTodos: completedTodos)
          : SettingsPage(
          onSettingsChanged: _loadUsername,
          toggleTheme: widget.toggleTheme),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildTaskView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildGreetingHeader(),
          SizedBox(height: 16),
          _buildDateTimeHeader(),
          SizedBox(height: 16),
          Expanded(
            child: todos.isEmpty
                ? Center(
              child: Text(
                'Tidak ada tugas yang ditambahkan',
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
            )
                : _buildTodoList(),
          ),
          _buildAddTodoButton(),
        ],
      ),
    );
  }

  Widget _buildGreetingHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Halo, $_username',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDateTimeHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.teal[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _timeString,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Warna tetap hitam di mode gelap
            ),
          ),
          SizedBox(height: 8),
          Text(
            _dateString,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54, // Warna tetap sesuai
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            elevation: 4,
            child: ListTile(
              title: Text(
                todo.title,
                style: TextStyle(
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(
                'Deadline: ${DateFormat('dd-MM-yyyy').format(todo.deadline)}',
              ),
              leading: Checkbox(
                value: todo.isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    todo.isCompleted = value ?? false;
                    if (todo.isCompleted) {
                      todo.completedDate = DateTime.now();
                      completedTodos.add(todo);
                      todos.removeAt(index);
                    }
                  });
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    todos.removeAt(index);
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddTodoButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyle(fontSize: 18),
          elevation: 0,
        ),
        onPressed: _navigateToAddTodoPage,
        child: Text('Tambah Tugas'),
      ),
    );
  }
}
