import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_picker_flutter/location_picker_flutter.dart';
import 'package:location_picker_flutter/src/models/picked_location.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget(
      {super.key,
      required this.mapType,
      required this.widget,
      required this.position,
      required this.callback,
      required this.positionToAddress});

  final MapType mapType;
  final LocationPickerFlutter widget;
  final PickedLocation? position;
  final Function(GoogleMapController) callback;
  final Function(double latitiude, double longitude) positionToAddress;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: widget.mapType,
      myLocationButtonEnabled: false,
      zoomGesturesEnabled: widget.widget.canZoom,
      zoomControlsEnabled: widget.widget.showZoomControls,
      rotateGesturesEnabled: widget.widget.canRotate,
      buildingsEnabled: widget.widget.showBuildings,
      onMapCreated: (controller) {
        widget.callback(controller);
      },
      onTap: (latLng) {
        widget.positionToAddress(latLng.latitude, latLng.longitude);
      },
      markers: widget.position == null
          ? {}
          : {
              Marker(
                markerId: MarkerId(widget.position!.fullAddress),
                position: LatLng(
                    widget.position!.latitude, widget.position!.longitude),
              ),
            },
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.widget.intialLocation.latitude,
          widget.widget.intialLocation.longitude,
        ),
        zoom: widget.widget.intialLocation.zoom,
      ),
    );
  }
}
