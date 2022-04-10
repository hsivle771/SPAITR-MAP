import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spaitr_map/create_game.dart';
import 'package:spaitr_map/rest/rest_api.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker_updates.dart';
import 'package:spaitr_map/settings.dart';

import 'blocs/app_bloc.dart';
import 'core/game.dart';

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
  // final LocationDataModel locationDataModel;
  const MyHomePage(
      {Key? key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => MapSampleState();
}

// Added from https://pub.dev/packages/google_maps_flutter
class MapSampleState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng currentPosition = LatLng(0, 0); // current position of user
  late GoogleMapController newGoogleMapController;

  var geoLocator = Geolocator();
  var restAPI = RestAPI();

  // List of created game points on the map
  List<Marker> mapPoints = [];

  String username = "";

  // Map defaults to UNH address until user location is determined
  static const CameraPosition _kUNH = CameraPosition(
    target: LatLng(43.137180, -70.932732),
    zoom: 14.4746,
  );

  // This method is called when map is first opened.
  // It gets the current position of the user and displays it.
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = LatLng(position.latitude, position.longitude);

    fetchNearbyGames(position.latitude, position.longitude);

    CameraPosition cameraPositon =
        CameraPosition(target: currentPosition, zoom: 16);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPositon));
  }

  void fetchNearbyGames(double xCoor, double yCoor) {
    List<Marker> newMarkers = [];

    restAPI.fetchGames(xCoor, yCoor).then((List<Game> games) {
      for (var game in games) {
        newMarkers.add(
            Marker(
              markerId: MarkerId(game.id),
              position: LatLng(game.coorX, game.coorY),
              onTap: () {
                print("Game ${game.id}");
              },
            )
        );
      }

      // Updates the markers on the map
      updateMarkers(newMarkers);
    });
  }

  void updateMarkers(List<Marker> newMarkers) {
    // Found to do this from https://github.com/flutter/flutter/issues/54515#issuecomment-673369050
    setState(() {
      MarkerUpdates.from(
          Set<Marker>.from(mapPoints), Set<Marker>.from(newMarkers));
      mapPoints = [];
      mapPoints = newMarkers;
    });
  }

  @override
  void initState() {
    super.initState();

    // Username is initially set to Player<random number 1-999>
    // In the settings menu, you can choose to edit the username
    var random = Random();
    username = "Player" + random.nextInt(999).toString();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),

      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.map),
          backgroundColor: Colors.blue,
          title: const Text("SPAITR Map"),
          actions: [
            IconButton(
              onPressed: () async {
                var newUsername = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings(username)));
                username = newUsername;
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: GoogleMap(
              mapType: MapType.normal,
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
              onPressed: () async {
                // Open up create game page and wait until it receives a result back of the new game position
                var newGamePosition = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateGame(currentPosition)));

                var newMarkers = mapPoints;
                if (newGamePosition != null) {
                  newGoogleMapController
                      .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newGamePosition, zoom: 16)));
                  newMarkers.add(Marker(markerId: MarkerId("${newMarkers.length + 1}"), position: newGamePosition));
                }

                updateMarkers(newMarkers);
              },
              label: const Text('Create Game'),
              icon: const Icon(Icons.add_location),
            ),
      ),
    );
  }
}
