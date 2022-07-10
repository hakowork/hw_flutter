import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/todo.dart';

Future<Todo> updateTodo(int id, String name, BuildContext context) async {
  final response = await http.put(
    Uri.parse('https://laravel.id.hako.work/api/todo/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
    }),
  );

  if (response.statusCode == 200) {
    Navigator.pop(context);
    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const CRUDPage()), (route) => false);
    return Todo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to update todo.');
  }
}

class CRUDUpdatePage extends StatefulWidget {
  const CRUDUpdatePage({super.key, required this.id});

  final int id;

  @override
  State<CRUDUpdatePage> createState() {
    return _CRUDUpdatePageState();
  }
}

class _CRUDUpdatePageState extends State<CRUDUpdatePage> {
  final TextEditingController _controller = TextEditingController();
  Future<Todo>? _futureTodo;

  late Todo _todoData;

  void getData(int id) async {
    http.Response response = await http.get(
        Uri.parse('https://laravel.id.hako.work/api/todo/$id'));
    setState(() {
      _todoData = Todo.fromJson(json.decode(response.body));
      _controller.value = TextEditingValue(text: _todoData.name);
    });
  }

  @override
  void initState() {
    super.initState();
    getData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Todo'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: (_futureTodo == null) ? buildColumn(context) : buildFutureBuilder(context),
      ),
    );
  }

  Column buildColumn(BuildContext context) {
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
              _futureTodo = updateTodo(widget.id, _controller.text, context);
            });
          },
          child: const Text('Update'),
        )
      ],
    );
  }

  FutureBuilder<Todo> buildFutureBuilder(BuildContext context) {
    return FutureBuilder<Todo>(
      future: _futureTodo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //Navigator.pop(context);
          return Text(snapshot.data!.name);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}