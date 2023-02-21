import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

const List<Widget> options = <Widget>[
  Text('Achievements'),
  Text('Borders'),
];

class CustomScreen extends StatefulWidget {
  const CustomScreen({super.key});

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  final List<bool> _selectedOptions = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ToggleButtons(
            children: options,
            isSelected: _selectedOptions,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.red[700],
            selectedColor: Colors.white,
            fillColor: Colors.red[200],
            color: Colors.red[400],
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            onPressed: (int index) {
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int i = 0; i < _selectedOptions.length; i++) {
                  _selectedOptions[i] = i == index;
                }
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3 - 10,
                height: 75,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 30),
                    )), //general screen,
              ),
              SizedBox(
                width: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3 - 10,
                height: 75,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 30),
                    )), //general screen,
              ),
            ],
          )
        ],
      ),
    );
  }
}
