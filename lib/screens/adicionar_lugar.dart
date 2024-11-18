import 'package:f05_lugares_app/model/lugar.dart';
import 'package:f05_lugares_app/model/pais.dart';
import 'package:f05_lugares_app/provider/paises.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';

import '../provider/lugares.dart';

class AdicionarLugarScreen extends StatefulWidget {
  const AdicionarLugarScreen({super.key});

  @override
  State<AdicionarLugarScreen> createState() => _AdicionarLugarScreenState();
}

class _AdicionarLugarScreenState extends State<AdicionarLugarScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _titulo;
  late double _avaliacao;
  late double _custoMedio;
  late String _imagemUrl;
  late List<Pais> _paisesSelecionados = [];
  final List<TextEditingController> _recomendacoes = [];

  void _addRecomendacao() {
    setState(() {
      _recomendacoes.add(TextEditingController(text: ''));
    });
  }

  void _removeRecomendacao(int index) {
    setState(() {
      _recomendacoes.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<LugaresProvider>(context, listen: false).add(Lugar(
          id: 'p${Provider.of<LugaresProvider>(context, listen: false).lugares.length + 1}',
          paises: _paisesSelecionados.map((p) => p.id).toList(),
          titulo: _titulo,
          imagemUrl: _imagemUrl,
          recomendacoes: _recomendacoes.map((r) => r.text).toList(),
          avaliacao: _avaliacao,
          custoMedio: _custoMedio));

      Navigator.of(context).pushReplacementNamed(
        '/',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Novo lugar adicionado!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeData().primaryColor,
        title: const Text(
          "Cadastro de Lugares",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to the desired color
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Cadastre um novo lugar",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Título',
                      filled: true,
                      fillColor: const Color(0x34B5B5B5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5)),
                      labelStyle: TextStyle(fontSize: 14)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _titulo = value ?? '';
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'URL da Imagem',
                      filled: true,
                      fillColor: const Color(0x34B5B5B5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5)),
                      labelStyle: TextStyle(fontSize: 14)),
                  onSaved: (value) {
                    _imagemUrl = value ?? '';
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Avaliação',
                      filled: true,
                      fillColor: const Color(0x34B5B5B5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5)),
                      labelStyle: TextStyle(fontSize: 14)),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Valor numérico inválido';
                    }
                    if (double.parse(value) < 0 || double.parse(value) > 5) {
                      return 'Precisa ser um valor entre 0 e 5';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _avaliacao = double.parse(value ?? '0');
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Custo Médio',
                      filled: true,
                      fillColor: const Color(0x34B5B5B5),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5)),
                      labelStyle: TextStyle(fontSize: 14)),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Valor numérico inválido';
                    }
                    if (double.parse(value) < 0) {
                      return 'Precisa ser um valor maior que 0';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _custoMedio = double.parse(value ?? '0');
                  },
                ),
                const SizedBox(height: 10),
                MultiSelectDialogField(
                  buttonText: const Text("Países"),
                  buttonIcon: Icon(Icons.arrow_drop_down),
                  title: Text(
                    "Selecione os países:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  decoration: BoxDecoration(
                      color: const Color(0x34B5B5B5),
                      borderRadius: BorderRadius.circular(5)),
                  chipDisplay: MultiSelectChipDisplay.none(),
                  initialValue: _paisesSelecionados.cast<dynamic>(),
                  items: Provider.of<PaisesProvider>(context, listen: false)
                      .paises
                      .map((pais) => MultiSelectItem(pais, pais.titulo))
                      .toList()
                    ..sort((a, b) =>
                        a.label.toUpperCase().compareTo(b.label.toUpperCase())),
                  listType: MultiSelectListType.LIST,
                  onConfirm: (values) {
                    setState(() {
                      _paisesSelecionados = values.cast<Pais>().toList();
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pelo menos 1 país deve ser selecionado';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 5),
                MultiSelectChipDisplay(
                  items: _paisesSelecionados
                      .map((p) => MultiSelectItem(p, p.titulo))
                      .toList()
                    ..sort((a, b) =>
                        a.label.toUpperCase().compareTo(b.label.toUpperCase())),
                  onTap: (value) {
                    setState(() {
                      _paisesSelecionados.remove(value);
                    });
                  },
                ),
                const SizedBox(height: 5),
                const Text(
                  "Recomendações:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _recomendacoes.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _recomendacoes[index],
                                decoration: InputDecoration(
                                    labelText: 'Recomendação ${index + 1}',
                                    filled: true,
                                    fillColor: const Color(0x34B5B5B5),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(5)),
                                    labelStyle: const TextStyle(fontSize: 12)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Recomendação em branco';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              iconSize: 20,
                              onPressed: () => _removeRecomendacao(index),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    );
                  },
                ),
                TextButton.icon(
                  onPressed: _addRecomendacao,
                  icon: const Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Adicionar recomendação",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Adicionar Lugar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
