import 'package:flutter/material.dart';
import 'package:todolist/functions.dart';
import 'package:todolist/services/database_service.dart';
import '../models/todo.dart';

class TodoDetailScreeen extends StatefulWidget {
  const TodoDetailScreeen({super.key, required this.todo});
  final Todo todo;

  @override
  State<TodoDetailScreeen> createState() => _TodoDetailScreeenState();
}

class _TodoDetailScreeenState extends State<TodoDetailScreeen> {
  Todo _todo = Todo(id: '', title: '');
  final _todoTitleController = TextEditingController();
  final _today = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    _todo = widget.todo;
    _todoTitleController.text = _todo.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Detail'),
        actions: [
          IconButton(
            onPressed: () async {
              bool? isDelete = await showDialog(
                  context: context,
                  builder: (builder) {
                    return AlertDialog(
                      title: Text('Hapus Todo'),
                      content: Text('Apakah anda yakin untuk menghapus todo?'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Tidak')),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Iya')),
                      ],
                    );
                  });
              if (isDelete != null && isDelete) {
                DatabaseService().deleteTodo(_todo.id);
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.delete),
            color: Colors.red,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Apa yang mau kamu lakukan..?'),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _todoTitleController,
                  decoration: InputDecoration(hintText: 'Saya mau...'),
                  onChanged: (value) {
                    _todo = _todo.copyWith(title: value);
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Text('Tanggal waktu penyelesaian'),
                SizedBox(
                  height: 10,
                ),
                if (_todo.dueDate != null)
                  Card(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Row(children: [
                        Expanded(child: Text(formatDateTime(_todo.dueDate))),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                _todo = _todo.copyWith(dueDate: DateTime(0));
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ))
                      ]),
                    ),
                  ),
                if (_todo.dueDate == null)
                  Row(
                    children: [
                      dueDateButton('Hari ini', value: _today),
                      dueDateButton('Besok',
                          value: _today.add(Duration(days: 1))),
                    ],
                  ),
                if (_todo.dueDate == null)
                  Row(
                    children: [
                      dueDateButton('Minggu depan',
                          value: _today.add(
                              Duration(days: (_today.weekday - 7).abs() + 1))),
                      dueDateButton('Custom', onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _today,
                          firstDate: _today,
                          lastDate: DateTime(_today.year + 100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _todo = _todo.copyWith(dueDate: pickedDate);
                          });
                        }
                      }),
                    ],
                  ),
                SizedBox(
                  height: 25,
                ),
                Text('Catatan'),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    String? note = await showDialog(
                        context: context,
                        builder: (builder) {
                          String tempNote = _todo.note;
                          return Dialog(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Catatan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    TextFormField(
                                      initialValue: tempNote,
                                      maxLines: 6,
                                      onChanged: (value) {
                                        tempNote = value;
                                      },
                                    ),
                                    ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(tempNote),
                                        child: Text('Selesai'))
                                  ]),
                            ),
                          );
                        });
                    if (note != null) {
                      setState(() {
                        _todo = _todo.copyWith(note: note);
                      });
                    }
                  },
                  child: _todo.note.isEmpty
                      ? Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            border: Border.all(width: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text('Tap untuk menambahkan catatan')),
                        )
                      : Container(
                          width: double.infinity,
                          child: Text(
                            _todo.note,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () {
                      DatabaseService().updateTodo(_todo);
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.save), Text('Simpan')],
                    )),
                ElevatedButton(
                  onPressed: () {
                    DatabaseService().toggleComplete(_todo);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.check), Text('Selesai')],
                  ),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                )
              ],
            )),
      ),
    );
  }

  Widget dueDateButton(String text,
      {DateTime? value, VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed ??
            () {
              setState(() {
                _todo = _todo.copyWith(dueDate: value);
              });
            },
        icon: Icon(Icons.alarm_add),
        label: Text(text),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
      ),
    );
  }
}
