// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/toy.dart';
import 'package:to_dont_list/widgets/toy_items.dart';
import 'package:to_dont_list/widgets/toy_dialog.dart';

class ToyList extends StatefulWidget {
  const ToyList({super.key});

  @override
  State createState() => _ToyListState();
}

class _ToyListState extends State<ToyList> {
  ToySortOption _currentSortOption = ToySortOption.name;

  // Created 2 Lists of Toys owned and wishlisted
  final List<Toy> ownedToys = [
    Toy(
        name: "Legacy Core Optimus Prime",
        color: Faction.a.rgbcolor,
        faction: Faction.a,
        toyClass: ToyClass.core,
        toyline: "Legacy",
        releaseYear: 2022)
  ];

  final List<Toy> wishlistToys = [
    Toy(
        name: "Masterpiece Bumblebee",
        color: Faction.a.rgbcolor,
        faction: Faction.a,
        toyClass: ToyClass.masterpiece,
        toyline: "Masterpiece",
        releaseYear: 2023)
  ];

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

  void _handleNewItem(
      String name,
      Faction faction,
      ToyClass toyClass,
      String toyline,
      int releaseYear,
      double? price,
      String? notes,
      TextEditingController controller) {
    setState(() {
      print("Adding toy");
      final toy = Toy(
        name: name,
        color: faction.rgbcolor,
        faction: faction,
        toyClass: toyClass,
        toyline: toyline,
        releaseYear: releaseYear,
        price: price,
        notes: notes,
      );
      wishlistToys.insert(0, toy);
      controller.clear();
    });
  }

  void _sortToys() {
    setState(() {
      ownedToys.sort((a, b) => a
          .getSortKey(_currentSortOption)
          .compareTo(b.getSortKey(_currentSortOption)));
      wishlistToys.sort((a, b) => a
          .getSortKey(_currentSortOption)
          .compareTo(b.getSortKey(_currentSortOption)));
    });
  }

  // added another Listview in children
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transformers Collection'),
        actions: [
          PopupMenuButton<ToySortOption>(
            onSelected: (ToySortOption result) {
              setState(() {
                _currentSortOption = result;
                _sortToys();
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<ToySortOption>>[
              const PopupMenuItem<ToySortOption>(
                value: ToySortOption.name,
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem<ToySortOption>(
                value: ToySortOption.faction,
                child: Text('Sort by Faction'),
              ),
              const PopupMenuItem<ToySortOption>(
                value: ToySortOption.toyClass,
                child: Text('Sort by Class'),
              ),
              const PopupMenuItem<ToySortOption>(
                value: ToySortOption.toyline,
                child: Text('Sort by Toy Line'),
              ),
              const PopupMenuItem<ToySortOption>(
                value: ToySortOption.releaseYear,
                child: Text('Sort by Release Year'),
              ),
            ],
          ),
        ],
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
                        onListChanged: (toy, _) =>
                            _handleListChanged(toy, true),
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
                        onListChanged: (toy, _) =>
                            _handleListChanged(toy, false),
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
          }),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Transformer Collector',
    home: ToyList(),
  ));
}
