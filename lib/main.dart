import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spaitr_map/create_game.dart';
import 'package:spaitr_map/rest/rest_api.dart';
import 'package:google_maps_flutter_platform_interface/src/types/marker_updates.dart';

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

// // New Location Point Constructor
// // Used when psuhing location data from create page to main page
// class LocationDataModel {
//   LocationDataModel(String name, coordinates) {
//     MapSampleState.newName = name;
//     MapSampleState.newLocation = coordinates;
//   }
// }

// Added from https://pub.dev/packages/google_maps_flutter
class MapSampleState extends State<MyHomePage> {
  final Completer<GoogleMapController> _controller = Completer();

  var currentPosition; // current position of user
  var newGoogleMapController;

  var geoLocator = Geolocator();
  var restAPI = RestAPI();

  static var newName;
  static var newLocation; // New location to make as point

  // This method is called when map is first opened.
  // It gets the current position of the user and displays it.
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    fetchNearbyGames(position.latitude, position.longitude);

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
  }

  @override
  Widget build(BuildContext context) {
    double mapOpacity = 1.0;

    return ChangeNotifierProvider(
      create: (context) => ApplicationBloc(),
      child: Scaffold(
        /*
          AnimatedOpacity here because there seems to be an issue sometimes with Google Maps showing
           up blank when returning to the screen from another page on my android phone. AnimatedOpacity
           seems to make it happen less, found it from this solution here:
           https://github.com/flutter/flutter/issues/39797#issuecomment-865704834

           Looks to be like a bug that other people are experiencing too,
           issue is still open on Flutter's end.

           Another example:
           https://github.com/flutter/flutter/issues/40284
         */
        body: AnimatedOpacity(
            curve: Curves.fastOutSlowIn,
            opacity: mapOpacity,
            duration: const Duration(milliseconds: 600),
            child: GoogleMap(
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
            )
        ),
        floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  // Open up create game page and wait until it receives a result back of the new game position
                  var newGamePosition = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const CreateGame()));

                  var newMarkers = mapPoints;
                  if (newGamePosition != null) {
                    newGoogleMapController
                        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newGamePosition, zoom: 14)));
                    newMarkers.add(Marker(markerId: MarkerId("${newMarkers.length + 1}"), position: newGamePosition));
                  }

                  updateMarkers(newMarkers);

                  setState(() {
                    // Seems to maybe make map appear blank less often on android phone
                    mapOpacity = 1.0;
                  });
                },
                label: const Text('Create A New Game'),
                icon: const Icon(Icons.add_location),
              ),
            ),
      );
  }
}
