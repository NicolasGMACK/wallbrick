import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    // Inicia o fade out após 5 segundos
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _opacity = 0.0; // Inicia a animação do fade out
      });
    });

    // Aguarda mais 1 segundo (tempo do fade out) antes de navegar para a próxima tela
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 187, 187, 187), // Fundo inicial
      body: AnimatedOpacity(
        opacity: _opacity, // Controla a opacidade da imagem
        duration: Duration(seconds: 1), // Duração do fade out
        child: Center(
          child: Image.asset(
            'assets/wb-teste.png', // Certifique-se de que o caminho está correto
          ),
        ),
      ),
    );
  }
}
