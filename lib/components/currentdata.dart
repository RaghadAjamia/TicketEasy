import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticketeasy/models/cards.dart';
import 'package:ticketeasy/theme/colors.dart';

class CurrentData extends StatefulWidget {
  final CCard card;
  final TextEditingController complexController;
  const CurrentData({Key? key, required this.card, required this.complexController}) : super(key: key);

  @override
  _CurrentDataState createState() => _CurrentDataState();
}

class _CurrentDataState extends State<CurrentData> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    widget.complexController.text = widget.card.Complex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: bluee.withOpacity(0.12),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.all(25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            color: Colors.black,
            size: 25,
          ),
          SizedBox(width: 3),
          Text(
            "Complex",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 60),
          Expanded(
            child: TextField(
              controller: widget.complexController,
              inputFormatters: [ComplexInputFormatter()],
              decoration: InputDecoration(
                hintText: 'Enter complex',
                errorText: _errorText,
              ),
              onChanged: (text) {
                setState(() {
                  _errorText = null; 
                });
              },
              onEditingComplete: () {
                final text = widget.complexController.text;
                if (!_isValidComplex(text)) {
                  setState(() {
                    _errorText = 'Invalid input';
                  });
                } else {
                  setState(() {
                    _errorText = null;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidComplex(String text) {
    final RegExp regExp = RegExp(r'^(JUST|Amman|on way|-)$');
    return regExp.hasMatch(text);
  }
}

class ComplexInputFormatter extends TextInputFormatter {
  final RegExp _partialRegExp = RegExp(r'^(JUST|Amman|on way|-|J|JU|JUS|A|Am|Amm|Amma|Amman|o|on|on |on w|on wa|on way|-)?$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_partialRegExp.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
