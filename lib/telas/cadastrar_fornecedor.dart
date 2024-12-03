import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastrarFornecedorPage extends StatefulWidget {
  @override
  _CadastrarFornecedorPageState createState() => _CadastrarFornecedorPageState();
}

class _CadastrarFornecedorPageState extends State<CadastrarFornecedorPage> {
  final cnpjController = TextEditingController();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();

  Future<void> cadastrarFornecedor() async {
    if (cnpjController.text.isEmpty ||
        nomeController.text.isEmpty ||
        telefoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_create_fornecedor.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'cnpj': cnpjController.text,
          'nome': nomeController.text,
          'telefone': telefoneController.text,
        }),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao cadastrar fornecedor')),
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
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Título com faixa laranja
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 0, 150, 136),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Text(
                    'Cadastrar Fornecedor',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Campos de entrada
                TextField(
                  controller: cnpjController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'CNPJ',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nomeController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Nome do Fornecedor',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: telefoneController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Telefone',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),
                // Botões de ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: cadastrarFornecedor,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 150, 136),
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
