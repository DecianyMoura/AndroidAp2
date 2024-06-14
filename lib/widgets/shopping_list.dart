import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lista_de_compras/models/shopping_item.dart';
import 'package:lista_de_compras/main.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final List<ShoppingItem> _shoppingList = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  String? _selectedCategory;
  late FocusNode _nameFocusNode;
  late FocusNode _quantityFocusNode;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _quantityFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Bem-vindo ao Shopping List!!! \nAdicione, edite, exclua itens de compras e organize-os por categorias!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Color.fromRGBO(0, 0, 0, 1),
              decorationColor: Color.fromRGBO(87, 247, 194, 1),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedCategory,
            hint: const Text('Selecione a categoria'),
            onChanged: (String? value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
            style: TextStyle(color: Theme.of(context).primaryColor),
            items: <String>[
              'Alimentos',
              'Produtos de Higiene',
              'Produtos de Limpeza',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        if (_selectedCategory != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              decoration: const InputDecoration(
                labelText: 'Adicionar item',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        if (_selectedCategory != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _quantityController,
              focusNode: _quantityFocusNode,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2), // Limita a 2 dígitos
              ],
              onSubmitted: (_) {
                _quantityFocusNode.unfocus();
                _addItem();
              },
            ),
          ),
        if (_selectedCategory != null)
          ElevatedButton(
            onPressed: _addItem,
            child: const Text('Adicionar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).highlightColor,
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        Expanded(
          child: _buildCategoryList(),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    Map<String, List<ShoppingItem>> categorizedItems = {};

    _shoppingList.forEach((item) {
      categorizedItems.putIfAbsent(item.category, () => []);
      categorizedItems[item.category]?.add(item);
    });

    return ListView.builder(
      itemCount: categorizedItems.length,
      itemBuilder: (context, index) {
        String category = categorizedItems.keys.toList()[index];
        List<ShoppingItem>? items = categorizedItems[category];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: items?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${items?[index].name} x${items?[index].quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _editItem(context, items![index], index);
                          },
                          color: Theme.of(context).highlightColor,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _shoppingList.remove(items![index]);
                            });
                          },
                          color: Theme.of(context).highlightColor,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addItem() {
    if (_selectedCategory != null &&
        _nameController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      int quantity = int.parse(_quantityController.text);
      setState(() {
        _shoppingList.add(ShoppingItem(
          _nameController.text,
          quantity,
          _selectedCategory!,
        ));
        _nameController.clear();
        _quantityController.clear();
        _selectedCategory = null; // Reinicializando a seleção de categoria
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text(
                'Por favor, preencha todos os campos antes de adicionar o item.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _editItem(BuildContext context, ShoppingItem item, int index) {
    _nameController.text = item.name;
    _quantityController.text = item.quantity.toString();
    _selectedCategory = item.category;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(2), // Limita a 2 dígitos
                ],
              ),
              DropdownButton<String>(
                value: _selectedCategory,
                hint: Text('Selecione a categoria'),
                onChanged: (String? value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                items: <String>[
                  'Alimentos',
                  'Produtos de Higiene',
                  'Produtos de Limpeza',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _quantityController.text.isNotEmpty) {
                  setState(() {
                    _shoppingList[index] = ShoppingItem(
                      _nameController.text,
                      int.parse(_quantityController.text),
                      _selectedCategory!,
                    );
                    _nameController.clear();
                    _quantityController.clear();
                    _selectedCategory = null;
                  });
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Erro'),
                        content: const Text(
                            'Por favor, preencha todos os campos antes de salvar o item editado.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
