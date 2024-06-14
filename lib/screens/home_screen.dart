import 'package:flutter/material.dart';
import 'package:lista_de_compras/widgets/shopping_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SHOPPING LIST',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              backgroundColor: Color.fromARGB(0, 232, 28, 255)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(87, 247, 194, 1),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: ShoppingListPage(),
      ),
    );
  }
}
