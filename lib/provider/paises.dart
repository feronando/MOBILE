import 'package:f05_lugares_app/model/pais.dart';
import 'package:flutter/material.dart';

import '../components/item_pais.dart';

class PaisesNotifier extends ChangeNotifier {
  final List<Pais> _paises;

  PaisesNotifier({required List<Pais> paises}) : _paises = List.from(paises);

  List<Pais> get paises => _paises;

  void add(String titulo, Color cor) {
    _paises.add(Pais(id: 'c${_paises.length + 1}', titulo: titulo, cor: cor));
    notifyListeners();
  }

  void remove(Pais pais) {
    _paises.remove(pais);
    notifyListeners();
  }

  void edit(Pais pais) {
    int index = _paises.indexWhere((p) => p.id == pais.id);
    if (index != -1) {
      _paises[index] = pais;
      notifyListeners();
    }
  }
}
