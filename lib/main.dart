// ignore_for_file: unused_label

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_application/data/todolist_api.dart';
import 'package:todo_application/models/todos.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoList(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class TodoListScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<String> _todos = [];

  void _addTodo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newTodo = "";
        return AlertDialog(
          title: const Text("Add a new To-Do"),
          content: TextField(
            onChanged: (value) {
              newTodo = value;
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (newTodo.isNotEmpty) {
                    _todos.add(newTodo);
                  }
                  Navigator.pop(context);
                });
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
        backgroundColor: Colors.green[400],
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                _todos[index],
                style: const TextStyle(fontSize: 18),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _todos.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoList extends StatefulWidget {
  TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  void getTodos() async {
    TodoListApi.getTodos().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        _todos = list.map((model) => Todo.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("To-Do List"),
        ),
        body: Container(
          child: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(_todos[index].id.toString()),
              background: Container(color: Colors.red),
              child: ListTile(
                leading: Text(_todos[index].id.toString()),
                title: Text(_todos[index].title),
                subtitle: Text(_todos[index].description),
                trailing: Checkbox(
                  value: _todos[index].completed,
                  onChanged: (bool? value) {
                    setState(() {
                      _todos[index].completed = value!;
                    });
                  },
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  _todos.removeAt(index);
                });
              },
            );
          },
        )));
  }
  List<Todo> _todos = [];
}

