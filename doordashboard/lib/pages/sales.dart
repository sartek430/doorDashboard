import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String id;
  String status;
  String product;
  String vendeur;
  double nombreVendu;
  double price;
  double totalPrice;

  Order(
      {required this.id,
      required this.status,
      required this.product,
      required this.price,
      required this.totalPrice,
      required this.nombreVendu,
      required this.vendeur});
}

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<Order> tempOrders = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applications de ventes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('sales').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          tempOrders =
              []; // Réinitialiser la liste temporaire à chaque fois que les données changent
          final orders = snapshot.data!.docs;
          for (final order in orders) {
            final orderData = order.data() as Map<String, dynamic>;
            final newOrder = Order(
              id: order.id,
              status: orderData['status'],
              product: orderData['product'],
              price: orderData['price'],
              totalPrice: orderData['totalPrice'],
              nombreVendu: orderData['nombreVendu'],
              vendeur: getUserEmail(),
            );
            tempOrders.add(newOrder);
          }

          return ListView.builder(
            itemCount: tempOrders.length,
            itemBuilder: (context, index) {
              final order = tempOrders[index];
              return ListTile(
                title: Text(order.product),
                subtitle:
                    Text('Status: ${order.status} - Vendeur: ${order.vendeur}'),
                trailing: Text('Prix: \$${order.price.toStringAsFixed(2)}'),
                onTap: () {
                  _editOrder(index);
                },
                onLongPress: () {
                  _deleteOrder(index);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
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
              onPressed: () async {
                final userEmail = getUserEmail();
                final newOrder = Order(
                  id: '',
                  vendeur: userEmail,
                  status: status,
                  product: product,
                  nombreVendu: nombreVendu,
                  price: price,
                  totalPrice: totalPrice,
                );

                final docRef =
                    await FirebaseFirestore.instance.collection('sales').add({
                  'vendeur': userEmail,
                  'status': status,
                  'product': product,
                  'nombreVendu': nombreVendu,
                  'price': price,
                  'totalPrice': totalPrice
                });

                newOrder.id = docRef.id;

                setState(() {
                  tempOrders.add(newOrder);
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String getUserEmail() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      return user.email!;
    } else {
      return '';
    }
  }

  void _editOrder(int index) {
    showDialog(
      context: context,
      builder: (context) {
        String status = tempOrders[index].status;
        String product = tempOrders[index].product;
        double price = tempOrders[index].price;
        double totalPrice = tempOrders[index].totalPrice;
        double nombreVendu = tempOrders[index].nombreVendu;

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
              onPressed: () async {
                setState(() {
                  tempOrders[index].status = status;
                  tempOrders[index].product = product;
                  tempOrders[index].price = price;
                  tempOrders[index].totalPrice = totalPrice;
                  tempOrders[index].nombreVendu = nombreVendu;
                });

                // Mettre à jour la commande dans la base de données Firebase
                final orderRef =
                    firestore.collection('sales').doc(tempOrders[index].id);
                await orderRef.update({
                  'status': status,
                  'product': product,
                  'price': price,
                  'totalPrice': totalPrice,
                  'nombreVendu': nombreVendu,
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
    final order = tempOrders[index];
    final orderRef = firestore.collection('sales').doc(order.id);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Supprimer une vente'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer cette vente ?'),
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
                orderRef.delete();
                setState(() {
                  tempOrders.removeAt(index);
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
