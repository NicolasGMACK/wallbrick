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

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'A senha é obrigatória';
    if (password.length < 8) return 'A senha deve ter pelo menos 8 caracteres';
    if (!password.contains(RegExp(r'[A-Z]'))) return 'Deve conter uma letra maiúscula';
    if (!password.contains(RegExp(r'[a-z]'))) return 'Deve conter uma letra minúscula';
    if (!password.contains(RegExp(r'[0-9]'))) return 'Deve conter um número';
    if (!password.contains(RegExp(r'[!@#\$&*~]'))) return 'Deve conter um caractere especial';
    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'O email é obrigatório';
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$');
    if (!emailRegex.hasMatch(email)) return 'Por favor, insira um email válido';
    return null;
  }

  Future<void> cadastrar() async {
    if (nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome é obrigatório')),
      );
      return;
    }

    final emailErro = validateEmail(emailController.text);
    if (emailErro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(emailErro)));
      return;
    }

    final senhaErro = validatePassword(senhaController.text);
    if (senhaErro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(senhaErro)));
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

      final data = json.decode(response.body);
      if (data['status'] == 'sucesso') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        Navigator.pushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao se conectar ao servidor.')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: FractionallySizedBox(
            widthFactor: 0.6,
            child: Card(
               color: Colors.white,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título
                    const Text(
                      'Cadastro WallBrick',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 128, 9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo Nome
                    TextField(
                      controller: nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo E-mail
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Campo Senha
                    TextField(
                      controller: senhaController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botão de Cadastro
                    isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: cadastrar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 128, 9), // Replace 'primary' with 'backgroundColor'
                              minimumSize: const Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cadastrar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                    const SizedBox(height: 10),
                    // Botão para voltar à tela de login
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Já tem conta? Faça login',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
