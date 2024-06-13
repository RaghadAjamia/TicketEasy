import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> populateFirestore() async {
  CollectionReference managers = FirebaseFirestore.instance.collection('managers');
  CollectionReference admins = FirebaseFirestore.instance.collection('admins');

  // Check if the managers collection is already populated
  QuerySnapshot managersSnapshot = await managers.get();
  if (managersSnapshot.docs.isEmpty) {
    await managers.add({
      'id': 'Saleem',
      'password': 'Saleem123123',
    });
    await managers.add({
      'id': 'Omar',
      'password': 'Omar123123',
    });
  } else {
    print("Managers collection is already populated");
  }

  // Check if the admins collection is already populated
  QuerySnapshot adminsSnapshot = await admins.get();
  if (adminsSnapshot.docs.isEmpty) {
    List<Map<String, String>> adminData = [
      {'id': 'ahmad', 'password': 'ahmad123'},
      {'id': 'ali', 'password': 'ali123'},
      {'id': 'mohammad', 'password': 'mohammad123'},
      {'id': 'yousef', 'password': 'yousef123'},
      {'id': 'ibrahim', 'password': 'ibrahim123'},
      {'id': 'mahmoud', 'password': 'mahmoud123'},
      {'id': 'khaled', 'password': 'khaled123'},
      {'id': 'abdallah', 'password': 'abdallah123'},
      {'id': 'sami', 'password': 'sami123'},
      {'id': 'hasan', 'password': 'hasan123'},
    ];

    for (var admin in adminData) {
      await admins.add(admin);
    }
  } else {
    print("Admins collection is already populated");
  }

  print("Managers and Admins added to Firestore");
}
