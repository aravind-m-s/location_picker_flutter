import 'package:flutter/material.dart';
import 'package:location_picker_flutter/location_picker_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LocationPickerFlutter(
          googleMapsApiKey: "YOUR_GOOGLE_MAPS_API_KEY",
          intialLocation: InitialSettings(
            latitude: 13,
            longitude: 80,
            zoom: 3,
          ),
        ),
      ),
    );
  }
}
