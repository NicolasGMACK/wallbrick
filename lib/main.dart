import 'package:flutter/material.dart';
import 'telas/cadastro.dart';
import 'telas/login.dart';
import 'telas/read.dart';
import 'telas/cadastrar_produto.dart';
import 'telas/cadastrar_fornecedor.dart';
import 'telas/splash_screen.dart'; // Import da splash screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gerenciador de Telas',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/splash', // Splash é a inicial agora
      routes: {
        '/splash': (context) => SplashScreen(), // Nova rota
        '/login': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
        '/read': (context) => ListaProdutosPage(),
        '/cadastrar': (context) => CadastrarProdutoPage(),
        '/cadastrarFornecedor': (context) => CadastrarFornecedorPage(),
      },
    );
  }
}
