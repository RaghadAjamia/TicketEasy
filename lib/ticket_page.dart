import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketeasy/bottom_navigation_bar_widget.dart';
import 'package:ticketeasy/ticket_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class TicketPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Purchased Tickets",
          style: TextStyle(
            color: Color(0xFF59597C),
            fontFamily: "Inter",
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/logo.png',
              width: 53,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: TicketList(userId: user!.uid),
      bottomNavigationBar: BottomNavigationBarWidget(tickets: [],),
    );
  }
}

class TicketList extends StatelessWidget {
  final String userId;

  TicketList({required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Tickets_Info')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No tickets available'));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final ticket = snapshot.data!.docs[index];
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Tickets_Info')
                  .doc(ticket.id)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox.shrink();
                }

                final ticketData = snapshot.data!.data() as Map<String, dynamic>;
                final bool scanned = ticketData['scanned'] ?? false;

                if (scanned) {
                  return SizedBox.shrink();
                }

                return TicketCard(
                  purchasedDate: ticketData['Date'],
                  qrCodeData: ticketData['qrCodeData'],
                );
              },
            );
          },
        );
      },
    );
  }
}