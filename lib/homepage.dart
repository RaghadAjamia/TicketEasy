import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ticketeasy/bottom_navigation_bar_widget.dart';
import 'package:ticketeasy/models/cards.dart'; // Import your CCard model
import 'package:ticketeasy/u_homepage_card.dart'; // Adjust the import path as necessary

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String dropdownValueFrom = 'JUST'; // Changed default value to 'JUST'
  List<String> itemsList = ['JUST', 'Amman']; // Only two options
  String selectedItem = 'Amman'; // Initial value for the text field
  String? username;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          username = userDoc['username'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'images/Mask.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200, // Increase the height to make the image larger
                ),
              ),
              const SizedBox(height: 27),
              Text(
                username != null
                    ? "Hello $username ,\nChoose your destination"
                    : "Hello ,\nChoose your destination",
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: "Outfit",
                  color: Color(0xFF59597C),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: dropdownValueFrom,
                    items: itemsList
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 92, 92, 124),
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (item) {
                      setState(() {
                        dropdownValueFrom = item!;
                        selectedItem = item == 'JUST' ? 'Amman' : 'JUST';
                      });
                    },
                  ),
                  const Text(
                    "to",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Outfit",
                      color: Color.fromARGB(255, 92, 92, 124),
                    ),
                  ),
                  Text(
                    selectedItem,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Outfit",
                      color: Color.fromARGB(255, 92, 92, 124),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              buildCardList(dropdownValueFrom),
            ],
          ),
        ),
      ),
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: BottomNavigationBarWidget(
        tickets: [],
      ),
    );
  }

  // Function to build the list of cards based on dropdown value
  Widget buildCardList(String dropdownValueFrom) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Buses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final cardMenu = snapshot.data!.docs;

        // Filter and sort the cardMenu based on status
        final filteredAndSortedCards = cardMenu.where((document) {
          var data = document.data() as Map<String, dynamic>;
          var complex = data['Complex'] ?? '';
          if (dropdownValueFrom == 'JUST') {
            return complex == 'JUST';
          } else if (dropdownValueFrom == 'Amman') {
            return complex == 'Amman';
          }
          return false;
        }).toList()
          ..sort((a, b) {
            var aData = a.data() as Map<String, dynamic>;
            var bData = b.data() as Map<String, dynamic>;
            var aStatus = aData['Status'] ?? '';
            var bStatus = bData['Status'] ?? '';
            if (aStatus == 'Open' && bStatus != 'Open') {
              return -1; // a should come before b
            } else if (aStatus != 'Open' && bStatus == 'Open') {
              return 1; // b should come before a
            } else {
              return 0; // no change in order
            }
          });

        return Column(
          children: filteredAndSortedCards.map((document) {
            var data = document.data() as Map<String, dynamic>;
            var card = CCard(
              Complex: data['Complex'] ?? '', // Ensure a default value
              Status: data['Status'] ?? '', // Ensure a default value
              BusNumber: (data['id'] ?? '').toString(), // Ensure a string value
              Bus_Num: data['Bus_Num'] ?? '', // Ensure a default value
              Seats_Num: data['Seats_Num'] ?? 0, // Ensure a default value
            );
            return UserHpCards(
              card: card,
              documentId: document.id,
            );
          }).toList(),
        );
      },
    );
  }

  // Function to build the floating action button
  Widget buildFloatingActionButton(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Aligns the FAB to the center of the row
      children: [
        SizedBox(width: 30), // Adds a slight space to the left of the FAB
        Container(
          width: 200,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.orange.withOpacity(0.2), // Increased shadow opacity
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 5), // Changed position of shadow
              ),
            ],
            gradient: RadialGradient(
              colors: [
                Color(0xFFFE9B4B), // Gold color
                Color(0xFFF47814), // Orange color
              ],
            ),
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed('Purchase');
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Text(
              'Buy Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
