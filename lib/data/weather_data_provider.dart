import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_home_screen_widgets/models/weather_model.dart';

final class WeatherApiDataProvider {
  Future<WeatherModel> getWeather() async {
    final dio = Dio();
    final response = await dio
        .get('http://api.weatherapi.com/v1/current.json', queryParameters: {
      'key': dotenv.env['API_KEY'],
      'q': 'Омск',
      'lang': 'ru',
    });

    return WeatherModel.fromJson(response.data);
  }
}
