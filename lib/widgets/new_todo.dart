import 'package:flutter/material.dart';

import '../services/database_service.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({super.key});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  String _todoTitle = '';
  final _todoTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.grey[100],
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _todoTitleController,
            decoration: InputDecoration(
                hintText: 'Saya mau...',
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5),
                    borderRadius: BorderRadius.circular(25)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 0)),
            onChanged: (value) {
              setState(() {
                _todoTitle = value;
              });
            },
          ),
        ),
        ElevatedButton(
          onPressed: _todoTitle.isEmpty
              ? null
              : () {
                  DatabaseService().addNewTodo(_todoTitle);
                  _todoTitleController.clear();
                },
          child: Icon(Icons.add),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
          ),
        )
      ]),
    );
  }
}
