# SPAITR-MAP Mobile App

The SPAITR Map mobile app is run using Flutter and Dart. For viewing the interactive map, the Google Maps Flutter library is used. 

## How to run the SPAITR Map Server

### Prerequisites:
* Install Android Studio (I believe VSCode can also be used, but I'm not familiar with it). Install information can be found [here](https://developer.android.com/studio/)
* Obtain a Google API key. This can be done through the Google Cloud platform. Information on how to get one can be found [here](https://cloud.google.com/docs/authentication/api-keys)
* Enable the following APIs within the Google Cloud Platform (info for how to do this can be found [here](https://cloud.google.com/endpoints/docs/openapi/enable-api)): 
    * Geocoding API
    * Maps JavaScript API
    * Maps SDK for Android
    * Maps SDK for iOS
    * Places API
* Start up an instance of the SPAITR-MAP server for the app to connect to. This information can be found [here](../server/README.md). 

### Instructions:
1. Load the project in Android Studio from the `spaitr-map/client` context. You might be prompted by Android Studio to install Flutter related plugins which you will want to do.
2. Add your Google API Key to the following locations where it mentions `<INSERT_GOOGLE_API_KEY_HERE>`:
    1. `spaitr-map/client/lib/tools/constants.dart`. This is for the app code to make calls to Google Services.
    2. `spaitr-map/client/ios/Runner/AppDelegate.swift`. This is for the iOS app to connect to Google Services.
    3. `spaitr-map/client/android/app/src/main/AndroidManifest.xml`. This is for the Android app to connect to Google Services.
    4. `spaitr-map/client/web/index.html`. This is for the website to connect to Google Services (not necessary. I found this faster on my computer than building to Android everytime, but app is aimed to be for only iOS/Android).
3. Add the SPAITR Map server URL to the `spaitr-map/client/lib/tools/constants.dart` file where it mentions `<INSERT_SERVER_URL_HERE>`.
4. You are all set to run the app! This can be done through connecting a device or by running an emulator.

## Past Change Notes
main.dart changes:
I added a few properties under the MapSampleState class that will be used for user location.
A new method exists called locatePosition() which uses the properties to locate the position of the current user.
There are some comments above the _UNH variable and in other places where I added new things.

Android/iOS location access permissions:
I added tags in the Info.plist file for iOS and in the AndroidManifest.xml file for Android. 
They enable the app to ask for permission to use the current users' location info.

pubspec.yaml changes:
There's a new dependency under the pubspec.yaml file called geolocator with the value ^7.7.0. I believe that's the version.

Here is the geolocator package for reference: https://pub.dev/packages/geolocator

