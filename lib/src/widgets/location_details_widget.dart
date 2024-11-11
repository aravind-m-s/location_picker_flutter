import 'package:flutter/material.dart';
import 'package:location_picker_flutter/src/models/picked_location.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LocationDetailsWidget extends StatelessWidget {
  const LocationDetailsWidget({
    super.key,
    required this.pickedLocation,
  });

  final PickedLocation? pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Skeletonizer(
              effect: ShimmerEffect(
                baseColor: Colors.blue.withOpacity(0.3),
              ),
              enabled: pickedLocation!.landmark == "loading",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pickedLocation!.landmark == "loading"
                        ? "Main Address"
                        : pickedLocation!.addressLine1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    pickedLocation!.landmark == "loading"
                        ? "Sub address widget with extra length"
                        : pickedLocation!.fullAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      height: 0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(pickedLocation);
                    },
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
