import 'dart:convert';
import 'dart:io';

import 'package:location_picker_flutter/src/api/api_urls.dart';

class ApiProvider {
  static final HttpClient client = HttpClient();

  static getAutocompletePlaces(
      {required String query,
      required String key,
      required String sessionToken}) async {
    try {
      final request = await client.getUrl(
        ApiUrls.getAutoCompleteUrl(
          query: query,
          key: key,
          sessionToken: sessionToken,
        ),
      );
      final response = await request.close();
      if (response.statusCode == 200) {
        final data = await response.transform(utf8.decoder).join();
        final suggestions = json.decode(data)['predictions'];
        return suggestions;
      } else {
        return "Unable to fetch the data";
      }
    } catch (e) {
      return "Unable to fetch the data";
    }
  }

  static getPlaceDetails({required String placeId, required String key}) async {
    try {
      final request = await client.getUrl(
        ApiUrls.getPlaceUrl(
          placeId: placeId,
          key: key,
        ),
      );
      final response = await request.close();
      if (response.statusCode == 200) {
        final data = await response.transform(utf8.decoder).join();
        return data;
      } else {
        return "Unable to fetch the data";
      }
    } catch (e) {
      return "Unable to fetch the data";
    }
  }
}
