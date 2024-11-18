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
  void favoritar(BuildContext context, Lugar lugar) {
    Provider.of<FavoritosProvider>(context, listen: false).favoritar(lugar);
  }

  void _showDeleteDialog(BuildContext context, Lugar lugar) {
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
                Provider.of<LugaresProvider>(context, listen: false)
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

  void _showEditDialog(BuildContext context, Lugar lugar) {
    final _formKey = GlobalKey<FormState>();
    final _tituloController = TextEditingController(text: lugar.titulo);
    final _imagemUrlController = TextEditingController(text: lugar.imagemUrl);
    final _avaliacaoController =
        TextEditingController(text: lugar.avaliacao.toString());
    final _custoMedioController =
        TextEditingController(text: lugar.custoMedio.toString());
    final List<TextEditingController> _recomendacoesControllers = lugar
        .recomendacoes
        .map((recomendacao) => TextEditingController(text: recomendacao))
        .toList();
    List<Pais> _paisesSelecionados =
        Provider.of<PaisesProvider>(context, listen: false)
            .paises
            .where((pais) => lugar.paises.contains(pais.id))
            .toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Lugar"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _tituloController,
                    decoration: const InputDecoration(labelText: "Título"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _imagemUrlController,
                    decoration:
                        const InputDecoration(labelText: "URL da Imagem"),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _avaliacaoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Avaliação"),
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
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _custoMedioController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Custo Médio"),
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
                  ),
                  const SizedBox(height: 10),
                  MultiSelectDialogField(
                    buttonText: const Text("Países"),
                    title: const Text("Selecione os países"),
                    items: Provider.of<PaisesProvider>(context, listen: false)
                        .paises
                        .map((pais) => MultiSelectItem(pais, pais.titulo))
                        .toList(),
                    initialValue: _paisesSelecionados,
                    onConfirm: (values) {
                      _paisesSelecionados = values.cast<Pais>().toList();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Pelo menos 1 país deve ser selecionado';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text("Recomendações:"),
                  StatefulBuilder(builder:
                      (BuildContext context, StateSetter setDialogState) {
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _recomendacoesControllers.length,
                          itemBuilder: (ctx, index) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        _recomendacoesControllers[index],
                                    decoration: const InputDecoration(
                                        labelText: "Recomendação"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Recomendação em branco';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setDialogState(() {
                                      _recomendacoesControllers.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setDialogState(() {
                              _recomendacoesControllers
                                  .add(TextEditingController());
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Adicionar Recomendação"),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Provider.of<LugaresProvider>(context, listen: false).update(
                      Lugar(
                        id: lugar.id,
                        titulo: _tituloController.text,
                        imagemUrl: _imagemUrlController.text,
                        avaliacao: double.parse(_avaliacaoController.text),
                        custoMedio: double.parse(_custoMedioController.text),
                        paises: _paisesSelecionados.map((p) => p.id).toList(),
                        recomendacoes: _recomendacoesControllers
                            .map((controller) => controller.text)
                            .toList(),
                      ),
                      context);
                  Navigator.of(context).pushReplacementNamed(
                    '/',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Lugar atualizado!')),
                  );
                }
              },
              child: const Text("Salvar"),
            ),
          ],
        );
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
              onPressed: () => _showEditDialog(context, lugar),
              icon: Icon(Icons.edit)),
          IconButton(
              onPressed: () => _showDeleteDialog(context, lugar),
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
