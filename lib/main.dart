import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spaitr_map/create_game.dart';

import 'blocs/app_bloc.dart';

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
      home: MyHomePage(
        title: 'SPAITR Map',
        locationDataModel:
            LocationDataModel('UNH', const LatLng(42.364471, -71.053261)),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final LocationDataModel locationDataModel;
  const MyHomePage(
      {Key? key, required this.title, required this.locationDataModel})
      : super(key: key);

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

// New Location Point Constructor
// Used when psuhing location data from create page to main page
class LocationDataModel {
  LocationDataModel(String name, coordinates) {
    MapSampleState.newName = name;
    MapSampleState.newLocation = coordinates;
  }
}

// Added from https://pub.dev/packages/google_maps_flutter
class MapSampleState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  var currentPosition; // current position of user
  var newGoogleMapController;

  var geoLocator = Geolocator();

  static var newName;
  static var newLocation; // New location to make as point

  // This method is called when map is first opened.
  // It gets the current position of the user and displays it.
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPositon =
        CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPositon));
  }

  // This is where the map starts from, coordinates of UNH
  // Elvis's comment: The "TODO" above is implemented in the above method.
  static const CameraPosition _kUNH = CameraPosition(
    target: LatLng(43.137180, -70.932732),
    zoom: 14.4746,
  );

  // List of created game points on the map
  List<Marker> mapPoints = [];

  @override
  void initState() {
    mapPoints.add(Marker(
        markerId: MarkerId(newName),
        draggable: false,
        onTap: () {
          print('Marker Tapped');
        },
        position: newLocation));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: Scaffold(
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kUNH,
          myLocationEnabled: true,
          zoomGesturesEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            newGoogleMapController = controller;

            locatePosition(); // calls method that gets current user location.
          },
          // Set newly created point on the map (Work-in-Progress)
          markers: Set.from(mapPoints),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateGameScreen()));
          },
          label: const Text('Create A New Game'),
          icon: const Icon(Icons.add_location),
        ),
      ),
    );
  }
}
