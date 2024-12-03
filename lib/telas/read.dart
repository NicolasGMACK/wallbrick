import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListaProdutosPage extends StatefulWidget {
  @override
  _ListaProdutosPageState createState() => _ListaProdutosPageState();
}

class _ListaProdutosPageState extends State<ListaProdutosPage> {
  List produtos = []; // Lista para armazenar os produtos

  // Função para buscar os produtos do PHP
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
      print('Erro: $e');
    }
  }

  // Função para abrir o popup de edição
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
                  int.parse(produto['PRO_INT_COD']), // Conversão explícita
                  nomeController.text,
                  int.parse(quantidadeController.text),
                  medidaController.text, // Passando medida para o update
                  double.tryParse(precoController.text) ?? 0.0, // Garantindo que o preço seja um double válido
                );
                Navigator.pop(context); // Fecha o diálogo
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  // Função para atualizar o produto no servidor
  void atualizarProduto(int id, String nome, int quantidade, String medida, double preco) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_update.php'),
        headers: {
          'Content-Type': 'application/json', // Adicione cabeçalho para enviar como JSON
        },
        body: jsonEncode({
          'id': id.toString(),
          'nome': nome,
          'quantidade': quantidade.toString(),
          'medida': medida, // Adicionando a medida
          'preco': preco.toString(),
        }),
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Produto atualizado com sucesso')),
        );
        buscarProdutos(); // Atualiza a lista após a edição
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao atualizar produto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao se conectar ao servidor')),
      );
      print('Erro: $e');
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
      appBar: AppBar(title: const Text('Lista de Produtos')),
      body: produtos.isEmpty
          ? Center(
              child: const Text(
                'Nenhum produto cadastrado.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                final produto = produtos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(produto['PRO_VAR_NOME']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${produto['PRO_INT_QUANTIDADE']} ${produto['PRO_VAR_MEDIDA']}'),
                        Text('Preço: R\$ ${produto['PRO_DEC_PRECO'].toString()}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => editarProduto(produto),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmarExclusao(produto),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cadastrar').then((_) => buscarProdutos());
        },
        child: const Icon(Icons.add),
        tooltip: 'Cadastrar Produto',
      ),
    );
  }

  // Função para confirmar a exclusão de um produto
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
                Navigator.pop(context); // Fecha o diálogo
                excluirProduto(produto); // Exclui o produto
              },
              child: const Text('Excluir'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  // Função para excluir um produto
  void excluirProduto(Map produto) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_delete.php'),
        body: {'id': int.parse(produto['PRO_INT_COD']).toString()}, // Conversão explícita
      );

      final data = json.decode(response.body);

      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Produto excluído com sucesso')),
        );
        buscarProdutos(); // Atualiza a lista após a exclusão
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Erro ao excluir produto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao se conectar ao servidor')),
      );
      print('Erro: $e');
    }
  }
}
