import 'package:flutter/material.dart';

class Commande {
  final String projet;
  final String statut;
  final double prix;
  final int nombre;
  final double prixTotal;
  final String nomProduit;

  Commande({
    required this.projet,
    required this.statut,
    required this.nomProduit,
    required this.nombre,
    required this.prix,    
    required this.prixTotal,
    
  });
}
void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Commandes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Commande> _commandesList = [];
  final TextEditingController _projetController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _nomProduitController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();  
  final TextEditingController _prixTotalController = TextEditingController();
  

  void _addCommande(Commande commande) {
    setState(() {
      _commandesList.add(commande);
    });
  }

  void _removeCommande(int index) {
    setState(() {
      _commandesList.removeAt(index);
    });
  }

  void _editCommande(int index, Commande newCommande) {
    setState(() {
      _commandesList[index] = newCommande;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Commandes', style: TextStyle(fontSize: 24))),
      ),
      body: ListView.builder(
        itemCount: _commandesList.length,
        itemBuilder: (context, index) {
          final commande = _commandesList[index];
          return Dismissible(
            key: Key(commande.toString()),
            onDismissed: (direction) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Commande "${commande.projet}" removed'),
                  duration: const Duration(seconds: 2),
                ),
              );
              _removeCommande(index);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
                ),
              ),
              child: ListTile(
                title: Text('Projet: ${commande.projet}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Statut: ${commande.statut}'),
                    Text('Nom Produit: ${commande.nomProduit}'),
                    Text('Nombre: ${commande.nombre}'),
                    Text('Prix: ${commande.prix}'),                    
                    Text('Prix Total: ${commande.prixTotal}'),                    
                  ],
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      _projetController.text = commande.projet;    
                      _statusController.text = commande.statut;
                      _nomProduitController.text = commande.nomProduit;
                      _nombreController.text = commande.nombre.toString();
                      _prixController.text = commande.prix.toString();                                       
                      _prixTotalController.text = commande.prixTotal.toString();

                      return AlertDialog(
                        title: const Text('Modifier Commande'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _projetController,
                              decoration: const InputDecoration(labelText: 'Projet'),
                            ),
                            TextField(
                              controller: _statusController,
                              decoration: const InputDecoration(labelText: 'Statut'),
                            ),
                             TextField(
                              controller: _nomProduitController,
                              decoration: const InputDecoration(labelText: 'Nom Produit'),
                            ),
                            TextField(
                              controller: _nombreController,
                              decoration: const InputDecoration(labelText: 'Nombre'),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              controller: _prixController,
                              decoration: const InputDecoration(labelText: 'Prix'),
                              keyboardType: TextInputType.number,
                            ),                     
                                                   
                            TextField(
                              controller: _prixTotalController,
                              decoration: const InputDecoration(labelText: 'Prix Total'),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              final newCommande = Commande(
                                projet: _projetController.text,
                                statut: _statusController.text,
                                nomProduit: _nomProduitController.text,
                                nombre: int.parse(_nombreController.text), 
                                prix: double.parse(_prixController.text),                           
                                prixTotal: double.parse(_prixTotalController.text),
                                
                              );
                              _editCommande(index, newCommande);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Enregistrer'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              _statusController.clear();
              _prixController.clear();
              _projetController.clear();
              _nombreController.clear();
              _prixTotalController.clear();
              _nomProduitController.clear();
              return AlertDialog(
                title: const Text('Ajouter Commande'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     TextField(
                      controller: _projetController,
                      decoration: const InputDecoration(labelText: 'Projet'),
                    ),
                    TextField(
                      controller: _statusController,
                      decoration: const InputDecoration(labelText: 'Statut'),
                    ),
                    TextField(
                      controller: _nomProduitController,
                      decoration: const InputDecoration(labelText: 'Nom Produit'),
                    ),
                    TextField(
                      controller: _nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      keyboardType: TextInputType.number,
                    ),                    
                    TextField(
                      controller: _prixController,
                      decoration: const InputDecoration(labelText: 'Prix'),
                      keyboardType: TextInputType.number,
                    ),            
                               
                    TextField(
                      controller: _prixTotalController,
                      decoration: const InputDecoration(labelText: 'Prix Total'),
                      keyboardType: TextInputType.number,
                    ),                    
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      final newCommande = Commande(
                        statut: _statusController.text,
                        prix: double.parse(_prixController.text),
                        projet: _projetController.text,
                        nombre: int.parse(_nombreController.text),
                        prixTotal: double.parse(_prixTotalController.text),
                        nomProduit: _nomProduitController.text,
                      );
                      _addCommande(newCommande);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ajouter'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}