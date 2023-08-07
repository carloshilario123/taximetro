import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; 
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taximetro/services/background_service.dart';

import 'taximeterstate.dart';
import 'package:taximetro/services/taximeter.services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

 // Inicializa el servicio en segundo plano
  BackgroundService backgroundService = BackgroundService();
  
  Completer<GoogleMapController> _mapController = Completer();
  LatLng? _currentPosition;

  @override
void initState() {
    super.initState();
       backgroundService.initializeService(context);
   // getCurrentLocation();
    fetchDataPricesFromService();
 
  } 
  void fetchDataPricesFromService() async {
    final taxiMeterState = Provider.of<TaxiMeterState>(context, listen: false);
    final preferences = await SharedPreferences.getInstance();
    final adminCode = preferences.getString('adminCode');

    try {
      if (adminCode != null) {
        final response = await TaximeterService.getDataPrices();

        if (response != null) {
          final data = jsonDecode(response);
          taxiMeterState.setDataPrices(data);
        } else {
          taxiMeterState.setDataPricesFromPreferences();
        }
      }

      checkPreferencesAndRedirect();
    } catch (e) {
      // Error de conexión o cualquier otro error
      print('Error: $e');
      taxiMeterState.setDataPricesFromPreferences();
    }
  }

  void checkPreferencesAndRedirect() async {
    final preferences = await SharedPreferences.getInstance();
    final name = preferences.getString('name');

    if (name == null)
      Navigator.pushNamed(context, '/register');
    else
      Navigator.pushNamed(context, '/taximeter');
  }

  @override
  Widget build(BuildContext context) {
        final taxiMeterState = Provider.of<TaxiMeterState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Column(
        children: [
          /*Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition ?? LatLng(0, 0),
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              markers: _currentPosition != null
                  ? Set<Marker>.from([
                      Marker(
                        markerId: MarkerId('currentPosition'),
                        position: _currentPosition!,
                      ),
                    ])
                  : Set<Marker>(),
            ),
          ),*/
          SizedBox(height: 16.0),
          Text(
            'Latitude: ${taxiMeterState.latitude ?? 0}',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(height: 16.0),
          Text(
            'Longitude: ${taxiMeterState.longitude ?? 0}',
            style: TextStyle(fontSize: 20.0),
          ),
        ],
      ),
    );
  }
}
