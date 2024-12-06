import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/toy.dart';

typedef ToyListAddedCallback = Function(
    String name,
    Faction faction,
    ToyClass toyClass,
    String toyline,
    int releaseYear,
    double? price,
    String? notes,
    TextEditingController textController);

class ToyDialog extends StatefulWidget {
  const ToyDialog({
    super.key,
    required this.onListAdded,
  });

  final ToyListAddedCallback onListAdded;

  @override
  State<ToyDialog> createState() => _ToyDialogState();
}

class _ToyDialogState extends State<ToyDialog> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _toylineController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  Faction? selectedFaction = Faction.a;
  ToyClass? selectedClass = ToyClass.deluxe;
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a New Toy'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  // Update state to trigger rebuild
                });
              },
              decoration: const InputDecoration(labelText: 'Toy Name'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Faction>(
              value: selectedFaction,
              decoration: const InputDecoration(labelText: 'Faction'),
              items: Faction.values.map((faction) {
                return DropdownMenuItem(
                  value: faction,
                  child: Text(faction.label),
                );
              }).toList(),
              onChanged: (Faction? value) {
                setState(() {
                  selectedFaction = value;
                });
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ToyClass>(
              value: selectedClass,
              decoration: const InputDecoration(labelText: 'Class'),
              items: ToyClass.values.map((toyClass) {
                return DropdownMenuItem(
                  value: toyClass,
                  child: Text(toyClass.toString().split('.').last),
                );
              }).toList(),
              onChanged: (ToyClass? value) {
                setState(() {
                  selectedClass = value;
                });
              },
            ),
            TextField(
              controller: _toylineController,
              onChanged: (value) {
                setState(() {
                  // Update state to trigger rebuild
                });
              },
              decoration: const InputDecoration(labelText: 'Toy Line'),
            ),
            TextField(
              controller: _yearController,
              onChanged: (value) {
                setState(() {
                  // Update state to trigger rebuild
                });
              },
              decoration: const InputDecoration(labelText: 'Release Year'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _priceController,
              onChanged: (value) {
                setState(() {
                  // Update state to trigger rebuild
                });
              },
              decoration: const InputDecoration(labelText: 'Price (Optional)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _notesController,
              onChanged: (value) {
                setState(() {
                  // Update state to trigger rebuild
                });
              },
              decoration: const InputDecoration(labelText: 'Notes (Optional)'),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          key: const Key("CancelButton"),
          style: noStyle,
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _nameController,
          builder: (context, value, child) {
            return ElevatedButton(
              key: const Key("OKButton"),
              style: yesStyle,
              onPressed: value.text.isNotEmpty &&
                      _toylineController.text.isNotEmpty &&
                      _yearController.text.isNotEmpty &&
                      selectedFaction != null &&
                      selectedClass != null
                  ? () {
                      widget.onListAdded(
                        _nameController.text,
                        selectedFaction!,
                        selectedClass!,
                        _toylineController.text,
                        int.parse(_yearController.text),
                        _priceController.text.isNotEmpty
                            ? double.parse(_priceController.text)
                            : null,
                        _notesController.text.isNotEmpty
                            ? _notesController.text
                            : null,
                        _nameController,
                      );
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text('OK'),
            );
          },
        ),
      ],
    );
  }
}
