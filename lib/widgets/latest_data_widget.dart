import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/api/smart_classroom_sheets_api.dart';
import 'package:weather/screens/smart_classroom_data_screen.dart';
import 'package:weather/widgets/water_effect.dart';

class LatestDataWidget extends StatelessWidget {
  final List<String>? latestData;

  LatestDataWidget({required this.latestData});

  @override
  Widget build(BuildContext context) {
    return latestData != null
        ? Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Smart Classroom',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          final data =
                              await SmartClassroomSheetsApi.getAllData();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SmartClassroomDataDisplay(
                                data
                                    .map((list) => list ?? [])
                                    .toList(), // Handling null values
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Past trends...",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent),
                        ))
                  ],
                ),
                const SizedBox(height: 10.0),
                if (latestData!.isEmpty)
                  const Text('No data available')
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildDateAndTimeCard(
                          latestData![0], latestData![1], latestData![2]),
                      _buildTemperatureCard(latestData![3]),
                      HumidityCard(
                        data: latestData![4],
                      ),
                      _buildStudentsInsideRoomCard(latestData![5]),
                      _buildExhaustFanStatusCard(latestData![6]),
                    ],
                  ),
              ],
            ),
          )
        : const Center(
            child: SizedBox(
              height: 200,
              width: 200,
              child: CircularProgressIndicator(),
            ),
          );
  }

  Widget _buildDateAndTimeCard(String date, String time, String sensorStatus) {
    String formattedTime = _formatTime(time);
    String formattedDate = formatDateString(date);
    const label = 'Last Active';
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: SizedBox(
            height: 120,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              surfaceTintColor: Colors.transparent,
              elevation: 3.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      label,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          child: _buildSensorReadStatusCard(sensorStatus, time),
        ),
      ],
    );
  }

  Widget _buildSensorReadStatusCard(String data, String timeData) {
    DateTime currentTime = DateTime.now();
    String formattedTime = DateFormat('h:mm a').format(currentTime);

    String providedTime = _formatTime(timeData);

    bool isActive = formattedTime == providedTime;
    Color ledColor = isActive ? Colors.green : Colors.red;
    return SizedBox(
      height: 120,
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        surfaceTintColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Status',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    isActive ? "Active" : "Not active",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 40),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.bounceInOut,
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: ledColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ledColor.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 3,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTemperatureCard(String data) {
    const label = 'Temperature';
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              label,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              '$data° C',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsInsideRoomCard(String data) {
    const label = 'Students inside room';
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              data,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExhaustFanStatusCard(String data) {
    String fanAnimation = 'assets/smartClassroom/running_fan.gif';
    String exhaustFanImage = 'assets/smartClassroom/exhaust_fan.png';

    int runningFansCount = 0;
    List<String> fansToShow = [];

    switch (data) {
      case 'one_exhaust_ON':
        runningFansCount = 1;
        fansToShow = [fanAnimation, exhaustFanImage];
        break;
      case 'TWO_exhaust_ON':
        runningFansCount = 2;
        fansToShow = [fanAnimation, fanAnimation];
        break;
      case 'Exhaust_OFF':
        runningFansCount = 0;
        fansToShow = [exhaustFanImage, exhaustFanImage];
        break;
      default:
        runningFansCount = 0;
        fansToShow = [
          exhaustFanImage,
          exhaustFanImage
        ]; // Default to showing exhaust fans
        break;
    }

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exhaust fan status',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  runningFansCount > 0
                      ? '$runningFansCount fan${runningFansCount > 1 ? 's' : ''} running'
                      : 'No fan running',
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    for (int i = 0; i < 2; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            fansToShow[i],
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String timeData) {
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
}

String formatDateString(String serialNumber) {
  int serial = int.parse(serialNumber);
  DateTime startDate = DateTime(1899, 12, 30);
  DateTime targetDate = startDate.add(Duration(days: serial));
  String formattedDate =
      "${_getMonthName(targetDate.month)} ${targetDate.day}${_getDaySuffix(targetDate.day)}, ${targetDate.year}";
  return formattedDate;
}

String _getMonthName(int month) {
  switch (month) {
    case 1:
      return "Jan";
    case 2:
      return "Feb";
    case 3:
      return "Mar";
    case 4:
      return "Apr";
    case 5:
      return "May";
    case 6:
      return "Jun";
    case 7:
      return "Jul";
    case 8:
      return "Aug";
    case 9:
      return "Sep";
    case 10:
      return "Oct";
    case 11:
      return "Nov";
    case 12:
      return "Dec";
    default:
      return "";
  }
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}

class HumidityCard extends StatelessWidget {
  final String data;

  const HumidityCard({
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const label = 'Humidity';
    final double waterLevel = double.parse(data) / 100;

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      surfaceTintColor: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$data%',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: AnimatedWaterEffect(
              waterLevel: waterLevel,
              borderRadius: 12,
            ),
          ),
        ],
      ),
    );
  }
}
