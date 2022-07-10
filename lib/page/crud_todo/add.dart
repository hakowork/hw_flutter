
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/todo.dart';

Future<Todo> createTodo(String name, BuildContext context) async {
  final response = await http.post(
    Uri.parse('https://laravel.id.hako.work/api/todo'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
    }),
  );

  if (response.statusCode == 201) {
    Navigator.pop(context);
    return Todo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create todo.');
  }
}

class CRUDAddPage extends StatefulWidget {
  const CRUDAddPage({super.key});

  @override
  State<CRUDAddPage> createState() {
    return _CRUDAddPageState();
  }
}

class _CRUDAddPageState extends State<CRUDAddPage> {
  final TextEditingController _controller = TextEditingController();
  Future<Todo>? _futureTodo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: (_futureTodo == null) ? buildColumn() : buildFutureBuilder(),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter Name'),
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _futureTodo = createTodo(_controller.text, context);
              });
            },
            child: const Text('Add'),
        ),
      ],
    );
  }

  FutureBuilder<Todo> buildFutureBuilder() {
    return FutureBuilder<Todo>(
      future: _futureTodo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.name);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}