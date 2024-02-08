import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:todo_application/data/todolist_api.dart';
import 'package:todo_application/models/todos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late List<Todo> _todos;

  @override
  void initState() {
    super.initState();
    _todos = [];
    getTodos();
  }

  Future<void> getTodos() async {
    try {
      final response = await TodoListApi.getTodos();
      if (response.statusCode == 200) {
        setState(() {
          Iterable list = json.decode(response.body);
          _todos = list.map((model) => Todo.fromJson(model)).toList();
        });
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  Future<void> addTodo(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/todos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'title': title,
          'description': description,
        }),
      );
      if (response.statusCode == 201) {
        // If successful, add the new todo to the list
        final newTodo = Todo.fromJson(jsonDecode(response.body));
        setState(() {
          _todos.add(newTodo);
        });
      } else {
        throw Exception('Failed to add todo');
      }
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
      ),
      body: ListView.builder(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String newTitle = '';
              String newDescription = '';
              return AlertDialog(
                title: const Text("Add a new To-Do"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      onChanged: (value) {
                        newTitle = value;
                      },
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      onChanged: (value) {
                        newDescription = value;
                      },
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      if (newTitle.isNotEmpty && newDescription.isNotEmpty) {
                        addTodo(newTitle, newDescription);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
