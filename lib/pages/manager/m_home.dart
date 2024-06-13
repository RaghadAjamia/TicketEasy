import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticketeasy/components/appBar.dart';
import 'package:ticketeasy/components/m_BNB.dart';
import 'package:ticketeasy/theme/colors.dart';
import 'package:ticketeasy/components/m_cards.dart';
import 'package:ticketeasy/models/cards.dart';
import 'package:ticketeasy/pages/manager/m_businfo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarWidget(title: "Explore Buses"),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color.fromARGB(136, 242, 242, 242),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.search, color: gray),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search by the bus number',
                          hintStyle: TextStyle(color: gray.withOpacity(0.7)),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Buses').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  final cardMenu = snapshot.data!.docs;

                  final filteredCards = cardMenu.where((doc) {
                    var data = doc.data() as Map<String, dynamic>;
                    var busNumber = (data['id'] ?? '').toString();
                    return busNumber.contains(searchQuery);
                  }).toList();

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 28,
                      mainAxisSpacing: 20,
                      childAspectRatio: 2.5 / 2,
                    ),
                    itemCount: filteredCards.length,
                    itemBuilder: (context, index) {
                      var data = filteredCards[index].data() as Map<String, dynamic>;
                      var card = CCard(
                      Complex: data['Complex'] ?? '', // Ensure a default value
              Status: data['Status'] ?? '', // Ensure a default value
              BusNumber: (data['id'] ?? '').toString(), // Ensure a string value
              Bus_Num: data['Bus_Num'] ?? '', // Ensure a default value
              Seats_Num: data['Seats_Num'] ?? 0, // Ensure a default value
                      );
                      return ManagerCards(
                        onTap: () => navigateToBusInfo(filteredCards[index].id),
                        card: card,
                        documentId: filteredCards[index].id,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidgetM(),
    );
  }

  void navigateToBusInfo(String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoPage(documentId: documentId),
      ),
    );
  }
}
