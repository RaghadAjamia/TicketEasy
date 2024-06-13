import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ticketeasy/models/tickets.dart';

class WeeklyTicketsChartWidget extends StatelessWidget {
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

          Map<int, int> ticketsPerDay = {7: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0};

          for (var ticket in tickets) {
            int dayOfWeek = ticket.getTime.toDate().weekday;
            ticketsPerDay[dayOfWeek] = (ticketsPerDay[dayOfWeek] ?? 0) + 1;
          }

          List<ChartData> chartData = ticketsPerDay.entries
              .map((entry) => ChartData(entry.key, entry.value))
              .toList();

          return SfCartesianChart(
            primaryXAxis: CategoryAxis(
              title: AxisTitle(
                text: "Days of the Week",
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
              maximum: 50,
              interval: 10,
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
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => _dayOfWeekToString(data.day),
                yValueMapper: (ChartData data, _) => data.tickets,
                name: 'Tickets',
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                width: 0.6,
                spacing: 0.0,
                dataLabelSettings: DataLabelSettings(isVisible: true),
              ),
            ],
          );
        },
      ),
    );
  }

  String _dayOfWeekToString(int day) {
    switch (day) {
      case 7:
        return "Su";
      case 1:
        return "M";
      case 2:
        return "Tu";
      case 3:
        return "W";
      case 4:
        return "Th";
      case 5:
        return "F";
      case 6:
        return "Sa";
      default:
        return "";
    }
  }
}

class ChartData {
  final int day;
  final int tickets;

  ChartData(this.day, this.tickets);
}
