import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastrarFornecedorPage extends StatefulWidget {
  @override
  _CadastrarFornecedorPageState createState() =>
      _CadastrarFornecedorPageState();
}

class _CadastrarFornecedorPageState extends State<CadastrarFornecedorPage> {
  final cnpjController = TextEditingController();
  final nomeController = TextEditingController();
  final telefoneController = TextEditingController();

  List fornecedores = [];

  // Buscar fornecedores
  Future<void> buscarFornecedores() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/meuapp/processa_read_fornecedor.php'),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        setState(() {
          fornecedores = data['data'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao buscar dados')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao se conectar ao servidor')),
      );
    }
  }

  // Cadastrar fornecedor
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
        cnpjController.clear();
        nomeController.clear();
        telefoneController.clear();
        buscarFornecedores(); // Atualizar lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao cadastrar fornecedor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao se conectar ao servidor.')),
      );
    }
  }

  // Excluir fornecedor
  Future<void> excluirFornecedor(Map fornecedor) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_delete_fornecedor.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'cnpj': fornecedor['FBR_VAR_CNPJ']}),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Fornecedor excluído com sucesso')),
        );
        buscarFornecedores(); // Atualizar lista após exclusão
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao excluir fornecedor')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao se conectar ao servidor')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    buscarFornecedores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar e Gerenciar Fornecedores'),
        backgroundColor: const Color.fromARGB(255, 0, 150, 136),
      ),
      backgroundColor: Colors.grey[200],
      body: Row(
        children: [
          // Formulário de cadastro (lado esquerdo)
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
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
                      TextField(
                        controller: cnpjController,
                        decoration: const InputDecoration(labelText: 'CNPJ'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: nomeController,
                        decoration: const InputDecoration(labelText: 'Nome'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: telefoneController,
                        decoration: const InputDecoration(labelText: 'Telefone'),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: cadastrarFornecedor,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 0, 150, 136),
                        ),
                        child: const Text('Cadastrar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Lista de fornecedores (lado direito)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: const Color.fromARGB(255, 0, 150, 136),
                      child: const Text(
                        'Fornecedores Cadastrados',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: fornecedores.isEmpty
                          ? const Center(child: Text('Nenhum fornecedor cadastrado.'))
                          : ListView.builder(
                              itemCount: fornecedores.length,
                              itemBuilder: (context, index) {
                                final fornecedor = fornecedores[index];
                                return ListTile(
                                  title: Text(fornecedor['FBR_VAR_NOME']),
                                  subtitle: Row(
                                        children: [
                                          Text('CNPJ: ${fornecedor['FBR_VAR_CNPJ']}'),
                                          const SizedBox(width: 16), // add some space
                                          Text('Telefone: ${fornecedor['FBR_VAR_FONE']}'),
                                        ],
                                      ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => excluirFornecedor(fornecedor),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
