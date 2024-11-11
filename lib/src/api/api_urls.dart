class ApiUrls {
  static const _baseUrl = "https://maps.googleapis.com/maps/api/";

  static Uri getAutoCompleteUrl(
      {required String query,
      required String key,
      required String sessionToken}) {
    return Uri.parse(
        "${_baseUrl}place/autocomplete/json?input=$query&key=$key");
  }

  static Uri getPlaceUrl({required String placeId, required String key}) {
    return Uri.parse(
        "${_baseUrl}place/details/json?place_id=$placeId&key=$key");
  }
}
