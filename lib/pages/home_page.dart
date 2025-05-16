import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http_app/model/tarefa.dart';
import 'package:http_app/service/tarefa_service.dart';
import 'package:http_app/shared/widgets/ListTarefa.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var tarefaController = TextEditingController();
  final _tarefaService = TarefaService();
  late Future<List<Tarefa>> listaTarefas;

  @override
  void initState() {
    super.initState();
    listaTarefas = _tarefaService.getTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Tarefas a fazer'),
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
                final parentContext = context;
                String key = tarefa.id.toString();
                return Slidable(
                  startActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,
                        onPressed: (context) async {
                          await _tarefaService.deleteTarefa(key);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Deletar',
                      ),
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,
                        onPressed: (context) {
                          tarefaController.text = '';
                          showDialog(
                            context: context,
                            builder: (BuildContext bc) {
                              return AlertDialog(
                                title: Text('Digite o novo nome da tarefa'),
                                content: TextField(
                                  controller: tarefaController,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(parentContext);
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(parentContext);
                                      _tarefaService.putTarefa(
                                        key,
                                        tarefaController.text,
                                        tarefa.concluida,
                                      );
                                      listaTarefas =
                                          _tarefaService.getTarefas();
                                      setState(() {});
                                    },
                                    child: Text('Confirmar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Editar',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        // An action can be bigger than the others.
                        flex: 2,
                        onPressed: (context) {},
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.star,
                        label: 'Favoritar',
                      ),
                    ],
                  ),
                  child: ListTarefa(tarefa: tarefa),
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
                      await _tarefaService.postTarefa(tarefaController.text);
                      listaTarefas = _tarefaService.getTarefas();
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
