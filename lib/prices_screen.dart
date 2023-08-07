import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:taximetro/taximeterstate.dart';

class PricesScreen extends StatefulWidget {
  @override
  _PricesScreenState createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PriceListScreen(initialDistance: 0, finalDistance: 50);
  }
}

class PriceListScreen extends StatelessWidget {
  final double initialDistance;
  final double finalDistance;

  PriceListScreen({
    required this.initialDistance,
    required this.finalDistance,
  });

  @override
  Widget build(BuildContext context) {
    final taxiMeterState = Provider.of<TaxiMeterState>(context, listen: true);
   
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Precios'),
      ),
      body: ListView.builder(
        itemCount: taxiMeterState.ranges.length,
        itemBuilder: (context, index) {
          final from = taxiMeterState.ranges[index]['from'];
          final to = taxiMeterState.ranges[index]['to'];
          final val = taxiMeterState.ranges[index]['val'];
          return ListTile(
            title: Text('Distancia: $from km  -  $to km'),
            subtitle: Text('Precio: \$$val'),
          );
        },
      ),
    );
  }

  double calculatePrice(double distance) {
    // Lógica para calcular el precio basado en la distancia
    // Puedes implementar tu propia lógica aquí
    return distance * 1.5;
  }
}
