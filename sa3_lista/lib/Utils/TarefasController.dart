import 'package:flutter/material.dart';
import 'package:sa3_lista/Model/tarefa.dart';
import 'package:sa3_lista/Utils/database_helper_tarefas.dart';

class TarefasController extends ChangeNotifier {
  final DatabaseHelperTarefas _databaseHelper = DatabaseHelperTarefas();
  List<Tarefa> _itens = [];

  List<Tarefa> get itens => _itens;

  Future<void> sortItems(String sortingOption) async {
    switch (sortingOption) {
      case 'ordem alfabética A-Z':
        _itens.sort((a, b) => a.nome.compareTo(b.nome));
        break;
      case 'ordem alfabética Z-A':
        _itens.sort((a, b) => b.nome.compareTo(a.nome));
        break;
      case 'Agrupar por Categoria':
        _itens.sort((a, b) => a.categoria.compareTo(b.categoria));
        break;
      case 'Concluídos':
        _itens.sort((a, b) {
          if (a.concluido && !b.concluido) {
            return -1;
          } else if (!a.concluido && b.concluido) {
            return 1;
          } else {
            return 0;
          }
        });
        break;
      case 'Não concluídos':
        _itens.sort((a, b) {
          if (!a.concluido && b.concluido) {
            return -1;
          } else if (a.concluido && !b.concluido) {
            return 1;
          } else {
            return 0;
          }
        });
        break;
      default:
        break;
    }
    notifyListeners();
  }

  Future<void> loadItens(String username) async {
    _itens = await _databaseHelper.getTarefasByUsername(username);
    notifyListeners();
  }

  Future<void> adicionarItem(String nome, String categoria, String username) async {
    final newItem = Tarefa(nome: nome, concluido: false, categoria: categoria, username: username);
    await _databaseHelper.insertTarefa(newItem);
    await loadItens(username); // Recarregar itens após a inserção
  }

  Future<void> marcarItemComoConcluido(int index, bool value) async {
    _itens[index].concluido = value;
    await _databaseHelper.updateTarefa(_itens[index]);
    notifyListeners();
  }

  Future<void> removerItem(int index, String username) async {
    await _databaseHelper.deleteTarefa(_itens[index].id!);
    await loadItens(username); 
}


  Future<void> editarItem(int index, String novoNome, String novaCategoria) async {
    _itens[index].nome = novoNome;
    _itens[index].categoria = novaCategoria;
    await _databaseHelper.updateTarefa(_itens[index]);
    notifyListeners();
  }
}
