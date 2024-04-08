import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:test_home_screen_widgets/data/weather_data_provider.dart';
import 'package:test_home_screen_widgets/models/weather_model.dart';

const String appGroupId = 'group.example.testHomeScreenWidgets';
const String iOSWidgetName = 'WeatherWidgets';
const String androidWidgetName = 'WeatherWidgets';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WeatherApiDataProvider _dataProvider = WeatherApiDataProvider();

  final _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    // Set the group ID
    HomeWidget.setAppGroupId(appGroupId);
  }

  // New: add this function
  Future<void> updateWeather(
    WeatherModel weatherModel,
  ) async {
    await HomeWidget.saveWidgetData<String>('city_name', weatherModel.cityName);
    await HomeWidget.saveWidgetData<String>(
        'current_weather', weatherModel.currentWeather);
    await HomeWidget.saveWidgetData<String>('date', weatherModel.date);
    await HomeWidget.saveWidgetData<String>(
        'description', weatherModel.description);

    await HomeWidget.updateWidget(
      iOSName: iOSWidgetName,
      androidName: androidWidgetName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _dataProvider.getWeather(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
              ),
              body: const Center(
                child: Column(
                  children: [
                    Text('Загружаем данные'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          } else {
            updateWeather(snapshot.data as WeatherModel);

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      snapshot.data!.cityName,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      snapshot.data!.date,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      snapshot.data!.currentWeather,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      snapshot.data!.description,
                    ),
                    const SizedBox(height: 15),
                    if (snapshot.data!.iconPath != null)
                      SizedBox(
                        key: _globalKey,
                        child:
                            Image.network('https:${snapshot.data!.iconPath}'),
                      ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Updating home screen widget...'),
                  ));
                  if (_globalKey.currentContext != null &&
                      snapshot.data!.iconPath != null) {
                    await HomeWidget.renderFlutterWidget(
                      Image.network('https:${snapshot.data!.iconPath}'),
                      key: 'filename',
                      logicalSize: _globalKey.currentContext!.size!,
                      pixelRatio: MediaQuery.of(_globalKey.currentContext!)
                          .devicePixelRatio,
                    );
                    updateWeather(
                      snapshot.data as WeatherModel,
                    );
                  }
                },
                label: const Text('Update Homescreen'),
              ),
            );
          }
        });
  }
}
