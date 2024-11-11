import 'package:flutter/material.dart';
import 'package:location_picker_flutter/src/models/picked_location.dart';

class CurrentLocationWidget extends StatelessWidget {
  final PickedLocation? pickedLocation;
  final bool showMapTypes;
  final Function() pickCurrentLocation;
  const CurrentLocationWidget(
      {super.key,
      required this.pickedLocation,
      required this.showMapTypes,
      required this.pickCurrentLocation});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: pickedLocation != null ? 200 : 16,
      right: showMapTypes ? 32 : 16,
      child: GestureDetector(
        onTap: pickCurrentLocation,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.gps_fixed,
            size: 28,
            color: Colors.blue[800],
          ),
        ),
      ),
    );
  }
}
