import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ticketeasy/models/tickets.dart';
import 'package:intl/intl.dart';

class MonthlyProfitChartWidget extends StatelessWidget {
  final CollectionReference ticketsCollection =
      FirebaseFirestore.instance.collection('Tickets_Info');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.10),
            blurRadius: 20,
            offset: Offset(0, 25),
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

          List<Tickets> tickets = snapshot.data!.docs.map((doc) {
            return Tickets.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          
                  int totalTicketsSold = snapshot.data!.docs.length;
                  double totalPrice = totalTicketsSold * 1.15; 
          Map<String, double> profitPerMonth = {};

          for (var ticket in tickets) {
            String monthYear = DateFormat('MMM yyyy').format(ticket.getTime.toDate());
            profitPerMonth[monthYear] = (profitPerMonth[monthYear] ?? 0) + 1.15;
          }

          List<ChartData> chartData = profitPerMonth.entries
              .map((entry) => ChartData(entry.key, entry.value))
              .toList();

          return SfCartesianChart(
            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                text: "Month",
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(149, 0, 0, 0),
                  fontSize: 12,
                ),
              ),
              labelsExtent: 15,
              majorGridLines: MajorGridLines(width: 0),
              interval: 1,
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              interval: 100,
              title: AxisTitle(
                text: "Profit (JD)",
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(149, 0, 0, 0),
                  fontSize: 12,
                ),
              ),
            ),
            legend: Legend(isVisible: false),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.month,
                yValueMapper: (ChartData data, _) => data.profit,
                name: 'Profit',
                color: Colors.orange,
                dataLabelSettings: DataLabelSettings(isVisible: true),
                markerSettings: MarkerSettings(isVisible: true), 
              ),
            ],
          );
        },
      ),
    );
  }
}

class ChartData {
  final String month;
  final double profit;

  ChartData(this.month, this.profit);
}
