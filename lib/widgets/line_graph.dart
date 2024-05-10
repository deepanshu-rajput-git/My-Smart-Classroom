import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:weather/utils/app_colors.dart';

class LineChartSample1 extends StatefulWidget {
  final List<List<String>> data;
  const LineChartSample1({
    required this.data,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;
  final List<double> temperatures = [];
  final List<double> humidities = [];
  final List<String> times = [];
  final List<int> noOfFans = [];
  final List<int> noOfStudents = [];

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
    for (final row in widget.data) {
      final time = double.tryParse(row[1]) ?? 0.0;
      final temperature = double.tryParse(row[3]) ?? 0.0;
      final humidity = double.tryParse(row[4]) ?? 0.0;
      final students = int.tryParse(row[5]) ?? 0;
      final fans = row[6];
      temperatures.add(temperature);
      humidities.add(humidity);
      times.add(parseTime(time));
      noOfStudents.add(students);
      if (fans == "Exhaust_OFF") {
        noOfFans.add(0);
      } else if (fans == "one_exhaust_ON") {
        noOfFans.add(1);
      } else if (fans == "TWO_exhaust_ON") {
        noOfFans.add(2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Past Trends',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 37,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 2,
                    left: 2,
                  ),
                  child: _LineChart(
                      isShowingMainData: isShowingMainData,
                      data: widget.data,
                      temperatures: temperatures,
                      humidities: humidities,
                      times: times,
                      noOfFans: noOfFans,
                      noOfStudents: noOfStudents),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.blueGrey,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart(
      {required this.isShowingMainData,
      required this.data,
      required this.humidities,
      required this.temperatures,
      required this.times,
      required this.noOfFans,
      required this.noOfStudents});

  final bool isShowingMainData;
  final List<List<String>?> data;
  final List<double>? humidities;
  final List<double>? temperatures;
  final List<String>? times;
  final List<int>? noOfFans;
  final List<int>? noOfStudents;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1500,
        child: LineChart(
          sampleData1,
          duration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }

  LineChartData get sampleData1 {
    return LineChartData(
      lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: titlesData1,
      borderData: borderData,
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: AppColors.contentColorGreen,
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: List.generate(
            temperatures!.length,
            (index) => FlSpot(index.toDouble(), temperatures![index]),
          ),
        ),
        LineChartBarData(
          isCurved: true,
          color: AppColors.contentColorCyan,
          barWidth: 2,
          isStrokeCapRound: false,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          spots: List.generate(
            humidities!.length,
            (index) => FlSpot(index.toDouble(), humidities![index]),
          ),
        ),
      ],
      minX: 0,
      maxX: data.length.toDouble(),
      maxY: 100,
      minY: 0,
    );
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (touchedSpots) =>
              touchedSpots.map((LineBarSpot touchedSpot) {
            final textStyle = TextStyle(
              color: touchedSpot.bar.gradient?.colors.first ??
                  touchedSpot.bar.color ??
                  Colors.blueGrey,
              fontWeight: FontWeight.bold,
              fontSize: 8,
            );

            final String time = times![touchedSpot.x.toInt()];
            final int students = noOfStudents![touchedSpot.x.toInt()];
            final int fans = noOfFans![touchedSpot.x.toInt()];

            final String tooltipText = touchedSpot.barIndex == 0
                ? 'Temperature: ${touchedSpot.y.toString()} °C' // Temperature
                : 'Time: $time\nHumidity: ${touchedSpot.y.toString()}%\nNo. of students: $students\nRunning Exhausts: $fans'; // Humidity

            return LineTooltipItem(tooltipText, textStyle,
                textAlign: TextAlign.start);
          }).toList(),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, _) {
            final index = ((value).toInt());
            if (index >= 0 && index < data.length) {
              return Text(
                times![index].substring(0, 5),
                style: const TextStyle(fontSize: 8),
              );
            }
            return Container();
          },
        )),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true, // Set to true to show titles
            getTitlesWidget: (value, _) {
              return Text(
                value.toString(),
                style:
                    const TextStyle(fontSize: 8), // Adjust font size as needed
              );
            },
          ),
        ),
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, _) {
            return Text(" ");
          },
        )),
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom:
              BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
          left: BorderSide(color: AppColors.primary.withOpacity(0.2), width: 4),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );
}

String parseTime(double decimalTime) {
  int totalMinutes = (decimalTime * 24 * 60).toInt();
  int hours = totalMinutes ~/ 60;
  int minutes = totalMinutes % 60;

  String formattedTime =
      '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';

  return formattedTime;
}
