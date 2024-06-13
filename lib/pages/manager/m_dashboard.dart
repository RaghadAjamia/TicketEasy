import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ticketeasy/components/appBar.dart';
import 'package:ticketeasy/components/m_BNB.dart';
import 'package:ticketeasy/models/tickets.dart';
import 'package:ticketeasy/components/ticket_chart.dart'; 
import 'package:ticketeasy/components/ticket_chart2.dart'; 
import 'package:ticketeasy/components/ticket_chart3.dart'; 

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CollectionReference ticketsCollection =
      FirebaseFirestore.instance.collection('Tickets_Info');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Dashboard"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // The first box in the dashboard (number of sold tickets and their price)
            Text(
              "     Sold tickets",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromARGB(183, 79, 77, 77),
              ),
            ),
            SizedBox(height: 3),
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.10),
                    blurRadius: 10,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: StreamBuilder<QuerySnapshot>(
                stream: ticketsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No tickets found"));
                  }

                  int totalTicketsSold = snapshot.data!.docs.length;
                  double totalPrice = totalTicketsSold * 1.15; // Adjust if you have different logic for calculating total price

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            totalTicketsSold.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            "# of tickets",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(149, 0, 0, 0),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "${totalPrice.toStringAsFixed(2)} JD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            "Total Price",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(149, 0, 0, 0),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 45),
            // The second box (and the first chart: daily tickets sales trends)
            Text(
              "     Sales Trends",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromARGB(183, 79, 77, 77),
              ),
            ),
            SizedBox(height: 3),
            TicketsChartWidget(),
            SizedBox(height: 45),
            // The third box (weekly tickets sales trends)
            Text(
              "      Weekly Trends",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromARGB(183, 79, 77, 77),
              ),
            ),
            SizedBox(height: 3),
            WeeklyTicketsChartWidget(),
            SizedBox(height: 45),
            // The fourth box (monthly profit  trends)
            Text(
              "      Monthly Profit Trends",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color.fromARGB(183, 79, 77, 77),
              ),
            ),
            SizedBox(height: 3),
            MonthlyProfitChartWidget(),
            SizedBox(height: 45),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidgetM(),
    );
  }
}
