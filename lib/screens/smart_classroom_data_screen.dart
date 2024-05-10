import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/widgets/line_graph.dart';

class SmartClassroomDataDisplay extends StatelessWidget {
  final List<List<String>> data;

  SmartClassroomDataDisplay(this.data);

  @override
  Widget build(BuildContext context) {
    final List<List<String>> last30Lists;
    if (data.length >= 30) {
      last30Lists = data.sublist(data.length - 30);
    } else {
      last30Lists = data;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Classroom Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LineChartSample1(data: last30Lists),
              const SizedBox(height: 20),
              Table(
                border: TableBorder.all(),
                children: const [
                  TableRow(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 204, 200, 200)),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Date',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Time',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 2),
                          child: Text(
                            'Sensor\nStatus',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 2),
                          child: Text(
                            'Temperature',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 2),
                          child: Text(
                            'Humidity',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 1),
                          child: Text(
                            'Students',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Running Exhausts',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 500,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Table(
                    border: TableBorder.all(),
                    children: [
                      for (var rowData in data)
                        TableRow(
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  formatDate(rowData[0]),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  formatTime(rowData[1]),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2),
                                child: Text(
                                  rowData[2],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${rowData[3]}°C',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${rowData[4]}%',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  rowData[5],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  getFanStatus(rowData[6]),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

String formatTime(String timeData) {
  double decimalTime = double.parse(timeData);
  int hours = (decimalTime * 24).floor();
  int minutes = ((decimalTime * 24 * 60) % 60).floor();
  String period = hours >= 12 ? 'PM' : 'AM';
  hours = hours % 12;
  if (hours == 0) {
    hours = 12;
  }
  return '$hours:${minutes.toString().padLeft(2, '0')} $period';
}

String formatDate(String dateString) {
  List<String> parts = dateString.split("/");
  int day = int.parse(parts[0]);
  int month = int.parse(parts[1]);
  int year = int.parse(parts[2]);

  DateTime date = DateTime(year, month, day);
  String formattedDate = DateFormat('d MMMM yyyy').format(date);

  formattedDate =
      '$day${_getOrdinalSuffix(day)} ${DateFormat('MMMM yyyy').format(date)}';

  return formattedDate;
}

String _getOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return 'th';
  }
  switch (day % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}

String getFanStatus(String fanStatus) {
  switch (fanStatus) {
    case "Exhaust_OFF":
      return "0";
    case "one_exhaust_ON":
      return "1";
    case "TWO_exhaust_ON":
      return "2";
    default:
      return "";
  }
}
