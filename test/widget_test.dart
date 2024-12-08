import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('Testes de integração com o PHP', () {
    const endpoint = 'http://localhost/meuapp/test/crud_test.php';

    // Teste para criar fornecedor
    test('Teste de criação de fornecedor', () async {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "acao": "criar_fornecedor",
          "cnpj": "12345678000199",
          "nome": "Fornecedor Teste",
          "telefone": "(11) 98765-4321",
        }),
      );

      print('Resposta criação fornecedor: ${response.body}');

      // Validar resposta
      expect(response.statusCode, 200);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['status'], equals('sucesso'));
      expect(responseBody['message'],
          contains('Fornecedor cadastrado com sucesso.'));
    });

    // Teste para criar produto
    test('Teste de criação de produto', () async {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "acao": "criar_produto",
          "id": 999,
          "nome": "Produto Teste",
          "quantidade": 10,
          "medida": "kg",
          "preco": 25.50,
          "cnpj_fornecedor": "12345678000199",
        }),
      );

      print('Resposta criação produto: ${response.body}');

      expect(response.statusCode, 200);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['status'], equals('sucesso'));
    });

    // Teste para atualizar produto
    test('Teste de atualização de produto', () async {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "acao": "atualizar_produto",
          "id": 999,
          "nome": "Produto Atualizado",
          "quantidade": 20,
          "medida": "unidade",
          "preco": 30.50,
        }),
      );

      print('Resposta atualização produto: ${response.body}');

      expect(response.statusCode, 200);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['status'], equals('sucesso'));
    });

    // Teste para deletar produto
    test('Teste de exclusão de produto', () async {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "acao": "deletar_produto",
          "codigo": 999,
        }),
      );

      print('Resposta exclusão produto: ${response.body}');

      expect(response.statusCode, 200);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['status'], equals('sucesso'));
    });
    test('Teste de exclusão de fornecedor', () async {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "acao": "deletar_fornecedor",
          "cnpj": "12345678000199",
        }),
      );

      print('Resposta exclusão fornecedor: ${response.body}');

      expect(response.statusCode, 200);

      final responseBody = jsonDecode(response.body);
      expect(responseBody['status'], equals('sucesso'));
    });
  });
}
