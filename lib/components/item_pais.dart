import 'package:f05_lugares_app/model/pais.dart';
import 'package:f05_lugares_app/provider/paises.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemPais extends StatelessWidget {
  ItemPais({super.key, required Pais pais}) : _pais = pais;
  final Pais _pais;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController =
      TextEditingController(text: _pais.titulo);
  late Color _newColor = _pais.cor;

  String get paisTitulo => _pais.titulo;

  void _deletePais(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover país?'),
          content: Text('Deseja remover o país ${_pais.titulo}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Provider.of<PaisesProvider>(context, listen: false)
                    .remove(_pais, context);

                Navigator.of(context).pushReplacementNamed(
                  '/',
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('País removido!')),
                );
              },
              style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editPais(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<PaisesProvider>(context, listen: false).update(
          Pais(id: _pais.id, titulo: _tituloController.text, cor: _newColor));

      Navigator.of(context).pushReplacementNamed(
        '/',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('País alterado!')),
      );
    }
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: keyboardHeight + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Text('Edição de Países',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
                const Divider(),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _tituloController,
                        decoration: const InputDecoration(labelText: 'Título'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O título do país não pode ficar em branco';
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _editPais(context);
                            },
                            child: const Text(
                              'Salvar Alterações',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _deletePais(context);
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 3,
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/lugaresPorPais',
            arguments: _pais,
          );
        },
        child: Card(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                height: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  gradient: LinearGradient(
                    colors: [
                      _pais.cor.withOpacity(0.5),
                      _pais.cor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    _pais.titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: TextButton.icon(
                    onPressed: () {
                      _showModal(context);
                    },
                    label: const Text(
                      "editar",
                      style: TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                    icon: const Icon(
                      Icons.edit_sharp,
                      color: Colors.black54,
                      size: 10,
                    ),
                    iconAlignment: IconAlignment.end,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
