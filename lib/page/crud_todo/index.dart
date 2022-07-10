import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/todo.dart';
import '../../component/expandable_fab.dart';
import 'add.dart';
import 'update.dart';

Future<bool> deleteTodo(int id) async {
  final response = await http.delete(
    Uri.parse('https://laravel.id.hako.work/api/todo/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return true;
  }
  
  return false;
}

class CRUDPage extends StatefulWidget {
  const CRUDPage({super.key});
  
  @override
  State<CRUDPage> createState() {
    return _CRUDPageState();
  }
}

class _CRUDPageState extends State<CRUDPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Todo> _todosList = [];

  void getData() async {
    http.Response response = await http.get(
        Uri.parse('https://laravel.id.hako.work/api/todo'));
    setState(() {
      _todosList = Todos.fromJson(json.decode(response.body)).todos;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CRUD"),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          return Future<void>.delayed(const Duration(seconds: 1)).then((value) => getData());
          
        },
          child: ListView.builder(
        itemCount: _todosList.length,
        itemBuilder: (context, index) => ListTile(
              title: Text(
                _todosList[index].name
              ),
              trailing: IconButton(onPressed: () {
                deleteTodo(_todosList[index].id);
                _refreshIndicatorKey.currentState?.show();
              }, icon: const Icon(Icons.delete)),
              onTap: () {          // NEW from here ...
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CRUDUpdatePage(id: _todosList[index].id)),
                );            // to here.
              },
          ),
        )
      ),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () => { },
            icon: const Icon(Icons.delete),
          ),
          ActionButton(
            onPressed: () => _refreshIndicatorKey.currentState?.show(),
            icon: const Icon(Icons.refresh),
          ),
          ActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CRUDAddPage()),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}