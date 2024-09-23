import 'package:flutter/material.dart';

enum SideColor {
  a('Autobot', Color.fromARGB(255, 255, 0, 0)), 
  d('Decepticon', Color.fromARGB(255, 112, 79, 162)),
  o('Other', Color.fromARGB(255, 128, 128, 128));

  const SideColor(this.label, this.rgbcolor);
  final String label;
  final Color rgbcolor;
}

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
  final TextEditingController _colorController = TextEditingController();
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  SideColor? selectedColor = SideColor.o;

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
            decoration: const InputDecoration(hintText: "type toy name here"),
          ),
          DropdownMenu<SideColor>(
            initialSelection: SideColor.a,
            controller: _colorController,
            label: const Text('Faction'),
            onSelected: (SideColor? color) {
              setState(() {
                selectedColor = color;
              });
            },
            dropdownMenuEntries: SideColor.values.map<DropdownMenuEntry<SideColor>>((SideColor color) {
              return DropdownMenuEntry<SideColor>(
                value: color,
                label: color.label,
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
                        widget.onListAdded(valueText, selectedColor!.rgbcolor, _inputController);
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
