import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spaitr_map/blocs/app_bloc.dart';

import 'models/place_search.dart';

// StatefulWidget so that map and autocomplete can update their view
class CreateGame extends StatefulWidget {
  const CreateGame({ Key? key }) : super(key: key);

  @override
  State<CreateGame> createState() => CreateGameState();
}

class CreateGameState extends State<CreateGame> {
  ApplicationBloc applicationBloc = ApplicationBloc();
  List<PlaceSearch> autocompleteResults = [];

  String searchBoxContents = "";

  LatLng currentGamePosition = const LatLng(43.1383086, -70.9447137);

  final textEditingController = TextEditingController();
  late GoogleMapController googleMapController;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void dispose() {
    // other dispose methods
    textEditingController.dispose();
    if (googleMapController != null) {
      googleMapController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          title: const Text('Create A Pickup Game'),
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search Location',
                  suffixIcon: Icon(Icons.search),
                ),

                controller: textEditingController,

                // This takes types characters and updates autocomplete live
                // Currently only returns null because 'searchPlaces' is null
                // (Work-in-progress)
                onChanged: (value) =>
                    applicationBloc.searchPlaces(value).then((
                        List<PlaceSearch> newAutocompleteResults) {
                      autocompleteResults = newAutocompleteResults;

                      // Updates the contents of the autocomplete list view
                      setState(() => {});
                    }),
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
                          target: currentGamePosition,
                          zoom: 14),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        googleMapController = controller;
                      }
                  ),
                ),
                // Results box appearance and disappearance...
                // if no characters typed in search box.
                if (autocompleteResults.isNotEmpty)
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
                    itemCount: autocompleteResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                              autocompleteResults[index].description,
                              style: const TextStyle(color: Colors.white)),
                          onTap: () {
                            textEditingController.text =
                                autocompleteResults[index].description;

                            applicationBloc.getCoordinate(
                                textEditingController.text).then((
                                LatLng coordinate) {
                              setState(() {
                                autocompleteResults = [];
                                currentGamePosition = coordinate;
                                googleMapController.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        CameraPosition(
                                            target: coordinate, zoom: 14)));
                              });
                            });
                          }
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
            // Return back to the home screen and bring the game position for it to display on map
            Navigator.pop(context, currentGamePosition);

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const MyHomePage(title: 'Map')));
          },
          child: const Icon(Icons.add),
        ),
      );

/*---Old build without autocomplete or mini map---*/
// @override
// Widget build(BuildContext context) => Scaffold(
//   appBar: AppBar(
//     title: const Text('Create A Pickup Game'),
//     centerTitle: true,
//   ),
//   body: ListView(
//     children: [
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextField(
//           decoration: InputDecoration(
//               hintText: 'Search Location',
//               suffixIcon: Icon(Icons.search)),
//           // This takes types characters and updates autocomplete live
//           // Currently only returns null because 'searchPlaces' is null
//           // (Work-in-progress)
//           onChanged: (value) => applicationBloc.searchPlaces(value),
//         ),
//       ),
//       Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//         const Text(
//           'Choose Game Location:',
//           style: TextStyle(fontSize: 25.0),
//           textAlign: TextAlign.center,
//         ),
//         Container(
//             height: 300.0,
//             width: double.infinity,
//             child: ListView.builder(
//                 itemCount: entries.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Text('Location: ${entriesKeys[index]}'),
//                       leading: SizedBox(
//                         width: 50,
//                         height: 50,
//                       ),
//                       tileColor: Colors.blue[colorCodes[index]],
//                       onTap: () {
//                         if (index == 0) {
//                           entriesATapped = true;
//                           print('Tapped 1');
//                         } else if (index == 1) {
//                           entriesBTapped = true;
//                           print('Tapped 2');
//                         } else if (index == 2) {
//                           entriesCTapped = true;
//                           print('Tapped 3');
//                         }
//                       },
//                     ),
//                   );
//                 }))
//       ]),
//     ],
//   ),
//   floatingActionButton: FloatingActionButton(
//     onPressed: () {
//       LocationDataModel ldm;
//       if (entriesATapped) {
//         // Send Bremner Field as location
//         ldm = LocationDataModel(entriesKeys[0], entries[0]);
//       } else if (entriesBTapped) {
//         // Send Student Rec Field as location
//         ldm = LocationDataModel(entriesKeys[1], entries[1]);
//       } else if (entriesCTapped) {
//         // Send Portsmouth Leary Field as location
//         ldm = LocationDataModel(entriesKeys[2], entries[2]);
//       } else {
//         // Send back UNH as default location
//         ldm =
//             LocationDataModel('UNH', const LatLng(42.364471, -71.053261));
//       }
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   MyHomePage(title: 'Map', locationDataModel: ldm)));
//     },
//     child: const Icon(Icons.add),
//   ),
// );
}
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
*/
