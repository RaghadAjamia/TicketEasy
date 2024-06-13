import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ticketeasy/models/tickets.dart';

class TicketsChartWidget extends StatelessWidget {
  final CollectionReference ticketsCollection =
      FirebaseFirestore.instance.collection('Tickets_Info');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 700, 
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.10),
              blurRadius: 20,
              offset: Offset(10, 25),
            ),
          ],
        ),
        padding: EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: ticketsCollection
              .where('Date', isEqualTo: DateFormat('yyyy-MM-dd').format(DateTime.now()))
              .snapshots(),
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

            Map<int, int> ticketsPerHour = {};
            for (var ticket in tickets) {
              int hour = ticket.getTime.toDate().hour;
              if (hour >= 00 && hour <= 24) {
                ticketsPerHour[hour] = (ticketsPerHour[hour] ?? 0) + 1;
              }
            }

            List<ChartData> chartData = ticketsPerHour.entries
                .map((entry) => ChartData(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, entry.key), entry.value))
                .toList();

            return SfCartesianChart(
              primaryXAxis: DateTimeAxis(
                minimum: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 00),
                maximum: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 24),
                intervalType: DateTimeIntervalType.hours,
                interval: 1, 
                dateFormat: DateFormat.j(),
                title: AxisTitle(
                  text: "Time",
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(149, 0, 0, 0),
                    fontSize: 12,
                  ),
                ),
              ),
              primaryYAxis: NumericAxis(
                minimum: 0,
                maximum: 20,
                interval: 5,
                title: AxisTitle(
                  text: "Number of Tickets",
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
                LineSeries<ChartData, DateTime>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.time,
                  yValueMapper: (ChartData data, _) => data.tickets,
                  name: 'Tickets',
                  color: Colors.orange, 
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ChartData {
  final DateTime time;
  final int tickets;

  ChartData(this.time, this.tickets);
}
