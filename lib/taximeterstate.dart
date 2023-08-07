import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/taximeter.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
class TaxiMeterState extends ChangeNotifier {
  TaxiMeterState() {
     Geolocator.getPositionStream().listen(_onLocationChanged);
  }
  TaxiMeter _taxiMeter = TaxiMeter();
  List<Map<String, String>> _ranges = [];
  Map<String, String> _nightTariff = {};
  final bool _isBackgroundServiceActive = true;

  double _latitude = 10;
  double _longitude = 10;

  TaxiMeter get taxiMeter => _taxiMeter;
  get ranges => _ranges;
  get nightTariff => _nightTariff;
  get isBackgroundServiceActive => _isBackgroundServiceActive;

  get latitude => _latitude;
  get longitude => _longitude;
  void setCoordinates(lat, long) {
    _latitude = lat;
    _longitude = long;
    notifyListeners();
  }

  void setDataPrices(dynamic data) {
    if (data != null && data['status'] == 200) {
      // Guardar los datos en las variables del estado

      Map<String, String> auxRange = <String, String>{};
      dynamic rs = data['data']['rangos'];

      for (var r in rs) {
        auxRange['from'] = r['from'];
        auxRange['to'] = r['to'];
        auxRange['val'] = r['val'];

        _ranges.add(auxRange);
        auxRange = <String, String>{};
      }

      dynamic tfn = data['data']['tarifa_nocturna'];
      _nightTariff['since'] = tfn['since'];
      _nightTariff['to'] = tfn['to'];
      _nightTariff['val'] = tfn['val'];
 
      // Guardar los datos en Shared Preferences
      saveDataToPreferences();
    }
    notifyListeners();
  }

  void setDataPricesFromPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    dynamic savedRanges = preferences.getString('ranges');
    dynamic savedNightTariff = preferences.getString('nightTariff');

    if (savedRanges != null && savedNightTariff != null) {
      _ranges = savedRanges;
      _nightTariff = savedNightTariff;
    }
    notifyListeners();
  }

  void saveDataToPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('dataRanges', _ranges.toString());
    preferences.setString('nightTariff', _nightTariff.toString());
  }

  double get totalFare => _taxiMeter.totalFare;

  void updateTotalFare(double fare) {
    _taxiMeter.totalFare = fare;
    notifyListeners();
  }

  void incrementDistance() {
    _taxiMeter.distance += 1.0;
    // _taxiMeter.calculateTotalFare(context);
    notifyListeners();
  }

  late Timer timer; // Timer para calcular el costo del viaje continuamente
  void startTrip() {
   
    _taxiMeter.ranges = _ranges;
    _taxiMeter.nightTariff = _nightTariff;

      distanciaTotal = 0.0;

    _taxiMeter.onTrip = true;
    // Iniciar el cálculo del costo del viaje
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _taxiMeter.calculateTotalFare();
      // _taxiMeter.distance += 1.0;

      notifyListeners();
    });
  }

  void endTrip() {
    _taxiMeter.onTrip = false;
    // Detener el cálculo del costo del viaje
    timer?.cancel();
  }
 
  double distanciaTotal = 0.0;
  Position? ultimaPosicion;
  Future<void> _onLocationChanged(Position newPosition) async {
    print("cambió");
  //  PermissionStatus status = await Permission.location.request();
   //  if (status == PermissionStatus.granted)
    if (ultimaPosicion != null &&  _taxiMeter.onTrip) {
      // Calcula la distancia entre la última posición y la nueva posición en metros
       print("cambió11");
      double distanciaEntrePosiciones = Geolocator.distanceBetween(
        ultimaPosicion!.latitude,
        ultimaPosicion!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      // Actualiza la distancia total recorrida
      distanciaTotal += distanciaEntrePosiciones;

      // Imprime la distancia recorrida y la distancia total acumulada
      print('Distancia recorrida: $distanciaEntrePosiciones metros');
      print('Distancia total: $distanciaTotal metros');
      _taxiMeter.distance = 5 ;
      notifyListeners();
    }

    // Actualiza la última posición con la nueva posición
    ultimaPosicion = newPosition;
  }
}
