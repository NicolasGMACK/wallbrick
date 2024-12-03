import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastrarProdutoPage extends StatefulWidget {
  @override
  _CadastrarProdutoPageState createState() => _CadastrarProdutoPageState();
}

class _CadastrarProdutoPageState extends State<CadastrarProdutoPage> {
  final nomeController = TextEditingController();
  final quantidadeController = TextEditingController();
  final medidaController = TextEditingController();
  final precoController = TextEditingController();

  Future<void> cadastrarProduto() async {
    if (nomeController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        medidaController.text.isEmpty ||
        precoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_create.php'),
        headers: {'Content-Type': 'application/json'}, // Cabeçalho JSON
        body: json.encode({
          'nome': nomeController.text,
          'quantidade': quantidadeController.text,
          'medida': medidaController.text,
          'preco': precoController.text,
        }),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Navigator.pop(context, true); // Retorna para a tela anterior com sucesso
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao cadastrar produto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao se conectar ao servidor.')),
      );
      print('Erro de conexão: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Voltar para a tela anterior
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Produto'),
            ),
            TextField(
              controller: quantidadeController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: medidaController,
              decoration: const InputDecoration(labelText: 'Unidade de Medida'),
            ),
            TextField(
              controller: precoController,
              decoration: const InputDecoration(labelText: 'Preço'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cadastrarProduto,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
