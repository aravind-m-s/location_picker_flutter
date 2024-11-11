
# LocationPickerFlutter

`LocationPickerFlutter` is a customizable Flutter widget that allows users to pick a location through Google Maps. It integrates Google Maps, Places API, and Geolocation services to offer a seamless location selection experience. Users can either select a location on the map, use their current location, or search for a location through Google Places Autocomplete.

## Features

- Google Maps integration for interactive location picking.
- Search functionality using Google Places Autocomplete.
- Option to display or hide map types (Satellite, Terrain, etc.).
- Supports zoom and rotate gestures.
- Current location detection and navigation.
- Customizable location details display.
- Session token support for Google Places API requests.

## Installation

To use this package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  location_picker_flutter: ^1.0.0
```

## Getting Started

1. Add your **Google Maps API Key** to the widget's constructor.
2. Customize the `InitialSettings` to specify the starting position and other settings.
3. Use the `LocationPickerFlutter` widget in your app wherever you need location selection.

### Adding Google Maps API Key

To use Google Maps and Places APIs in your app, you need to add your API key to both Android and iOS.

#### Android

1. Open the `AndroidManifest.xml` file in `android/app/src/main/`.
2. Add the following inside the `<application>` tag:

   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY" />
   ```

Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual Google Maps API key.

#### iOS

1. Open `AppDelegate.swift` file in `ios/Runner/`.
2. Import Google Maps at the top of the file:

   ```swift
   import GoogleMaps
   ```

3. Inside `@UIApplicationMain` in `AppDelegate`, add the following in `didFinishLaunchingWithOptions`:

   ```swift
   GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
   ```

Again, replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual key.

### Example Usage

```dart
import 'package:flutter/material.dart';
import 'package:location_picker_flutter/location_picker_flutter.dart';
import 'package:location_picker_flutter/models/initial_settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Picker',
      home: Scaffold(
        appBar: AppBar(title: Text('Location Picker Example')),
        body: LocationPickerFlutter(
          googleMapsApiKey: 'YOUR_GOOGLE_MAPS_API_KEY',  // Your API key here
          intialLocation: InitialSettings(
            latitude: 37.7749,
            longitude: -122.4194,
            zoomLevel: 10,
          ),
          showMapTypes: true,
          showZoomControls: true,
          canZoom: true,
          canRotate: true,
          searchHint: "Search for locations...",
          sessionToken: "",  // Optionally provide a session token
        ),
      ),
    );
  }
}
```

### Constructor Parameters

- `googleMapsApiKey`: **String** - Your Google Maps API key.
- `intialLocation`: **InitialSettings** - Initial settings for the map, including the starting location and zoom level.
- `showMapTypes`: **bool** - Whether to show map types (default is `false`).
- `showBuildings`: **bool** - Whether to show buildings in 3D view (default is `true`).
- `showZoomControls`: **bool** - Whether to show zoom controls (default is `false`).
- `canZoom`: **bool** - Whether zoom is enabled (default is `true`).
- `canRotate`: **bool** - Whether rotation is enabled (default is `true`).
- `searchHint`: **String** - Hint text for the search bar (default is `"Search for location, landmarks..."`).
- `sessionToken`: **String** - Optional session token for Google Places API requests.

### Permissions

Ensure you have added the required permissions for location access in your app.

For Android, add the following to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

For iOS, add these to your `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Your custom message here</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Your custom message here</string>
```

## Contribution

Contributions are welcome! Feel free to submit issues, feature requests, or pull requests.

## License

This package is licensed under the MIT License. See the [LICENSE](https://github.com/aravind-m-s/location_picker_flutter/blob/main/LICENSE) file for more details.