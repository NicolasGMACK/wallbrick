import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  bool isLoading = false;

  // Função de validação da senha
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'A senha é obrigatória';
    }
    if (password.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'A senha deve conter pelo menos uma letra minúscula';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'A senha deve conter pelo menos um número';
    }
    if (!password.contains(RegExp(r'[!@#\$&*~]'))) {
      return 'A senha deve conter pelo menos um caractere especial';
    }
    return null; // Senha válida
  }

  // Função de validação do email
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'O email é obrigatório';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Por favor, insira um email válido';
    }
    return null; // Email válido
  }

  // Função para cadastrar o usuário
  Future<void> cadastrar() async {
    // Verifica campos vazios e validações
    if (nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome é obrigatório')),
      );
      return;
    }

    final emailErro = validateEmail(emailController.text);
    if (emailErro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailErro)),
      );
      return;
    }

    final senhaErro = validatePassword(senhaController.text);
    if (senhaErro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(senhaErro)),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost/meuapp/processa_cadastro.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'nome': nomeController.text,
          'email': emailController.text,
          'senha': senhaController.text,
        },
      );

      try {
        final data = json.decode(response.body);
        if (data['status'] == 'sucesso') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
          // Redireciona para a tela de login
          Navigator.pushNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'])),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao processar resposta do servidor.')),
        );
        print('Erro de JSON: $e\nResposta: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao se conectar ao servidor.')),
      );
      print('Erro de conexão: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Campo Nome
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            // Campo E-mail
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress, // Teclado específico para email
            ),
            // Campo Senha
            TextField(
              controller: senhaController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true, // Oculta a senha digitada
            ),
            const SizedBox(height: 20),
            // Botão de Cadastro com indicador de carregamento
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: cadastrar,
                    child: const Text('Cadastrar'),
                  ),
            const SizedBox(height: 10),
            // Botão para voltar à tela de login
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Já tem conta? Faça login'),
            ),
          ],
        ),
      ),
    );
  }
}
