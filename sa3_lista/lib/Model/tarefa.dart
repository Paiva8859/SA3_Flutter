class Tarefa {
  int? id;
  String nome;
  bool concluido;
  String categoria;

  Tarefa({
    this.id,
    required this.nome,
    required this.concluido,
    required this.categoria, required String username,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'concluido': concluido ? 1 : 0,
      'categoria': categoria,
    };
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'],
      nome: map['nome'],
      concluido: map['concluido'] == 1,
      categoria: map['categoria'], 
      username: map['username'],
    );
  }
}
