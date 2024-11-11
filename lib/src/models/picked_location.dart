class PickedLocation {
  final double latitude;
  final double longitude;
  String addressLine1;
  final String addressLine2;
  final String landmark;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  String fullAddress;

  PickedLocation({
    required this.latitude,
    required this.longitude,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.fullAddress,
  });

  @override
  String toString() {
    return "Latitude: $latitude, Longitude: $longitude, Address Line 1: $addressLine1, Address Line 2: $addressLine2, Landmark: $landmark, City: $city, State: $state, Country: $country, Zip Code: $zipCode, Full Address: $fullAddress";
  }
}
