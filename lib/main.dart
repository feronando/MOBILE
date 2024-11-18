import 'package:f05_lugares_app/data/dados.dart';
import 'package:f05_lugares_app/provider/favoritos.dart';
import 'package:f05_lugares_app/provider/lugares.dart';
import 'package:f05_lugares_app/provider/paises.dart';
import 'package:f05_lugares_app/screens/abas.dart';
import 'package:f05_lugares_app/screens/adicionar_lugar.dart';
import 'package:f05_lugares_app/screens/configuracoes.dart';
import 'package:f05_lugares_app/screens/detalhes_lugar.dart';
import 'package:f05_lugares_app/screens/lugar_screen.dart';
import 'package:f05_lugares_app/screens/lugares_por_pais.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (ctx) => PaisesProvider(paisesDados: List.from(paises))),
      ChangeNotifierProvider(
          create: (ctx) => LugaresProvider(lugaresDados: List.from(lugares))),
      ChangeNotifierProvider(create: (ctx) => FavoritosProvider()),
    ],
    child: MeuApp(),
  ));
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (ctx) => MinhasAbas(),
        '/lugaresPorPais': (ctx) => LugarPorPaisScreen(),
        '/detalheLugar': (ctx) => DetalhesLugarScreen(),
        '/adicionarLugar': (ctx) => AdicionarLugarScreen(),
        '/configuracoes': (ctx) => ConfigracoesScreen(),
      },
    );
  }
}
