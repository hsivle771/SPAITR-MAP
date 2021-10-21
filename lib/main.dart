import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPAITR Map',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SPAITR Map'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override

  State<MyHomePage> createState() => MapSampleState();
}

// Added from https://pub.dev/packages/google_maps_flutter
class MapSampleState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  // This is where the map starts from, coordinates of UNH
  // TODO: Probably have this go to user's location automatically
  static const CameraPosition _kUNH = CameraPosition(
    target: LatLng(43.137180, -70.932732),
    zoom: 14.4746,
  );

  // Clicking the button goes to these coordinates
  static const CameraPosition _kBoston = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(42.364471, -71.053261),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kUNH,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToBoston,
        label: const Text('To Boston!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToBoston() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kBoston));
  }
}