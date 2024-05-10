import 'package:weather/api/api_key.dart';

String apiURL(var lat, var lon) {
  String url;
  url =
      "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=mintuely&appid=$apiKey&units=metric";
  return url;
}
