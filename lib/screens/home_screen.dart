import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Todo> _todos = [];
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _addTodo() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _todos.add(Todo(
          title: _controller.text,
          reminder: _combineDateTime(_selectedDate, _selectedTime),
        ));
        _controller.clear();
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  DateTime? _combineDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null || time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  void _toggleTodoStatus(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _removeTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null && pickedTime != _selectedTime) {
        setState(() {
          _selectedTime = pickedTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7B1FA2), Color(0xFFF3E5F5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),

              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: AppBar(
                  title: Center(
                    child: Text(
                      'To-Do App',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black54,
                            offset: Offset(3.0, 3.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent, // Make AppBar transparent
                  foregroundColor: Colors.white, // Keep text color white for contrast
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Add a new task',
                        labelStyle: TextStyle(color: Color(0xFF7B1FA2)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Color(0xFF7B1FA2)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    color: Color(0xFF7B1FA2),
                    onPressed: () => _selectDate(context),
                    tooltip: 'Select Reminder Date and Time',
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FloatingActionButton(
                      backgroundColor: Color(0xFF7B1FA2),
                      child: Icon(Icons.add),
                      onPressed: _addTodo,
                      tooltip: 'Add Task',
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _todos.isEmpty
                  ? Center(
                child: Text(
                  'No tasks, add one!',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
              )
                  : ListView(
                children: [
                  if (_todos.any((todo) => !todo.isDone)) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Pending Tasks',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ..._todos.where((todo) => !todo.isDone).map((todo) {
                      int index = _todos.indexOf(todo);
                      return _buildTodoCard(todo, index);
                    }).toList(),
                  ],
                  if (_todos.any((todo) => todo.isDone)) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Completed Tasks',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ..._todos.where((todo) => todo.isDone).map((todo) {
                      int index = _todos.indexOf(todo);
                      return _buildTodoCard(todo, index);
                    }).toList(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoCard(Todo todo, int index) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: Colors.purple,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
                color: todo.isDone ? Colors.grey : Colors.black,
              ),
            ),
            if (todo.reminder != null)
              Text(
                'Reminder: ${DateFormat('yyyy-MM-dd – kk:mm').format(todo.reminder!)}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: todo.isDone,
              activeColor: Color(0xFF7B1FA2),
              onChanged: (value) => _toggleTodoStatus(index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeTodo(index),
            ),
          ],
        ),
      ),
    );
  }
}
