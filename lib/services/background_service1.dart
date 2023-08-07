import 'dart:async';
import 'package:flutter/src/widgets/framework.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../taximeterstate.dart';

class BackgroundService {
  static const int _updateIntervalInSeconds =
      10; // Intervalo de actualización en segundos

  late StreamSubscription<LocationData> _locationSubscription;
  late Timer _timer;

  BackgroundService();
  
  

  Future<void> startBackgroundService(BuildContext context) async {
  
    final taxiMeterState = Provider.of<TaxiMeterState>(context, listen: false);
    final location = Location();

    // Comprueba si la variable en el estado es true
    if (taxiMeterState.isBackgroundServiceActive) {
      // Obtén la ubicación inicial
      LocationData? initialLocation;
      try {
        initialLocation = await location.getLocation();
        print(initialLocation);
      } catch (e) {
        print('Error getting initial location: $e');
      }

      // Si se obtiene la ubicación inicial, envíala a la API y guárdala en el estado
      if (initialLocation != null) {
        await sendLocationDataToAPI(initialLocation);
        taxiMeterState.setCoordinates(
            initialLocation.latitude, initialLocation.longitude);
      }

      // Inicia la suscripción a los cambios de ubicación y configura el temporizador para enviar actualizaciones periódicas
      _locationSubscription =
          location.onLocationChanged.listen((LocationData locationData) async {
        // Envía la ubicación a la API y guárdala en el estado
        await sendLocationDataToAPI(locationData);
        taxiMeterState.setCoordinates(
            locationData.latitude, locationData.longitude);
      });

      // Configura el temporizador para enviar actualizaciones periódicas
      _timer = Timer.periodic(Duration(seconds: _updateIntervalInSeconds),
          (Timer timer) async {
        // Obtiene la ubicación actual
        LocationData? currentLocation;
        try {
          currentLocation = await location.getLocation();
        } catch (e) {
          print('Error getting current location: $e');
        }

        // Si se obtiene la ubicación actual, envíala a la API y guárdala en el estado
        if (currentLocation != null) {
          await sendLocationDataToAPI(currentLocation);

          taxiMeterState.setCoordinates(
              currentLocation.latitude, currentLocation.longitude);
        }
      });
    }
  }

  Future<void> stopBackgroundService() async {
    // Cancela la suscripción y detiene el temporizador
    _locationSubscription.cancel();
    _timer.cancel();
  }

  Future<void> sendLocationDataToAPI(LocationData locationData) async {
    // Envía la ubicación a la API (implementa tu lógica de envío aquí)
    final url = 'https://example.com/api/update-location';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'latitude': locationData.latitude.toString(),
        'longitude': locationData.longitude.toString(),
      },
    );

    if (response.statusCode == 200) {
      print('Location data sent to API successfully');
    } else {
      print('Error sending location data to API');
    }
  }
}
