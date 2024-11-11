import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_picker_flutter/src/api/api_provider.dart';
import 'package:location_picker_flutter/src/core/helpers/debounder.dart';
import 'package:location_picker_flutter/src/core/helpers/uuid.dart';
import 'package:location_picker_flutter/src/core/widgets/dialog_loading.dart';
import 'package:location_picker_flutter/src/models/autocomplete_result.dart';
import 'package:location_picker_flutter/src/models/initial_settings.dart';
import 'package:location_picker_flutter/src/models/picked_location.dart';
import 'package:location_picker_flutter/src/models/place_details_model.dart';
import 'package:location_picker_flutter/src/widgets/current_location_widget.dart';
import 'package:location_picker_flutter/src/widgets/google_map_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location_picker_flutter/src/widgets/location_details_widget.dart';

export 'models/initial_settings.dart';
export 'models/point_model.dart';

/// LocationPickerFlutter is a customizable widget for selecting locations.
/// Users can pick a location by tapping on the map, use their current location, or search with Google Places Autocomplete.
class LocationPickerFlutter extends StatefulWidget {
  /// Your Google Maps API Key for using Google Maps and Places API services.
  final String googleMapsApiKey;

  /// Initial location settings, such as starting position on the map.
  final InitialSettings intialLocation;

  /// Enables or disables the map types button, allowing users to switch map views (e.g., Satellite, Terrain).
  final bool showMapTypes;

  /// Shows or hides buildings in the 3D map view, enhancing map detail.
  final bool showBuildings;

  /// Shows or hides zoom controls on the map.
  final bool showZoomControls;

  /// Enables or disables the ability to zoom in and out on the map.
  final bool canZoom;

  /// Enables or disables the ability to rotate the map.
  final bool canRotate;

  /// Placeholder text for the search bar used in Google Places Autocomplete.
  final String searchHint;

  /// Session token for Google Places API requests, useful for tracking a single autocomplete session.
  final String sessionToken;

  /// LocationPickerFlutter is a customizable widget for selecting locations.
  /// Users can pick a location by tapping on the map, use their current location, or search with Google Places Autocomplete.
  const LocationPickerFlutter({
    super.key,
    required this.googleMapsApiKey,
    required this.intialLocation,
    this.showMapTypes = false,
    this.showBuildings = true,
    this.showZoomControls = false,
    this.canZoom = true,
    this.canRotate = true,
    this.searchHint = "Search for location, landmarks...",
    this.sessionToken = "",
  });

  @override
  State<LocationPickerFlutter> createState() => _LocationPickerFlutterState();
}

class _LocationPickerFlutterState extends State<LocationPickerFlutter> {
  MapType mapType = MapType.normal;
  PickedLocation? pickedLocation;
  GoogleMapController? googleMapController;
  String sessionToken = "";

  @override
  void initState() {
    super.initState();
    if (widget.sessionToken.isEmpty) {
      sessionToken = Uuid.generateV4();
    } else {
      sessionToken = widget.sessionToken;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMapWidget(
          mapType: mapType,
          widget: widget,
          position: pickedLocation,
          callback: _updateGoogleMapController,
          positionToAddress: _positionToAddress,
        ),
        CurrentLocationWidget(
          pickedLocation: pickedLocation,
          showMapTypes: widget.showMapTypes,
          pickCurrentLocation: pickCurrentLocation,
        ),
        if (pickedLocation != null)
          LocationDetailsWidget(pickedLocation: pickedLocation),
        AutoCompleteWidget(
          widget: widget,
          sessionToken: sessionToken,
          onLocationPicked: (details) async {
            final splitDetails = details.result.name.split(",");

            pickedLocation = PickedLocation(
              latitude: details.result.geometry.location.lat,
              longitude: details.result.geometry.location.lng,
              addressLine1: splitDetails.isEmpty
                  ? details.result.name
                  : splitDetails.first,
              addressLine2: '',
              landmark: '',
              city: '',
              state: '',
              country: '',
              zipCode: '',
              fullAddress: details.result.name,
            );
            if (googleMapController != null) {
              googleMapController!.animateCamera(
                CameraUpdate.newLatLngZoom(
                  LatLng(pickedLocation!.latitude, pickedLocation!.longitude),
                  18,
                ),
              );
            }
            setState(() {});
          },
        )
      ],
    );
  }

  void _updateGoogleMapController(GoogleMapController controller) {
    googleMapController = controller;
  }

  void pickCurrentLocation() async {
    dialogLoading(context);
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.denied &&
        permission != LocationPermission.deniedForever) {
      final location = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );
      Navigator.pop(context);

      await _positionToAddress(location.latitude, location.longitude);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _positionToAddress(double latitude, double longitude) async {
    pickedLocation = PickedLocation(
      latitude: latitude,
      longitude: longitude,
      addressLine1: "",
      addressLine2: "",
      landmark: "loading",
      city: "",
      state: "",
      country: "",
      zipCode: "",
      fullAddress: "",
    );
    if (googleMapController != null) {
      googleMapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(pickedLocation!.latitude, pickedLocation!.longitude),
          18,
        ),
      );
    }
    setState(() {});
    final placemarks = await placemarkFromCoordinates(latitude, longitude);
    final placemark = placemarks.first;
    pickedLocation = PickedLocation(
        latitude: latitude,
        longitude: longitude,
        addressLine1: placemark.street ?? "",
        addressLine2: placemark.subAdministrativeArea ?? "",
        landmark: (placemark.name ?? "").split(",").firstOrNull ?? "",
        city: placemark.locality ?? "",
        state: placemark.administrativeArea ?? "",
        country: placemark.country ?? "",
        zipCode: placemark.postalCode ?? "",
        fullAddress:
            "${placemark.street ?? ""}, ${placemark.locality ?? ""}, ${placemark.administrativeArea ?? ""}, ${placemark.country ?? ""}");

    setState(() {});
  }
}

class AutoCompleteWidget extends StatefulWidget {
  const AutoCompleteWidget({
    super.key,
    required this.widget,
    required this.sessionToken,
    required this.onLocationPicked,
  });

  final LocationPickerFlutter widget;
  final String sessionToken;
  final Function(PlaceDetailsModel details) onLocationPicked;

  @override
  State<AutoCompleteWidget> createState() => _AutoCompleteWidgetState();
}

class _AutoCompleteWidgetState extends State<AutoCompleteWidget> {
  final TextEditingController searchController = TextEditingController();
  final Debouncer debouncer = Debouncer();
  List<AutoCompleteResultModel> results = [];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 16,
      right: MediaQuery.of(context).size.width > 500 ? null : 16,
      child: Platform.isAndroid
          ? Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width > 500
                      ? 500
                      : MediaQuery.of(context).size.width - 32,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      suffixIcon: searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                searchController.clear();
                              },
                              child: const Icon(Icons.clear),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(24),
                          topRight: const Radius.circular(24),
                          bottomLeft: Radius.circular(results.isEmpty ? 24 : 0),
                          bottomRight:
                              Radius.circular(results.isEmpty ? 24 : 0),
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: widget.widget.searchHint,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: onChanged,
                  ),
                ),
                Container(
                  height: 0.5,
                  color: Colors.grey,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width > 500
                      ? 500
                      : MediaQuery.of(context).size.width - 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      results.length,
                      (index) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () async {
                          final response = await ApiProvider.getPlaceDetails(
                            placeId: results[index].placeId,
                            key: widget.widget.googleMapsApiKey,
                          );
                          final details = placeDetailsModelFromJson(response);
                          details.result.name = results[index].description;
                          widget.onLocationPicked(details);
                          results.clear();
                          setState(() {});
                          searchController.clear();
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 8.0,
                            bottom: index == results.length - 1 ? 16 : 8,
                          ),
                          child: Text(
                            results[index].description,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const CupertinoSearchTextField(),
    );
  }

  onChanged(String value) async {
    debouncer.run(
      () async {
        final response = await ApiProvider.getAutocompletePlaces(
          query: value,
          key: widget.widget.googleMapsApiKey,
          sessionToken: widget.sessionToken,
        );
        results.clear();
        response.forEach((element) {
          results.add(AutoCompleteResultModel.fromJson(element));
        });

        setState(() {});
      },
    );
  }
}
