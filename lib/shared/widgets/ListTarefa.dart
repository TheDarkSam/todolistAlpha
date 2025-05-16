import 'package:flutter/material.dart';
import 'package:http_app/model/tarefa.dart';
import 'package:http_app/service/tarefa_service.dart';

class ListTarefa extends StatefulWidget {
  final Tarefa tarefa;
  const ListTarefa({super.key, required this.tarefa});

  @override
  State<ListTarefa> createState() => _ListTarefaState();
}

class _ListTarefaState extends State<ListTarefa> {
  final _tarefaService = TarefaService();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.tarefa.titulo),
      leading: InkWell(
        onTap: () {
          bool concluida = !widget.tarefa.concluida;
          _tarefaService.putTarefa(widget.tarefa.id.toString(), widget.tarefa.titulo, concluida);
        },
        child: Icon(
          widget.tarefa.concluida ? Icons.check_circle : Icons.circle_outlined,
          color: widget.tarefa.concluida ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
