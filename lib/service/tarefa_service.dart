import 'dart:convert' as json;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_app/model/tarefa.dart';

class TarefaService {
  String baseURL = 'https://todos-production-34e1.up.railway.app';

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

  Future<void> deleteTarefa(String id) async {
    String url = '$baseURL/tarefas/$id';

    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-type': 'application/json'},
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Erro ao deletar mensagem');
    }
  }

  Future<void> putTarefa(String id, String titulo, bool concluida) async {
    String url = '$baseURL/tarefas/$id';

    var corpo = json.jsonEncode({'titulo': titulo, 'concluida': concluida});

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-type': 'application/json'},
      body: corpo,
    );
  }
}
