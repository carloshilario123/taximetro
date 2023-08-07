import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taximetro/notification/notification.dart';
import 'package:taximetro/permission_manager.dart';
import 'package:taximetro/services/background_service.dart';
import 'package:taximetro/services/location_service/logic/location_controller/location_controller_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late BackgroundService backgroundService;
  final PermissionManager permissionManager = PermissionManager();

  @override
  void initState() {
    super.initState();
    backgroundService = BackgroundService();
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Resto del código del formulario y los botones ...

          ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              await Fluttertoast.showToast(
                msg: "Wait for a while, Initializing the service...",
              );
 
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
              }
            },
            child: const Text("Start data1 sending"),
          ),
        ],
      ),
    );
  }
}
