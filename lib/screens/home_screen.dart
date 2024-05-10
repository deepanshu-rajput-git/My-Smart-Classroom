import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/api/smart_classroom_sheets_api.dart';
import 'package:weather/controller/global_controller.dart';
import 'package:weather/utils/custom_colors.dart';
import 'package:weather/widgets/comfort_level.dart';
import 'package:weather/widgets/current_weather_widget.dart';
import 'package:weather/widgets/daily_data_forecast.dart';
import 'package:weather/widgets/header_widgets.dart';
import 'package:weather/widgets/hourly_data_widget.dart';
import 'package:weather/widgets/latest_data_widget.dart';

class HomeScreen extends StatelessWidget {
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => globalController.checkLoading().isTrue
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/smartClassroom/smart_classroom.png",
                        height: 250,
                        width: 250,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                )
              : Center(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await globalController.getLocation();
                    },
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        const SizedBox(height: 20),
                        const HeaderWidget(),
                        CurrentWeatherWidget(
                          weatherDataCurrent:
                              globalController.getData().getCurrrentWeather(),
                        ),
                        const SizedBox(height: 20),
                        HourlyDataWidget(
                          weatherDataHourly:
                              globalController.getData().getHourlyWeather(),
                        ),
                        const SizedBox(height: 20),
                        FutureBuilder<List<String>?>(
                          future: SmartClassroomSheetsApi.getLatestData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return LatestDataWidget(
                                latestData: snapshot.data,
                              );
                            }
                          },
                        ),
                        DailyDataForecast(
                          weatherDataDaily:
                              globalController.getData().getDailyWeather(),
                        ),
                        Container(
                          height: 1,
                          color: CustomColors.dividerLine,
                        ),
                        const SizedBox(height: 10),
                        ComfortLevel(
                          weatherDataCurrent:
                              globalController.getData().getCurrrentWeather(),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
