import 'dart:async';
import 'package:http/http.dart' as http;

class TodoListApi {
  static Future getTodos() {
    return http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));
  }
}
