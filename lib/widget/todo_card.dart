import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final int index;
  final Function toggleStatus;
  final Function removeTodo;

  const TodoCard({
    required this.todo,
    required this.index,
    required this.toggleStatus,
    required this.removeTodo,
  });

  @override
  Widget build(BuildContext context) {
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
              onChanged: (value) => toggleStatus(index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => removeTodo(index),
            ),
          ],
        ),
      ),
    );
  }
}
