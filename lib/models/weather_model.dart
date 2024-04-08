final class WeatherModel {
  final String cityName;
  final String currentWeather;
  final String? iconPath;
  final String date;
  final String description;

  const WeatherModel({
    this.cityName = 'City name placeholder',
    this.currentWeather = 'Current weather placeholder',
    this.iconPath,
    this.date = '2024-02-18',
    this.description = 'Description placeholder',
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'].toString(),
      date: json['location']['localtime'].toString(),
      currentWeather: json['current']['temp_c'].toString(),
      description: json['current']['condition']['text'].toString(),
      iconPath: json['current']['condition']['icon'].toString(),
    );
  }

  WeatherModel copyWith({
    String? cityName,
    String? currentWeather,
    String? iconPath,
    String? date,
    String? description,
  }) {
    return WeatherModel(
      cityName: cityName ?? this.cityName,
      currentWeather: currentWeather ?? this.currentWeather,
      iconPath: iconPath ?? this.iconPath,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}
