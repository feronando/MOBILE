import 'package:f05_lugares_app/components/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/item_lugar.dart';
import '../model/lugar.dart';
import '../provider/lugares.dart';

class LugarScreen extends StatefulWidget {
  const LugarScreen({super.key});

  @override
  State<LugarScreen> createState() => _LugarScreenState();
}

class _LugarScreenState extends State<LugarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LugaresNotifier>(
        builder: (ctx, lugares, child) {
          final sortedLugares = List<Lugar>.from(lugares.lugares);
          sortedLugares.sort((a, b) =>
              a.titulo.toUpperCase().compareTo(b.titulo.toUpperCase()));

          return ListView.builder(
            itemCount: sortedLugares.length,
            itemBuilder: (context, index) {
              return ItemLugar(lugar: sortedLugares.elementAt(index));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/adicionarLugar',
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
