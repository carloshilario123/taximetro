class TaxiMeter {
  double initialFarePerKm = 2.0; // Tarifa inicial por kilómetro
  double nightTariffMultiplier = 1.5; // Multiplicador para la tarifa nocturna

  double farePerKm = 2; // Tarifa por kilómetro
  double distance = 0; // Distancia recorrida
  double totalFare = 0; // Tarifa total del viaje
  bool onTrip = false;

  late List<Map<String, String>> ranges;

  late Map<String, String> nightTariff;

  void calculateTotalFare() {
    // Calcular el costo total del viaje basado en la distancia y la tarifa por kilómetro
   print(ranges);
    

 Map<String, dynamic>? result;

  for (var item in ranges) {
    double from = double.parse(item['from']!);
    double to =double.parse(item['to']!);
 
    if (distance >= from && distance < to) {
      result = item;
      break;
    }
  } 
  if (result != null) {
   totalFare = double.parse(result!['val']);
  } else {
   totalFare = double.parse( ranges[ranges.length-1]['val']!) ;
  } 
  

    //totalFare = distance * farePerKm;
    if (isNightTime()) {
      totalFare += nightTariffMultiplier;
    }
  }

  bool isNightTime() {
    // Verificar si es horario nocturno (ejemplo: de 22:00 a 6:00)
    final now = DateTime.now();
    final since = DateTime(now.year, now.month, now.day, 22,
        0); // Hora de inicio del horario nocturno
    final to = DateTime(now.year, now.month, now.day, 6,
        0); // Hora de finalización del horario nocturno

    if (since.isBefore(to)) {
      // El horario nocturno es dentro del mismo día
      return now.isAfter(since) || now.isBefore(to);
    } else {
      // El horario nocturno atraviesa dos días (por ejemplo, desde las 22:00 hasta las 6:00 del día siguiente)
      return now.isAfter(since) && now.isBefore(to);
    }
  }
}
