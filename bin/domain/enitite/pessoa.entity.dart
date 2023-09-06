import 'dart:convert';

class Pessoa {
  String? id;
  String apelido;
  String nome;
  String nascimento;
  List<dynamic> stack;
  Pessoa({
    required this.apelido,
    required this.nome,
    required this.nascimento,
    required this.stack,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apelido': apelido,
      'id': id ?? '',
      'nome': nome,
      'nascimento': nascimento,
      'stack': stack,
    };
  }

  String toJson() => json.encode(toMap());

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    try {
      return Pessoa(
          id: map['id'] ?? '',
          apelido: map['apelido'] as String,
          nome: map['nome'] as String,
          nascimento: map['nascimento'] as String,
          stack: map['stack'] ?? []);
    } catch (_) {
      throw Exception('Parse failed');
    }
  }

  factory Pessoa.fromJson(String source) =>
      Pessoa.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      '${nome.toString()} ${apelido.toString()} ${nascimento.toString()} ${stack.toString()} ';
}

final emptyPessoa = Pessoa(
    apelido: 'apelido', nome: 'nome', nascimento: 'nascimento', stack: ['']);
