import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PermissionManager {
  Future<bool> requestLocationPermission(BuildContext context) async {
    final permissionStatus = await Geolocator.requestPermission();

    if (permissionStatus == LocationPermission.denied ||
        permissionStatus == LocationPermission.deniedForever) {
      final shouldOpenSettings = await showLocationPermissionDialog(context);

      if (shouldOpenSettings!) {
        await Geolocator.openAppSettings();
      }

      return false;
    } else if (permissionStatus == LocationPermission.whileInUse ||
        permissionStatus == LocationPermission.always) {
      return true;
    }

    return false;
  }

  Future<bool> checkLocationPermission() async {
    final permissionStatus = await Geolocator.checkPermission();

    return permissionStatus == LocationPermission.whileInUse ||
        permissionStatus == LocationPermission.always;
  }

  Future<bool?> showLocationPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'Please grant the location permission to use this feature.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }
}
