import 'package:flutter/material.dart';

class Order {
  String status;
  String product;
  double nombreVendu;
  double price;
  double totalPrice;

  Order(
      {required this.status,
      required this.product,
      required this.price,
      required this.totalPrice,
      required this.nombreVendu});
}

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<Order> orders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications de ventes'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(orders[index].product),
            subtitle: Text('Status: ${orders[index].status}'),
            trailing:
                Text('Price: \$${orders[index].price.toStringAsFixed(2)}'),
            onTap: () {
              // Modify order
              _editOrder(index);
            },
            onLongPress: () {
              // Delete order
              _deleteOrder(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Add new order
          _addOrder();
        },
      ),
    );
  }

  void _addOrder() {
    showDialog(
      context: context,
      builder: (context) {
        String status = '';
        String product = '';
        double nombreVendu = 0.0;
        double price = 0.0;
        double totalPrice = 0.0;

        return AlertDialog(
          title: const Text('Ajouter une vente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Status'),
                onChanged: (value) {
                  status = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Produit'),
                onChanged: (value) {
                  product = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Nombre Vendu'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  nombreVendu = double.parse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  price = double.parse(value);
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Prix Total'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalPrice = double.parse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ajouter'),
              onPressed: () {
                setState(() {
                  orders.add(
                    Order(
                      status: status,
                      product: product,
                      nombreVendu: nombreVendu,
                      price: price,
                      totalPrice: totalPrice,
                    ),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editOrder(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String status = orders[index].status;
        String product = orders[index].product;
        double price = orders[index].price;
        double totalPrice = orders[index].totalPrice;
        double nombreVendu = orders[index].nombreVendu;

        return AlertDialog(
          title: const Text('Modifier une commande'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Status'),
                onChanged: (value) {
                  status = value;
                },
                controller: TextEditingController(text: status),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Produit'),
                onChanged: (value) {
                  product = value;
                },
                controller: TextEditingController(text: product),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'NombreVendu'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  nombreVendu = double.parse(value);
                },
                controller: TextEditingController(text: nombreVendu.toString()),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  price = double.parse(value);
                },
                controller: TextEditingController(text: price.toString()),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Prix Total'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  totalPrice = double.parse(value);
                },
                controller: TextEditingController(text: totalPrice.toString()),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sauvegarder'),
              onPressed: () {
                setState(() {
                  orders[index].status = status;
                  orders[index].product = product;
                  orders[index].price = price;
                  orders[index].totalPrice = totalPrice;
                  orders[index].nombreVendu = nombreVendu;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteOrder(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer une vente'),
          content:
              const Text('Êtes vous sûrs de vouloir supprimer cette vente?'),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Supprimer'),
              onPressed: () {
                setState(() {
                  orders.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
