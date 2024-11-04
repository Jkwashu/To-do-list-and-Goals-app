import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/toy.dart';


typedef ToyListAddedCallback = Function(
    String value, Color color, TextEditingController textConroller);

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
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _factionController = TextEditingController();
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  Faction? selectedFaction = Faction.a;

  String valueText = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add a New Toy'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _inputController,
            decoration: const InputDecoration(hintText: "Type toy name here"),
          ),
          const SizedBox(height: 12),
          DropdownMenu<Faction>(
            initialSelection: Faction.a,
            controller: _factionController,
            label: const Text('Faction'),
            onSelected: (Faction? faction) {
              setState(() {
                selectedFaction = faction;
              });
            },
            dropdownMenuEntries: Faction.values.map<DropdownMenuEntry<Faction>>((Faction faction) {
              return DropdownMenuEntry<Faction>(
                value: faction,
                label: faction.label,
              );
            }).toList(),
          ),
        ]  
      ), 
      actions: <Widget>[
        ElevatedButton(
          key: const Key("CancelButton"),
          style: noStyle,
          child: const Text('Cancel'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),

        // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _inputController,
          builder: (context, value, child) {
            return ElevatedButton(
              key: const Key("OKButton"),
              style: yesStyle,
              onPressed: value.text.isNotEmpty
                  ? () {
                      setState(() {
                        widget.onListAdded(valueText, selectedFaction!.rgbcolor, _inputController);
                        Navigator.pop(context);
                      });
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
