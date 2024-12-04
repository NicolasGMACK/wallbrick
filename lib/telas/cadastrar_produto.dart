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

  List fornecedores = [];
  String? fornecedorSelecionado;

  @override
  void initState() {
    super.initState();
    carregarFornecedores();
  }

  Future<void> carregarFornecedores() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost/meuapp/processa_read_fornecedor.php'),
    );

    final data = json.decode(response.body);

    if (data['status'] == 'sucesso' && data['data'] is List) {
      setState(() {
        fornecedores = data['data'];
      });
    } else {
      setState(() {
        fornecedores = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Nenhum fornecedor encontrado')),
      );
    }
  } catch (e) {
    setState(() {
      fornecedores = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erro ao carregar fornecedores do servidor')),
    );
  }
}


  Future<void> cadastrarProduto() async {
    if (nomeController.text.isEmpty ||
        quantidadeController.text.isEmpty ||
        medidaController.text.isEmpty ||
        precoController.text.isEmpty ||
        fornecedorSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_create.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nomeController.text,
          'quantidade': quantidadeController.text,
          'medida': medidaController.text,
          'preco': precoController.text,
          'cnpj_fornecedor': fornecedorSelecionado, // Usar CNPJ como identificador
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
          SnackBar(content: Text(data['message'] ?? 'Erro ao cadastrar produto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao se conectar ao servidor.')),
      );
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
                    color: Color.fromARGB(255, 255, 128, 9),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Text(
                    'Cadastrar Produto',
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
                  controller: nomeController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Nome do Produto',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantidadeController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: medidaController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Unidade de Medida',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: precoController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Preço',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                // Dropdown de fornecedores
                DropdownButtonFormField<String>(
  value: fornecedorSelecionado,
  decoration: const InputDecoration(
    labelText: 'Fornecedor',
    labelStyle: TextStyle(color: Colors.black),
  ),
  items: fornecedores.isEmpty
      ? [DropdownMenuItem<String>(value: null, child: Text('Nenhum fornecedor disponível'))]
      : fornecedores.map<DropdownMenuItem<String>>((fornecedor) {
          return DropdownMenuItem<String>(
            value: fornecedor['FBR_VAR_CNPJ']?.toString(),
            child: Text(fornecedor['FBR_VAR_NOME'] ?? 'Sem nome'),
          );
        }).toList(),
  onChanged: (value) {
    setState(() {
      fornecedorSelecionado = value;
    });
  },
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
                      onPressed: cadastrarProduto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 128, 9),
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
