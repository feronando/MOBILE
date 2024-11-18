import 'package:flutter/material.dart';
import 'package:f05_lugares_app/model/lugar.dart';

class FavoritosProvider extends ChangeNotifier {
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

  void update(Lugar lugar) {
    int index = _lugaresFavoritos.indexWhere((p) => p.id == lugar.id);
    if (index != -1) {
      _lugaresFavoritos[index] = lugar;
      notifyListeners();
    }
  }

  void favoritar(Lugar lugar) {
    _lugaresFavoritos.contains(lugar) ? remove(lugar) : add(lugar);
  }
}
