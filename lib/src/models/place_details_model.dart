// To parse this JSON data, do
//
//     final placeDetailsModel = placeDetailsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PlaceDetailsModel placeDetailsModelFromJson(String str) =>
    PlaceDetailsModel.fromJson(json.decode(str));

String placeDetailsModelToJson(PlaceDetailsModel data) =>
    json.encode(data.toJson());

class PlaceDetailsModel {
  final List<dynamic> htmlAttributions;
  final Result result;

  PlaceDetailsModel({
    required this.htmlAttributions,
    required this.result,
  });

  factory PlaceDetailsModel.fromJson(Map<String, dynamic> json) =>
      PlaceDetailsModel(
        htmlAttributions:
            List<dynamic>.from(json["html_attributions"].map((x) => x)),
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "html_attributions": List<dynamic>.from(htmlAttributions.map((x) => x)),
        "result": result.toJson(),
      };
}

class Result {
  final Geometry geometry;
  String name;

  Result({
    required this.geometry,
    required this.name,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        geometry: Geometry.fromJson(json["geometry"]),
        name: "",
      );

  Map<String, dynamic> toJson() => {
        "geometry": geometry.toJson(),
      };
}

class Geometry {
  final Location location;
  final Viewport viewport;

  Geometry({
    required this.location,
    required this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        viewport: Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "viewport": viewport.toJson(),
      };
}

class Location {
  final double lat;
  final double lng;

  Location({
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  final Location northeast;
  final Location southwest;

  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: Location.fromJson(json["northeast"]),
        southwest: Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast.toJson(),
        "southwest": southwest.toJson(),
      };
}
