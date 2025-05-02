import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

import 'package:http_app/model/tarefa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String baseURL = 'https://todos-production-34e1.up.railway.app';

  late Future<List<Tarefa>> listaTarefas = getTarefas();

  Future<List<Tarefa>> getTarefas() async {
    String url = '$baseURL/tarefas';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> listaTarefas = json.jsonDecode(response.body);
      return listaTarefas.map((tarefa) => Tarefa.fromJson(tarefa)).toList();
    } else {
      throw Exception('Erro ao recuperar as tarefas');
    }
  }

  void setTarefas() {
    listaTarefas = getTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: listaTarefas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if(snapshot.hasData){
            final tarefas = snapshot.data ?? [];
            return ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                return ListTile(
                  title: Text(tarefa.titulo),
                  leading: Icon(
                    tarefa.concluida ? Icons.check_circle : Icons.circle_outlined,
                    color: tarefa.concluida ? Colors.green : Colors.grey,
                  ),
                );
              });
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: setTarefas,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
