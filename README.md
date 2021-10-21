# SPAITR-MAP

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
