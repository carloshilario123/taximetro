/*import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(TaxiMeterApp());
}

class TaxiMeterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Meter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaxiMeterPage(),
    );
  }
}

class TaxiMeterPage extends StatefulWidget {
  @override
  _TaxiMeterPageState createState() => _TaxiMeterPageState();
}

class _TaxiMeterPageState extends State<TaxiMeterPage> {
  double distance = 0.0;
  double fare = 0.0;
  double ratePerKm = 0.0;
  List<Map<String, String>> ranges = [];
  Map<String, String> nightTariff = {};
  bool isRunning = false;
  Position? currentPosition;
  Position? previousPosition;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    fetchRate(); // Fetch the initial rate
  }

  void getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  void startTrip() {
    setState(() {
      distance = 0.0;
      fare = 0.0;
      isRunning = true;
      previousPosition = currentPosition;
    });
  }

  void endTrip() {
    setState(() {
      isRunning = false;
    });
  }

  void calculateDistance() {
    double deltaDistance = Geolocator.distanceBetween(
      previousPosition!.latitude,
      previousPosition!.longitude,
      currentPosition!.latitude,
      currentPosition!.longitude,
    );
    setState(() {
      distance += deltaDistance / 1000; // Convert to kilometers
      fare = calculateFare(distance);
      previousPosition = currentPosition;
    });
  }

  Future<void> fetchRate() async {
    final response = await http.get(Uri.parse('API_URL')); // Replace with your API endpoint
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        ranges = List<Map<String, String>>.from(data['data']['rangos']);
        nightTariff = Map<String, String>.from(data['data']['tarifa_nocturna']);
        ratePerKm = double.parse(ranges[0]['val']);
      });
    } else {
      // Handle error
      print('Failed to fetch rate. Status code: ${response.statusCode}');
    }
  }

  double calculateFare(double distance) {
    double currentFare = 0.0;

    for (int i = 0; i < ranges.length; i++) {
      double from = double.parse(ranges[i]['from']);
      double to = double.parse(ranges[i]['to']);
      double val = double.parse(ranges[i]['val']);

      if (distance >= from && distance <= to) {
        currentFare = distance * val;
        break;
      }
    }

    if (isNightTariff()) {
      double nightTariffVal = double.parse(nightTariff['val']);
      currentFare = distance * nightTariffVal;
    }

    return currentFare;
  }

  bool isNightTariff() {
    DateTime now = DateTime.now();
    String since = nightTariff['since']!;
    String to = nightTariff['to']!;
    TimeOfDay sinceTime = TimeOfDay(
      hour: int.parse(since.split(':')[0]),
      minute: int.parse(since.split(':')[1]),
    );
    TimeOfDay toTime = TimeOfDay(
      hour: int.parse(to.split(':')[0]),
      minute: int.parse(to.split(':')[1]),
    );
    TimeOfDay currentTime = TimeOfDay.fromDateTime(now);

    if (sinceTime.isAfter(toTime)) {
      return currentTime.isAfter(sinceTime) || currentTime.isBefore(toTime);
    } else {
      return currentTime.isAfter(sinceTime) && currentTime.isBefore(toTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taxi Meter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Distance: ${distance.toStringAsFixed(2)} km',
              style: TextStyle(fontSize: 24.0),
            ),
            Text(
              'Fare: \$${fare.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('Start Trip'),
              onPressed: isRunning ? null : startTrip,
            ),
            RaisedButton(
              child: Text('End Trip'),
              onPressed: isRunning ? endTrip : null,
            ),
            SizedBox(height: 20.0),
            Text(
              'Rate per kilometer: \$${ratePerKm.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0),
            ),
            RaisedButton(
              child: Text('Fetch Rate'),
              onPressed: isRunning ? null : fetchRate,
            ),
            SizedBox(height: 20.0),
            Slider(
              value: ratePerKm,
              min: 0.0,
              max: 10.0,
              divisions: 100,
              onChanged: isRunning ? null : (double value) {
                setState(() {
                  ratePerKm = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/