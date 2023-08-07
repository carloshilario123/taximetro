// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:taximetro/notification/notification.dart';

import '../taximeterstate.dart';

const String notificationChannelId = "foreground_service";
const int foregroundServiceNotificationId = 888;
const String initialNotificationTitle = "TRACK YOUR LOCATION";
const String initialNotificationContent = "Initializing";

const int timeInterval = 10; //in seconds

//String  phone_Number    = '';
// Rafael String  phone_Number    = '9983974193';
// Manuel Perez
//String  phone_Number    = '9984493230';
// Yuri
//String  phone_Number    = '9371648022';
String phone_Number = '999999999';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) async {
      await service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) async {
      await service.setAsBackgroundService();
    });
  }

  service.on("stop_service").listen((event) async {
    await service.stopSelf();
  });

  // Variable para rastrear si ya se está procesando una solicitud
  bool isProcessingRequest = false;

  // Función para obtener la ubicación y realizar la solicitud
  Future<void> getLocationAndSendRequest() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition();
      service.invoke('on_location_changed', position.toJson());

      print('algo sii' + phone_Number);
      try {
        var url = Uri.parse('http://192.168.100.18/map/index.php/coordinates');

        var data = {
          'lat': position.latitude.toString(),
          'lon': position.longitude.toString(),
          'number': phone_Number,
        };
       
        var response = await http.post(url, body: data);

        if (response.statusCode == 200) {
          print(response.body);
        } else {
          print(response.body);
        }
      } catch (e) {}

      await NotificationService(FlutterLocalNotificationsPlugin())
          .showNotification(
        showNotificationId: foregroundServiceNotificationId,
        title: "Hii,jj",
        body:
            'Your Latitude: ${position.latitude}, Longitude: ${position.longitude}',
        payload: "service",
        androidNotificationDetails: const AndroidNotificationDetails(
          notificationChannelId,
          notificationChannelId,
          ongoing: true,
        ),
      );

      // Marcar la solicitud actual como finalizada
      isProcessingRequest = false;
    }
  }

  // bring to foreground
  print("inicializando3");
  Timer.periodic(const Duration(seconds: timeInterval), (timer) async {
    print("tic");
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService() && !isProcessingRequest) {
        // Marcar la solicitud actual como en proceso
        isProcessingRequest = true;

        // Llamar a la función para obtener la ubicación y realizar la solicitud
        await getLocationAndSendRequest();
      }
    }
  });
}

class BackgroundService {
  //Get instance for flutter background service plugin
  final FlutterBackgroundService flutterBackgroundService =
      FlutterBackgroundService();

  FlutterBackgroundService get instance => flutterBackgroundService;

  Future<void> initializeService() async {
    print('inicializando2');
    await NotificationService(FlutterLocalNotificationsPlugin()).createChannel(
        const AndroidNotificationChannel(
            notificationChannelId, notificationChannelId));
    await flutterBackgroundService.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        // auto start service
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: notificationChannelId,
        foregroundServiceNotificationId: foregroundServiceNotificationId,
        initialNotificationTitle: initialNotificationTitle,
        initialNotificationContent: initialNotificationContent,
      ),
      //Currently IOS setup is not completed.
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,
        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,
      ),
    );
    await flutterBackgroundService.startService();
  }

  void setServiceAsForeGround() async {
    flutterBackgroundService.invoke("setAsForeground");
  }

  void stopService() {
    flutterBackgroundService.invoke("stop_service");
  }
 

}
