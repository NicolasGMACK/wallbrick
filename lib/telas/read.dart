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
            color: const Color.fromARGB(255, 255, 128, 9),
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
                Expanded(child: Text('Fornecedor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
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
                                Expanded(
                                  child: Text(
                                    produto['FORNECEDOR_NOME'] ?? 'Desconhecido',
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'cadastrarProduto',
            onPressed: () {
              Navigator.pushNamed(context, '/cadastrar').then((_) => buscarProdutos());
            },
            child: const Icon(Icons.add),
            tooltip: 'Cadastrar Produto',
            backgroundColor: const Color.fromARGB(255, 255, 128, 9),
          ),
          const SizedBox(height: 16), // Espaço entre os botões
          FloatingActionButton(
            heroTag: 'cadastrarFornecedor',
            onPressed: () {
              Navigator.pushNamed(context, '/cadastrarFornecedor');
            },
            child: const Icon(Icons.business),
            tooltip: 'Cadastrar Fornecedor',
            backgroundColor: const Color.fromARGB(255, 0, 150, 136),
          ),
        ],
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
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 100), // Ajuste aqui
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5, // Define 50% da largura da tela
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Faixa superior laranja
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 128, 9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Editar Produto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Conteúdo do popup
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: nomeController,
                        decoration: InputDecoration(
                          labelText: 'Nome',
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: quantidadeController,
                        decoration: InputDecoration(
                          labelText: 'Quantidade',
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: medidaController,
                        decoration: InputDecoration(
                          labelText: 'Medida',
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: precoController,
                        decoration: InputDecoration(
                          labelText: 'Preço',
                          labelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                              backgroundColor: Colors.white,
                            ),
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void confirmarExclusao(Map produto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Produto'),
          content: const Text('Tem certeza que deseja excluir este produto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                excluirProduto(produto['PRO_INT_COD']);
                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void excluirProduto(int codProduto) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_delete.php'),
        body: {'PRO_INT_COD': codProduto.toString()},
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        buscarProdutos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao excluir produto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir produto')),
      );
    }
  }

  void atualizarProduto(int codProduto, String nome, int quantidade, String medida, double preco) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_update.php'),
        body: {
          'PRO_INT_COD': codProduto.toString(),
          'PRO_VAR_NOME': nome,
          'PRO_INT_QUANTIDADE': quantidade.toString(),
          'PRO_VAR_MEDIDA': medida,
          'PRO_DEC_PRECO': preco.toString(),
        },
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        buscarProdutos();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao atualizar produto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao atualizar produto')),
      );
    }
  }
}
