import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:spaitr_map/blocs/app_bloc.dart';

import 'main.dart';

class CreateGameScreen extends StatelessWidget {
  static const String _API_KEY = 'AIzaSyCV6p-3w00O6rgu-QDCwR31qqMpuDy-XiQ';
  // ----------- The lists are for testing static coordinates -------------
  final Map<String, LatLng> entries = {
    'UNH Bremner Field': const LatLng(43.1383086, -70.9447137),
    'UNH Student Rec Field': const LatLng(43.1383086, -70.9447137),
    'Portsmouth Leary Field': const LatLng(43.0714545, -70.7585335)
  };
  final List<String> entriesKeys = [
    'UNH Bremner Field',
    'UNH Student Rec Field',
    'Portsmouth Leary Field'
  ];
  final List<int> colorCodes = <int>[500, 500, 500];
  var applicationBloc;
  bool entriesATapped = false;
  bool entriesBTapped = false;
  bool entriesCTapped = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Create A Pickup Game'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Search Location',
                    suffixIcon: Icon(Icons.search)),
                // This takes types characters and updates autocomplete live
                // Currently only returns null because 'searchPlaces' is null
                // (Work-in-progress)
                onChanged: (value) => applicationBloc.searchPlaces(value),
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const Text(
                'Choose Game Location:',
                style: TextStyle(fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
              Container(
                  height: 300.0,
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text('Location: ${entriesKeys[index]}'),
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                            ),
                            tileColor: Colors.blue[colorCodes[index]],
                            onTap: () {
                              if (index == 0) {
                                entriesATapped = true;
                                print('Tapped 1');
                              } else if (index == 1) {
                                entriesBTapped = true;
                                print('Tapped 2');
                              } else if (index == 2) {
                                entriesCTapped = true;
                                print('Tapped 3');
                              }
                            },
                          ),
                        );
                      }))
            ]),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            LocationDataModel ldm;
            if (entriesATapped) {
              // Send Bremner Field as location
              ldm = LocationDataModel(entriesKeys[0], entries[0]);
            } else if (entriesBTapped) {
              // Send Student Rec Field as location
              ldm = LocationDataModel(entriesKeys[1], entries[1]);
            } else if (entriesCTapped) {
              // Send Portsmouth Leary Field as location
              ldm = LocationDataModel(entriesKeys[2], entries[2]);
            } else {
              // Send back UNH as default location
              ldm =
                  LocationDataModel('UNH', const LatLng(42.364471, -71.053261));
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyHomePage(title: 'Map', locationDataModel: ldm)));
          },
          child: const Icon(Icons.add),
        ),
      );
}

/*----------------- Autocomplete live results code ------------------------
class CreateGameScreen extends StatelessWidget {
  static const String _API_KEY = 'AIzaSyCV6p-3w00O6rgu-QDCwR31qqMpuDy-XiQ';

  var applicationBloc;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Create A Pickup Game'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Search Location',
                    suffixIcon: Icon(Icons.search)),
                // This takes types characters and updates autocomplete live
                // Currently only returns null because 'searchPlaces' is null
                // (Work-in-progress)
                onChanged: (value) => applicationBloc.searchPlaces(value),
              ),
            ),
            Stack(
              children: [
                // Minimap
                Container(
                  height: 300,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(applicationBloc.currentLocation.latitude,
                            applicationBloc.currentLocation.longitude),
                        zoom: 14),
                  ),
                ),
                // Results box appearance and disappearance...
                // if no characters typed in search box.
                if (applicationBloc.searchResults != null &&
                    applicationBloc.searchResults.length != 0)
                  Container(
                    height: 300.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.6),
                        backgroundBlendMode: BlendMode.darken),
                  ),
                // autocomplete Results
                Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: applicationBloc.searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            applicationBloc.searchResults[index].description,
                            style: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                )
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(title: 'Map')));
          },
          child: const Icon(Icons.add),
        ),
      );
}
*/

/* ------------------ Original code ---------------------------------
class CreateGameScreen extends StatelessWidget {
  static const String _API_KEY = 'AIzaSyCV6p-3w00O6rgu-QDCwR31qqMpuDy-XiQ';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Create A Pickup Game'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(title: 'Map')));
          },
          child: const Icon(Icons.add),
        ),
      );
}
*/