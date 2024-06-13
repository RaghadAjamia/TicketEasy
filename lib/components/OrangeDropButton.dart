import 'package:flutter/material.dart';
import 'package:ticketeasy/theme/colors.dart';

class OButton extends StatefulWidget {
  final Function(String)? onSelected;
  final List<String> options;
  final String initialValue;
  const OButton({
    Key? key,
    this.onSelected,
    required this.options,
    required this.initialValue,
  }) : super(key: key);

  @override
  _OButtonState createState() => _OButtonState();
}

class _OButtonState extends State<OButton> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    assert(
      widget.options.contains(widget.initialValue),
      'Initial value must be one of the options',
    );
    dropdownValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: orangee,
        borderRadius: BorderRadius.circular(13),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        iconSize: 24,
        elevation: 10,
        style: const TextStyle(color: Color.fromARGB(255, 44, 7, 7)),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue ?? '';
            widget.onSelected?.call(dropdownValue);
          });
        },
        items: widget.options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              decoration: BoxDecoration(
                color: orangee,
                borderRadius: BorderRadius.circular(18),
              ), // White background for each option
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                value,
                style:
                    const TextStyle(color: Color.fromARGB(255, 251, 250, 250)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
