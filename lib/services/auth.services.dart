import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.100.18/map/index.php/phones';

  static Future<bool> sendFormData({
    required String name,
    required String email,
    required String phone,
    required String licensePlate,
    required String carRegistration,
    required String adminCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: {
          'name': name,
          'email': email,
          'number': phone,
          'licensePlate': licensePlate,
          'carRegistration': carRegistration,
          'adminCode': adminCode,
        },
      );

      // Verifica el código de estado de la respuesta
      if (response.statusCode == 200) {
        // Guarda los datos en preferencias
        final preferences = await SharedPreferences.getInstance();
        preferences.setString('name', name);
        preferences.setString('email', email);
        preferences.setString('phone', phone);
        preferences.setString('licensePlate', licensePlate);
        preferences.setString('carRegistration', carRegistration);
        preferences.setString('adminCode', adminCode);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
