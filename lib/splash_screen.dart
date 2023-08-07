import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taximetro/permission_manager.dart';
import 'package:taximetro/services/background_service.dart';
import 'package:taximetro/services/location_service/logic/location_controller/location_controller_cubit.dart';
import 'package:taximetro/taximeterstate.dart';
import 'home_screen.dart';
import 'notification/notification.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
    late BackgroundService backgroundService;
      final PermissionManager permissionManager = PermissionManager();
     
  @override
  void initState() {
    super.initState();
    // Add any initialization logic here
    // (e.g., data loading, fetching, or other setup tasks)
    
    // Example: Simulate a delay using Future.delayed
    Future.delayed(Duration(seconds: 1), () {
      // Navigate to the next screen after the splash screen
      // You can replace `NextScreen()` with your desired screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
        backgroundService = BackgroundService();
     initialiceBackgroundService(context);
  }
  @pragma('vm:entry-point')
  @override
  Future<void> didChangeDependencies() async {
    await context.read<NotificationService>().initialize(context);

    //Start the service automatically if it was activated before closing the application
    if (await backgroundService.instance.isRunning()) {
      print('inicializando1');

      await backgroundService.initializeService();
    }
    backgroundService.instance.on('on_location_changed').listen((event) async {
      if (event != null) {
        final position = Position(
          longitude: double.tryParse(event['longitude'].toString()) ?? 0.0,
          latitude: double.tryParse(event['latitude'].toString()) ?? 0.0,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
              event['timestamp'].toInt(),
              isUtc: true),
          accuracy: double.tryParse(event['accuracy'].toString()) ?? 0.0,
          altitude: double.tryParse(event['altitude'].toString()) ?? 0.0,
          heading: double.tryParse(event['heading'].toString()) ?? 0.0,
          speed: double.tryParse(event['speed'].toString()) ?? 0.0,
          speedAccuracy:
          double.tryParse(event['speed_accuracy'].toString()) ?? 0.0,
        );

        await context
            .read<LocationControllerCubit>()
            .onLocationChanged(location: position);
      }
    });

    super.didChangeDependencies();
  }
  void initialiceBackgroundService(BuildContext context)async {
    final hasPermission =
    await permissionManager.requestLocationPermission(context);

    if (hasPermission) {
      await context
          .read<LocationControllerCubit>()
          .locationFetchByDeviceGPS();
      //Configure the service notification channel and start the service
      await backgroundService.initializeService();
      //Set service as foreground.(Notification will available till the service end)
      backgroundService.setServiceAsForeGround();
       // Obtener la posición y actualizar el estado LocationState
      final position = await Geolocator.getCurrentPosition();
      final locationState = context.read<TaxiMeterState>();
      locationState.setCoordinates(position.latitude, position.longitude);
    }
  }
  @override
  Widget build(BuildContext context) {
    // Hide the status bar   
//  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return Scaffold(
      backgroundColor: Colors.red, // Replace with your desired background color
      body: Center(
        child: Text("algo"),// FlutterLogo(size: 150), // Replace with your splash screen image or widget
      ),
    );
  }

  @override
  void dispose() {
    // Show the status bar again when disposing of the widget
  //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}
