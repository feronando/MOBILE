import 'package:flutter/material.dart';
import 'package:f05_lugares_app/model/lugar.dart';

class FavoritosNotifier extends ChangeNotifier {
  final List<Lugar> _lugaresFavoritos = [];

  List<Lugar> get lugaresFavoritos => _lugaresFavoritos;

  void add(Lugar lugar) {
    _lugaresFavoritos.add(lugar);
    notifyListeners();
  }

  void remove(Lugar lugar) {
    _lugaresFavoritos.remove(lugar);
    notifyListeners();
  }

  void favoritar(Lugar lugar) {
    _lugaresFavoritos.contains(lugar)
        ? _lugaresFavoritos.remove(lugar)
        : _lugaresFavoritos.add(lugar);
  }
}
