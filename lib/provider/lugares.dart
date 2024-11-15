import 'package:f05_lugares_app/components/item_pais.dart';
import 'package:f05_lugares_app/provider/favoritos.dart';
import 'package:flutter/material.dart';
import '../model/lugar.dart';
import 'package:provider/provider.dart';

class LugaresNotifier extends ChangeNotifier {
  final List<Lugar> _lugares;

  LugaresNotifier({required List<Lugar> lugares})
      : _lugares = List.from(lugares);

  List<Lugar> get lugares => _lugares;

  void add(Lugar lugar) {
    _lugares.add(lugar);
    notifyListeners();
  }

  void remove(Lugar lugar, BuildContext context) {
    _lugares.remove(lugar);
    Provider.of<FavoritosNotifier>(context, listen: false).remove(lugar);
    notifyListeners();
  }

  List<Lugar> getLugaresPorPais(String paisId) {
    return _lugares.where((lugar) => lugar.paises.contains(paisId)).toList();
  }
}
