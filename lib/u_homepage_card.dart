import 'package:flutter/material.dart';
import 'package:ticketeasy/models/cards.dart';

class UserHpCards extends StatelessWidget {
  final CCard card;
  final String documentId;
  final void Function()? onTap;

  const UserHpCards({
    Key? key,
    required this.card,
    required this.documentId,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor = card.Status == 'Open' ? Colors.green : Colors.red;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blue
                .withOpacity(0.18), // Corrected the reference to blue color
            blurRadius: 15,
            offset: Offset(0, 10),
          ),
        ],
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                " Bus Number #${card.BusNumber}",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 92, 92, 124),
                ),
              ),
              Text(
                "1.15 JOD",
                style: TextStyle(
                  color: Color.fromARGB(255, 92, 92, 124),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 247, 235),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Bus seats number: ${card.Seats_Num}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.orange,
                  ),
                ),
              ),
              SizedBox(width: 85), // Added space between the two Text widgets
              Text(
                card.Status,
                style: TextStyle(
                  color: statusColor, // Use statusColor here
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
