import 'package:f05_lugares_app/components/item_lugar.dart';
import 'package:f05_lugares_app/data/dados.dart';
import 'package:f05_lugares_app/model/lugar.dart';
import 'package:f05_lugares_app/model/pais.dart';
import 'package:f05_lugares_app/provider/lugares.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LugarPorPaisScreen extends StatelessWidget {
  LugarPorPaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pais = ModalRoute.of(context)?.settings.arguments as Pais;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: pais.cor,
          title: Text(
            "Lugares em ${pais.titulo}",
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white, // Change this to the desired color
          ),
        ),
        body: Consumer<LugaresNotifier>(
          builder: (ctx, lugares, child) {
            List<Lugar> lugaresPorPais = lugares.getLugaresPorPais(pais.id)
              ..sort((a, b) =>
                  a.titulo.toUpperCase().compareTo(b.titulo.toUpperCase()));
            return ListView.builder(
              itemCount: lugaresPorPais.length,
              itemBuilder: (context, index) {
                return ItemLugar(lugar: lugaresPorPais.elementAt(index));
              },
            );
          },
        ));
  }
}
