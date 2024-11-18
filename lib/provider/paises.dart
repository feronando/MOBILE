import 'package:f05_lugares_app/model/pais.dart';
import 'package:f05_lugares_app/provider/lugares.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/item_pais.dart';

class PaisesProvider extends ChangeNotifier {
  final List<Pais> _paises;

  PaisesProvider({required List<Pais> paisesDados}) : _paises = paisesDados;

  List<Pais> get paises => _paises;

  void add(String titulo, Color cor) {
    _paises.add(Pais(id: 'c${_paises.length + 1}', titulo: titulo, cor: cor));
    notifyListeners();
  }

  void remove(Pais pais, BuildContext context) {
    Provider.of<LugaresProvider>(context, listen: false).removePais(pais.id);

    int index = _paises.indexWhere((p) => p.id == pais.id);
    for (int i = index + 1; i < _paises.length; i++) {
      _paises[i] =
          Pais(id: 'c${i}', titulo: _paises[i].titulo, cor: _paises[i].cor);
    }

    _paises.remove(pais);
    notifyListeners();
  }

  void update(Pais pais) {
    int index = _paises.indexWhere((p) => p.id == pais.id);
    if (index != -1) {
      _paises[index] = pais;
      notifyListeners();
    }
  }
}
