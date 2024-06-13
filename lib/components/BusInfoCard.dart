import 'package:flutter/material.dart';
import 'package:ticketeasy/models/cards.dart';
import 'package:ticketeasy/theme/colors.dart';

class infocards extends StatelessWidget {
  final CCard card;
  const infocards({super.key, required this.card});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: bluee.withOpacity(0.12),
            blurRadius: 50,
            offset: Offset(0, 15),
          ),
        ],
      ),
      margin: const EdgeInsets.only(left:8),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "   Bus #" + card.BusNumber,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const SizedBox(width: 15),
              Text(
                "Bus Number ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF59597C),
                    fontSize: 14),
              ),
              const SizedBox(width: 20),
              Text(
                "Seats Number",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF59597C),
                    fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 30),
              Text(
                card.Bus_Num,
                style: TextStyle(color: Color(0xFF59597C), fontSize: 14),
              ),
              const SizedBox(width: 60),
              Text(
  card.Seats_Num.toString(),
                style: TextStyle(color: Color(0xFF59597C), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}