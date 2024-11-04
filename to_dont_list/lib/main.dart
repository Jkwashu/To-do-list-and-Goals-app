// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
// import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/objects/toy.dart';
import 'package:to_dont_list/widgets/toy_items.dart';
import 'package:to_dont_list/widgets/toy_dialog.dart';

class ToyList extends StatefulWidget {
  const ToyList({super.key});

  @override
  State createState() => _ToyListState();
}

class _ToyListState extends State<ToyList> {
  // Created 2 Lists of Toys owned and wishlisted 
  final List<Toy> ownedToys = [Toy(name: "Legacy Core Optimus Prime", color: Faction.a.rgbcolor)];
  final List<Toy> wishlistToys = [Toy(name: "Masterpiece Bumblebee", color: Faction.a.rgbcolor)];

  // edited _handleListChanged so it can remove toy from wishlist to owned
  // if the toy is thrown or destroyed clicking on it will remove it from owned list
  void _handleListChanged(Toy item, bool isNotOwned) {
    setState(() {
      if (isNotOwned) {
        ownedToys.remove(item);
        wishlistToys.insert(0, item);
      } else {
        wishlistToys.remove(item);
        ownedToys.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Toy item, bool isOwned) {
    setState(() {
      if (isOwned) {
        ownedToys.remove(item);
      } else {
        wishlistToys.remove(item);
      }
    });
  }

  void _handleNewItem(String itemText, Color itemColor, TextEditingController textController) {
    setState(() {
      print("Adding toy");
      Toy item = Toy(name: itemText, color:itemColor);
      wishlistToys.insert(0, item);
      textController.clear();
    });
  }

  // added another Listview in children
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Transformers Collection'),
        ),
        body: Column(
        children: [
          // Owned Toys List displayed on screen
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Owned Toys',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: ownedToys.map((toy) {
                      return ToyListItem(
                        toy: toy,
                        got: true, // Already owned
                        onListChanged: (toy, _) => _handleListChanged(toy, true),
                        onDeleteItem: (toy) => _handleDeleteItem(toy, true),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1.0, color: Colors.black),
          // Wishlist Toys list displayed on screen 
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Wishlist Toys',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: wishlistToys.map((toy) {
                      return ToyListItem(
                        toy: toy,
                        got: false, // Not owned in wishlist
                        onListChanged: (toy, _) => _handleListChanged(toy, false),
                        onDeleteItem: (toy) => _handleDeleteItem(toy, false),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ToyDialog(onListAdded: _handleNewItem);
                  });
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Transformer Collector',
    home: ToyList(),
  ));
}
