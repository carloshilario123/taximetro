import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaximeterService {
  static const String baseUrl = 'http://192.168.100.18/map/index.php/ctaximetro/';

  static Future<dynamic> getDataPrices() async {
       final preferences = await SharedPreferences.getInstance(); 
     final adminCode = preferences.getString('adminCode');
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}config'),
        body: { 
          'adminCode': adminCode,
        },
      );

      // Verifica el código de estado de la respuesta
      if (response.statusCode == 200) { 
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
   static Future<dynamic> setStartTravelData(lat, lng) async {
     final preferences = await SharedPreferences.getInstance(); 
     final adminCode = preferences.getString('adminCode');
     final number = preferences.getString('number');
    try {
      final response = await http.post(
          Uri.parse('${baseUrl}starttravel'),
        body: { 
          'adminCode': adminCode,
          'number': number,
          'lat' : lat ,
          'lng': lng
        },
      );

      // Verifica el código de estado de la respuesta
      if (response.statusCode == 200) { 
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
  static Future<dynamic> setEndTravelData(lat, lng) async {
     final preferences = await SharedPreferences.getInstance(); 
     final adminCode = preferences.getString('adminCode');
     final number = preferences.getString('number');
    try {
      final response = await http.post(
          Uri.parse('${baseUrl}endtravel'),
        body: { 
          'adminCode': adminCode,
          'number': number,
          'lat' : lat ,
          'lng': lng
        },
      );

      // Verifica el código de estado de la respuesta
      if (response.statusCode == 200) { 
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
