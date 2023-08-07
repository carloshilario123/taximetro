import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'taximeterstate.dart';

class TaxiMeterScreen extends StatelessWidget {
  const TaxiMeterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taxiMeterState = Provider.of<TaxiMeterState>(context, listen: true);
    final taxiMeter = taxiMeterState.taxiMeter;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Taximetro')),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 0.8, // Ajusta el ancho deseado del logo
                heightFactor: 0.5, // Ajusta el alto deseado del logo
                child: Image.asset('images/logo.png'),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Recorrido: ${taxiMeter.distance} km',
                    style: GoogleFonts.abel(
                        fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 18.0),
                  Text(
                  taxiMeterState.latitude.toString() +  '   Costo: \$${taxiMeter.totalFare.toStringAsFixed(2)}',
                    style: GoogleFonts.abel(
                        fontSize: 32.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 18.0),
                  taxiMeter.onTrip
                      ? ElevatedButton( 
                          onPressed: () {
                            taxiMeterState.incrementDistance();
                            taxiMeterState.endTrip();
                          },
                          child: Text(
                            'Finalizar Viaje',
                            style: GoogleFonts.abel(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            taxiMeterState.incrementDistance();
                            taxiMeterState.startTrip();
                          },
                          child: Text(
                            'Comenzar Viaje',
                            style: GoogleFonts.abel(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
