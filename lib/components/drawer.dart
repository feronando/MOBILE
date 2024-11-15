import 'package:flutter/material.dart';

class MeuDrawer extends StatelessWidget {
  const MeuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: ThemeData().primaryColor,
            ),
            child: Text(
              'Configurações',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              size: 20,
            ),
            title: const Text('Home'),
            onTap: () {
              //context.pushReplacement('/');
              Navigator.of(context).pushReplacementNamed(
                '/',
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.engineering,
              size: 20,
            ),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                '/configuracoes',
              );
            },
          ),
        ],
      ),
    );
  }
}
