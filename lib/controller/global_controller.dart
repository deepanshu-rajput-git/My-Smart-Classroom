import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather/api/fetch_weather.dart';
import 'package:weather/api/smart_classroom_sheets_api.dart';
import 'package:weather/model/weather/weather_data.dart';

class GlobalController extends GetxController {
  //Create various values
  final RxBool _isLoading = true.obs;
  final RxDouble _lattitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  // Creating instance for them to be called
  RxBool checkLoading() => _isLoading;
  RxDouble getLattitude() => _lattitude;
  RxDouble getlongitude() => _longitude;

  final weatherData = WeatherData().obs;
  WeatherData getData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    } else {
      getIndex();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;
    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    await SmartClassroomSheetsApi.init();
    //return is Service is not enabled
    if (!isServiceEnabled) {
      return Future.error('"Location Not Enabled');
    }
    //Status of permission
    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error("Location Permission Are Denied forever");
    } else if (locationPermission == LocationPermission.denied) {
      // request a new permission
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return Future.error("Location permission is denied");
      }
    }

    // Getting the current position
    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      //Update our latitude and longitude
      _lattitude.value = value.latitude;
      _longitude.value = value.longitude;

      //calling weather api
      return FetchWeatherAPI()
          .processData(value.latitude, value.longitude)
          .then((value) {
        weatherData.value = value;
        _isLoading.value = false;
      });
    });
  }

  RxInt getIndex() {
    return _currentIndex;
  }
}
