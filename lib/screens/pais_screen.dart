import 'package:f05_lugares_app/components/item_pais.dart';
import 'package:f05_lugares_app/data/dados.dart';
import 'package:f05_lugares_app/provider/paises.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/pais.dart';

class PaisScreen extends StatelessWidget {
  const PaisScreen({super.key});

  void _addPais(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    late TextEditingController _tituloController = TextEditingController();
    late Color _newColor = Colors.red;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Adicionar novo País"),
            content: Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(labelText: 'Título'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<Color>(
                        value: _newColor,
                        decoration: const InputDecoration(labelText: 'Cor'),
                        items: [
                          ('Vermelho', Colors.red),
                          ('Laranja', Colors.orange),
                          ('Amber', Colors.amber),
                          ('Verde Claro', Colors.lightGreen),
                          ('Verde', Colors.green),
                          ('Teal', Colors.teal),
                          ('Azul Claro', Colors.lightBlue),
                          ('Azul', Colors.blue),
                          ('Índigo', Colors.indigo),
                          ('Roxo Escuro', Colors.deepPurple),
                          ('Roxo', Colors.purple),
                        ].map((color) {
                          return DropdownMenuItem<Color>(
                            value: color.$2,
                            child: Row(
                              children: [
                                Container(
                                    width: 20, height: 20, color: color.$2),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(color.$1)
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (color) {
                          _newColor = color!;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Provider.of<PaisesProvider>(context, listen: false)
                        .add(_tituloController.text, _newColor);

                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('País adicionado!')),
                    );
                  }
                },
                style: TextButton.styleFrom(
                    backgroundColor: ThemeData().primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Text(
                  'Adicionar País',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = 170.0;
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = (screenWidth / itemWidth).floor();

    return Scaffold(
      body: Consumer<PaisesProvider>(builder: (ctx, paises, child) {
        return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1,
            children: paises.paises.map((pais) => ItemPais(pais: pais)).toList()
              ..sort((a, b) => a.paisTitulo
                  .toUpperCase()
                  .compareTo(b.paisTitulo.toUpperCase())));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPais(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
