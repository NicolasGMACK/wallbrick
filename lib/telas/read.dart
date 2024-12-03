import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaProdutosPage extends StatefulWidget {
  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  List produtos = [];

  Future<void> buscarProdutos() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/meuapp/processa_read.php'),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        setState(() {
          produtos = data['data'];
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

  @override
  void initState() {
    super.initState();
    buscarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.orange,
            child: const Text(
              'WallBrick',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: const [
                Expanded(child: Text('Nome', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                Expanded(child: Text('Quantidade', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                Expanded(child: Text('Medida', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                Expanded(child: Text('Preço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                Text('Ações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 1),
          Expanded(
            child: produtos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum produto cadastrado.',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: produtos.length,
                    itemBuilder: (context, index) {
                      final produto = produtos[index];
                      return Column(
                        children: [
                          Container(
                            color: index % 2 == 0 ? Colors.white : Colors.grey[100],
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    produto['PRO_VAR_NOME'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    produto['PRO_INT_QUANTIDADE'].toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    produto['PRO_VAR_MEDIDA'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'R\$ ${produto['PRO_DEC_PRECO']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.grey, size: 24),
                                      onPressed: () => editarProduto(produto),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.grey, size: 24),
                                      onPressed: () => confirmarExclusao(produto),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 0, thickness: 1),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cadastrar').then((_) => buscarProdutos());
        },
        child: const Icon(Icons.add),
        tooltip: 'Cadastrar Produto',
        backgroundColor: Colors.orange,
      ),
    );
  }

  void editarProduto(Map produto) {
    final nomeController = TextEditingController(text: produto['PRO_VAR_NOME']);
    final quantidadeController = TextEditingController(text: produto['PRO_INT_QUANTIDADE'].toString());
    final precoController = TextEditingController(text: produto['PRO_DEC_PRECO'].toString());
    final medidaController = TextEditingController(text: produto['PRO_VAR_MEDIDA']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Produto'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: quantidadeController,
                  decoration: const InputDecoration(labelText: 'Quantidade'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: medidaController,
                  decoration: const InputDecoration(labelText: 'Medida'),
                ),
                TextField(
                  controller: precoController,
                  decoration: const InputDecoration(labelText: 'Preço'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                atualizarProduto(
                  int.parse(produto['PRO_INT_COD']),
                  nomeController.text,
                  int.parse(quantidadeController.text),
                  medidaController.text,
                  double.tryParse(precoController.text) ?? 0.0,
                );
                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void confirmarExclusao(Map produto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Tem certeza que deseja excluir o produto "${produto['PRO_VAR_NOME']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                excluirProduto(produto);
              },
              child: const Text('Excluir'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  void atualizarProduto(int id, String nome, int quantidade, String medida, double preco) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_update.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id.toString(),
          'nome': nome,
          'quantidade': quantidade.toString(),
          'medida': medida,
          'preco': preco.toString(),
        }),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Produto atualizado com sucesso')),
        );
        buscarProdutos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao atualizar produto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao se conectar ao servidor')),
      );
    }
  }

  void excluirProduto(Map produto) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_delete.php'),
        body: {'id': int.parse(produto['PRO_INT_COD']).toString()},
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Produto excluído com sucesso')),
        );
        buscarProdutos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao excluir produto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao se conectar ao servidor')),
      );
    }
  }
}
