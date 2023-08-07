import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:taximetro/notification/notification.dart';
import 'package:taximetro/services/background_service.dart';
import 'package:taximetro/services/location_service/logic/location_controller/location_controller_cubit.dart';
import 'package:taximetro/services/location_service/repository/location_service_repository.dart';
import 'package:taximetro/services/taximeter.services.dart';
import 'package:taximetro/splash_screen.dart';
import 'package:taximetro/taximeter_screen.dart';
import 'home_screen.dart'; 
import 'register_screen.dart';
import 'taximeterstate.dart';

final notificationService =  NotificationService(FlutterLocalNotificationsPlugin());
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaxiMeterState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) { 
     return RepositoryProvider.value(
      value: notificationService,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LocationControllerCubit(
              locationServiceRepository: LocationServiceRepository(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Track Your Location',
          theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Color.fromRGBO( 227, 216, 12,1),
            secondary: Color.fromRGBO(163, 156, 20, 1),
          ),
        ),
          home:   SplashScreen(),
           routes: {
          '/home': (context) => HomeScreen(),
          '/taximeter': (context) => TaxiMeterScreen(),
          '/register': (context) => RegistrationForm(),
        },
        ),
      ),
    );
   /* return ChangeNotifierProvider(
      create: (context) => TaxiMeterState(),
      child: MaterialApp(
        title: 'Taximetro',
        theme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.dark(
            primary: Color.fromRGBO( 227, 216, 12,1),
            secondary: Color.fromRGBO(163, 156, 20, 1),
          ),
        ),
        home: SplashScreen(),
        routes: {
          '/home': (context) => HomeScreen(),
          '/taximeter': (context) => TaxiMeterScreen(),
          '/register': (context) => RegistrationForm(),
        },
      ),
    );*/
  }
}

 