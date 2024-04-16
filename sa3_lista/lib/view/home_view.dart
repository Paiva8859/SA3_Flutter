import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sa3_lista/Model/tarefa.dart';
import 'package:sa3_lista/Utils/TarefasController.dart';

class HomeView extends StatefulWidget {
  final String username; // Alteração: Adicionando parâmetro username
  const HomeView({Key? key, required this.username}) : super(key: key); // Alteração: Adicionando key

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeEditController = TextEditingController();
  final _categoriaEditController = TextEditingController();
  late final TarefasController _tarefasController; // Alteração: Tornando o tipo público

  @override
  void initState() {
    super.initState();
    _tarefasController = Provider.of<TarefasController>(context, listen: false);
    _tarefasController.loadItens(widget.username); // Alteração: Passando o username
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeEditController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoriaEditController,
                  decoration: InputDecoration(labelText: 'Categoria'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _tarefasController.adicionarItem(
                        _nomeEditController.text,
                        _categoriaEditController.text,
                        widget.username, // Alteração: Passando o username
                      );
                      _nomeEditController.clear();
                      _categoriaEditController.clear();
                    }
                  },
                  child: Text('Adicionar Tarefa'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TarefasController>(
              builder: (context, controller, _) {
                return ListView.builder(
                  itemCount: controller.itens.length,
                  itemBuilder: (context, index) {
                    final item = controller.itens[index];
                    return ListTile(
                      title: Text(item.nome),
                      subtitle: Text(item.categoria),
                      trailing: Checkbox(
                        value: item.concluido,
                        onChanged: (value) {
                          controller.marcarItemComoConcluido(index, value ?? false);
                        },
                      ),
                      onLongPress: () {
                        controller.removerItem(index);
                      },
                      onTap: () {
                        _showEditDialog(context, controller, item);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, TarefasController controller, Tarefa item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nomeEditController,
                  decoration: InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um nome';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoriaEditController,
                  decoration: InputDecoration(labelText: 'Categoria'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  controller.editarItem(
                    controller.itens.indexOf(item),
                    _nomeEditController.text,
                    _categoriaEditController.text,
                  );
                  _nomeEditController.clear();
                  _categoriaEditController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
