import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todolist/models/data_user.dart';
import 'package:todolist/models/todo.dart';

class DatabaseService {
  String _uid = '';
  DatabaseService() {
    if (FirebaseAuth.instance.currentUser != null) {
      _uid = FirebaseAuth.instance.currentUser!.uid;
    }
  }

  final _todosReference = FirebaseFirestore.instance.collection('todos');
  final _dataUserReference = FirebaseFirestore.instance.collection('users');

  List<Todo> _todoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Todo(
          id: doc.id,
          title: data['title'] ?? '',
          note: data['note'] ?? '',
          completed: data['completed'] ?? false,
          dueDate: data['due_date'] == null
              ? null
              : DateTime.parse(data['due_date']),
          latitude: data['location'] == null ? 0.0 : data['location'].latitude,
          longitude:
              data['location'] == null ? 0.0 : data['location'].longitude);
    }).toList();
  }

  Stream<List<Todo>> get todos {
    return _todosReference
        .where('uid', isEqualTo: _uid)
        .orderBy('completed')
        .orderBy('due_date')
        .snapshots()
        .map(_todoListFromSnapshot);
  }

  DataUser _dataUserFromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return DataUser(
        username: data['username'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        userImageUrl: data['userImageUrl'] ?? '');
  }

  Stream<DataUser> get dataUser {
    return _dataUserReference
        .doc(_uid)
        .snapshots()
        .map((_dataUserFromSnapshot));
  }

  Future addNewTodo(String title) {
    return _todosReference.add(
        {'title': title, 'due_date': null, 'completed': false, 'uid': _uid});
  }

  Future updateTodo(Todo todo) {
    return _todosReference.doc(todo.id).update({
      'title': todo.title,
      'note': todo.note,
      'due_date': todo.dueDate == null ? null : todo.dueDate!.toIso8601String(),
      'completed': todo.completed,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future toggleComplete(Todo todo) {
    return _todosReference.doc(todo.id).update({
      'completed': !todo.completed,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future deleteTodo(String docId) {
    return _todosReference.doc(docId).delete();
  }

  Future updateUsername(String username) {
    return _dataUserReference.doc(_uid).update({
      'username': username,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future uploadImageUrl(File file) async {
    final ref =
        FirebaseStorage.instance.ref().child('user_data').child(_uid + '.jpg');
    await ref.putFile(file);
    final url = await ref.getDownloadURL();
    await _dataUserReference.doc(_uid).update({
      'userImgaeUrl': url,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
