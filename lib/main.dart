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

  var tarefaController = TextEditingController();

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

  Future<void> postTarefa(String titulo) async {
    String url = '$baseURL/tarefas/';

    var corpo = json.jsonEncode({'titulo': titulo, 'concluida': false});

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-type': 'application/json'},
      body: corpo,
    );

    if (response.statusCode == 201) {
    } else {
      throw Exception('Erro ao criar tarefa');
    }
  }

  void criarTarefa() async {
    await postTarefa('tarefa criada na alpha, como true');
    listaTarefas = getTarefas();
    setState(() {});
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

          if (snapshot.hasData) {
            final tarefas = snapshot.data ?? [];
            return ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                return ListTile(
                  title: Text(tarefa.titulo),
                  leading: Icon(
                    tarefa.concluida
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: tarefa.concluida ? Colors.green : Colors.grey,
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tarefaController.text = '';
          showDialog(
            context: context,
            builder: (BuildContext bc) {
              return AlertDialog(
                title: Text('Digite o nome da tarefa'),
                content: TextField(controller: tarefaController),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await postTarefa(tarefaController.text);
                      listaTarefas = getTarefas();
                      setState(() {});
                    },
                    child: Text('Confirmar'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
