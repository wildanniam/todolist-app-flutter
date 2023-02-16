import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/new_todo.dart';
import '../widgets/todo_list.dart';

class AllTodoScreen extends StatelessWidget {
  const AllTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ALL TODO'),
        centerTitle: true,
      ),
      body: Container(
          child: Column(
        children: [
          Expanded(child: TodoList()),
          NewTodo(),
        ],
      )),
    );
  }
}
