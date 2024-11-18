import 'package:f05_lugares_app/components/item_pais.dart';
import 'package:f05_lugares_app/provider/favoritos.dart';
import 'package:flutter/material.dart';
import '../model/lugar.dart';
import 'package:provider/provider.dart';

class LugaresProvider extends ChangeNotifier {
  final List<Lugar> _lugares;

  LugaresProvider({required List<Lugar> lugaresDados})
      : _lugares = lugaresDados;

  List<Lugar> get lugares => _lugares;

  void add(Lugar lugar) {
    _lugares.add(lugar);
    notifyListeners();
  }

  void remove(Lugar lugar, BuildContext context) {
    Provider.of<FavoritosProvider>(context, listen: false).remove(lugar);
    _lugares.remove(lugar);
    notifyListeners();
  }

  void update(Lugar lugar, BuildContext context) {
    Provider.of<FavoritosProvider>(context, listen: false).update(lugar);
    int index = _lugares.indexWhere((p) => p.id == lugar.id);
    if (index != -1) {
      _lugares[index] = lugar;
      notifyListeners();
    }
  }

  void removePais(String idPais) {
    for (Lugar p in _lugares) {
      p.paises.remove(idPais);
    }
  }

  List<Lugar> getLugaresPorPais(String paisId) {
    return _lugares.where((lugar) => lugar.paises.contains(paisId)).toList();
  }
}
