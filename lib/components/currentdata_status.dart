import 'package:flutter/material.dart';
import 'package:ticketeasy/models/cards.dart';
import 'package:ticketeasy/theme/colors.dart';

class CurrentDataStatus extends StatelessWidget {
  final CCard card;
  final TextEditingController statusController;
  const CurrentDataStatus({Key? key, required this.card, required this.statusController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    statusController.text = card.Status; // Pre-fill with existing value
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
            Icons.info_outline,
            color: Colors.black,
            size: 25,
          ),
          SizedBox(width: 3),
          Text(
            "Status",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 80),
          Expanded(
            child: TextField(
              controller: statusController,
              decoration: InputDecoration(
                hintText: 'Enter status',
              ),
            ),
          ),
        ],
      ),
    );
  }
}