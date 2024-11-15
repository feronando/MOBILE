import 'package:f05_lugares_app/components/item_lugar.dart';
import 'package:f05_lugares_app/provider/favoritos.dart';
import 'package:f05_lugares_app/model/lugar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritosNotifier>(builder: (ctx, favoritos, child) {
      if (favoritos.lugaresFavoritos.isEmpty) {
        return const Center(
          child: Text(
            'Nenhum Lugar Marcado como Favorito!',
            style: TextStyle(fontSize: 20),
          ),
        );
      } else {
        return ListView.builder(
            itemCount: favoritos.lugaresFavoritos.length,
            itemBuilder: (ctx, index) {
              return ItemLugar(
                lugar: favoritos.lugaresFavoritos.elementAt(index),
              );
            });
      }
    });
  }
}
