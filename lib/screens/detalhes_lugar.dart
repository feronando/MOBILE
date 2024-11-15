import 'package:f05_lugares_app/main.dart';
import 'package:f05_lugares_app/provider/favoritos.dart';
import 'package:f05_lugares_app/model/lugar.dart';
import 'package:f05_lugares_app/provider/lugares.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';

import '../model/pais.dart';
import '../provider/paises.dart';

class DetalhesLugarScreen extends StatefulWidget {
  DetalhesLugarScreen({super.key});

  @override
  State<DetalhesLugarScreen> createState() => _DetalhesLugarScreenState();
}

class _DetalhesLugarScreenState extends State<DetalhesLugarScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _titulo;
  late double _avaliacao;
  late double _custoMedio;
  late String _imagemUrl;
  late List<String> _paisesSelecionados;
  late List<TextEditingController> _recomendacoes = [];

  void favoritar(BuildContext context, Lugar lugar) {
    Provider.of<FavoritosNotifier>(context, listen: false).favoritar(lugar);
  }

  void _addRecomendacao() {
    setState(() {
      _recomendacoes.add(TextEditingController(text: ''));
      print("Recomendacao added: ${_recomendacoes.length}");
    });
  }

  void _removeRecomendacao(int index) {
    setState(() {
      _recomendacoes[index].dispose();
      _recomendacoes.removeAt(index);
      print("Recomendacao removed: ${_recomendacoes.length}");
    });
  }

  void _showDialog(BuildContext context, Lugar lugar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover lugar?'),
          content: Text('Deseja remover o lugar ${lugar.titulo}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<LugaresNotifier>(context, listen: false)
                    .remove(lugar, context);

                Navigator.of(context).pushReplacementNamed(
                  '/',
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lugar removido!')),
                );
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showModal(BuildContext context, Lugar lugar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _titulo = lugar.titulo;
        _avaliacao = lugar.avaliacao;
        _custoMedio = lugar.custoMedio;
        _imagemUrl = lugar.imagemUrl;
        _paisesSelecionados = List.from(lugar.paises);
        _recomendacoes = List.from(
            lugar.recomendacoes.map((l) => TextEditingController(text: l)));

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: keyboardHeight + 50,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Center(
                    child: Text('Edição de Lugar',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _titulo,
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
                            initialValue: _imagemUrl,
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
                            initialValue: _avaliacao.toString(),
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
                              if (double.parse(value) < 0 ||
                                  double.parse(value) > 5) {
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
                            initialValue: _custoMedio.toString(),
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
                          // MultiSelectDialogField(
                          //   buttonText: const Text("Países"),
                          //   buttonIcon: Icon(Icons.arrow_drop_down),
                          //   title: Text(
                          //     "Selecione os países:",
                          //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          //   ),
                          //   decoration: BoxDecoration(
                          //       color: const Color(0x34B5B5B5),
                          //       borderRadius: BorderRadius.circular(5)),
                          //   chipDisplay: MultiSelectChipDisplay.none(),
                          //   initialValue: _paisesSelecionados.cast<dynamic>(),
                          //   items: Provider.of<PaisesNotifier>(context, listen: false)
                          //       .paises
                          //       .map((pais) => MultiSelectItem(pais, pais.titulo))
                          //       .toList()
                          //     ..sort((a, b) =>
                          //         a.label.toUpperCase().compareTo(b.label.toUpperCase())),
                          //   listType: MultiSelectListType.LIST,
                          //   onConfirm: (values) {
                          //       _paisesSelecionados = List.from(values.map());
                          //   },
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return 'Pelo menos 1 país deve ser selecionado';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // const SizedBox(height: 5),
                          // MultiSelectChipDisplay(
                          //   items: _paisesSelecionados
                          //       .map((p) => MultiSelectItem(p, p.titulo))
                          //       .toList()
                          //     ..sort((a, b) =>
                          //         a.label.toUpperCase().compareTo(b.label.toUpperCase())),
                          //   onTap: (value) {
                          //     setState(() {
                          //       _paisesSelecionados.remove(value);
                          //     });
                          //   },
                          // ),
                          const SizedBox(height: 5),
                          const Text(
                            "Recomendações:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),
                          ListView.builder(
                            key: ValueKey(_recomendacoes.length),
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
                                              labelText:
                                                  'Recomendação ${index + 1}',
                                              filled: true,
                                              fillColor:
                                                  const Color(0x34B5B5B5),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              labelStyle: const TextStyle(
                                                  fontSize: 12)),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Recomendação em branco';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        iconSize: 20,
                                        onPressed: () => {
                                          setModalState(() {
                                            _recomendacoes[index].dispose();
                                            _recomendacoes.removeAt(index);
                                          })
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              );
                            },
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setModalState(() {
                                _recomendacoes
                                    .add(TextEditingController(text: ''));
                              });
                            },
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
                            onPressed: () {},
                            child: Text('Salvar alterações'),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final lugar = ModalRoute.of(context)?.settings.arguments as Lugar;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeData().primaryColor,
        title: Text(
          lugar.titulo,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change this to the desired color
        ),
        actions: [
          IconButton(
              onPressed: () => _showModal(context, lugar),
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () => _showDialog(context, lugar),
              icon: Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                lugar.imagemUrl,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey[700],
                      size: 50,
                    ),
                  );
                },
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Dicas',
                style: ThemeData().textTheme.displayLarge,
              ),
            ),
            Container(
              width: 350,
              height: 300,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              child: ListView.builder(
                  itemCount: lugar.recomendacoes.length,
                  itemBuilder: (contexto, index) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(lugar.recomendacoes[index]),
                          subtitle: Text(lugar.titulo),
                          onTap: () {
                            print(lugar.recomendacoes[index]);
                          },
                        ),
                        const Divider(),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => favoritar(context, lugar),
        child: const Icon(Icons.star_border),
      ),
    );
  }
}
