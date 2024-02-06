import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:todo_application/models/todos.dart';
import 'package:todo_application/data/todolist_api.dart';

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
            return ListTile(
              leading: Text(_todos[index].id),
              title: Text(_todos[index].title),
              
              subtitle: Text(_todos[index].description),

              trailing: Checkbox(
                value: _todos[index].completed,
                onChanged: (bool? value) {
                  setState(() {
                    _todos[index].completed = value!;
                  });
                },
            )
            );
          },
        )
      )
    );
  }

  List<Todo> _todos = [];
}

