import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spaitr_map/blocs/app_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spaitr_map/core/bool_response.dart';
import 'package:spaitr_map/rest/rest_api.dart';

import 'models/place_search.dart';

// StatefulWidget so that map and autocomplete can update their view
class CreateGame extends StatefulWidget {
  // late Position currentPosition;

  final LatLng currentLocation;

  const CreateGame(this.currentLocation, { Key? key }) : super(key: key);

  @override
  State<CreateGame> createState() => CreateGameState();
}

class Validators {
  static bool validateNewGameSettings(String gameTime, String gameDate) {
    if (gameDate.isEmpty) {
      return false;
    }

    if (gameTime.isEmpty) {
      return false;
    }

    return true;
  }
}

class CreateGameState extends State<CreateGame> {
  ApplicationBloc applicationBloc = ApplicationBloc();

  final textEditingController = TextEditingController();
  late GoogleMapController googleMapController;
  final Completer<GoogleMapController> _controller = Completer();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  bool _disableMapMove = true;
  int _playerAmount = 1;
  String gameTime = "";
  String gameDate = "";
  List<PlaceSearch> autocompleteResults = [];
  double currLatitude = 0.0;
  double currLongitude = 0.0;

  var restAPI = RestAPI();

  @override
  void dispose() {
    // other dispose methods
    textEditingController.dispose();
    googleMapController.dispose();
    dateController.dispose();

    super.dispose();
  }

  void sendToastMessage(BuildContext context, String msgText) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
            msgText,
            textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1250),
        backgroundColor: Colors.black12.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)))
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              SizedBox(
                height: 300,
                child: GoogleMap(
                    mapType: MapType.normal,

                    zoomGesturesEnabled: _disableMapMove,
                    scrollGesturesEnabled: _disableMapMove,
                    tiltGesturesEnabled: _disableMapMove,
                    rotateGesturesEnabled: _disableMapMove,
                    zoomControlsEnabled: _disableMapMove,

                    initialCameraPosition: CameraPosition(
                        target: LatLng(widget.currentLocation.latitude, widget.currentLocation.longitude),
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
              SizedBox(
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
                              currLatitude = coordinate.latitude;
                              currLongitude = coordinate.longitude;

                              googleMapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      CameraPosition(
                                          target: coordinate, zoom: 16)));
                            });
                          });
                        }
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),

            // Date Picker
            child: TextField(
              textAlign: TextAlign.center,
              readOnly: true,
              controller: dateController,
              decoration: const InputDecoration(
                  hintText: 'Pick your Date'
              ),
              onTap: () async {
                _disableMapMove = false;
                setState(() => {});

                var date =  await showDatePicker(
                    context: context,
                    initialDate:DateTime.now(),
                    firstDate:DateTime.now(),
                    lastDate: DateTime(2100)
                );

                String rawDate = date.toString().substring(0, 10);
                String formattedDate = DateFormat.MEd().format(DateFormat("yyyy-MM-dd").parseLoose(rawDate));

                dateController.text = formattedDate;
                gameDate = rawDate;

                _disableMapMove = true;
                setState(() => {});
              },
            ),

          ),
          // Time Picker
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              readOnly: true,
              controller: timeController,
              decoration: const InputDecoration(
                  hintText: 'Pick your Time'
              ),
              onTap: () async {
                _disableMapMove = false;
                setState(() => {});

                var time =  await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 10, minute: 47),
                );
                String rawTime = time.toString().substring(10, 15);
                String formattedTime = DateFormat.jm().format(DateFormat("hh:mm").parse(rawTime));
                timeController.text = formattedTime;
                gameTime = rawTime;

                _disableMapMove = true;
                setState(() => {});
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => setState(() {
                  final newValue = _playerAmount - 1;
                  _playerAmount = newValue.clamp(0, 16);
                }),
              ),
              Text('Max Players: $_playerAmount'),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() {
                  final newValue = _playerAmount + 1;
                  _playerAmount = newValue.clamp(0, 16);
                }),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Return back to the home screen and bring the game position for it to display on map
          if (Validators.validateNewGameSettings(gameTime, gameDate)) {
            sendToastMessage(context, "Creating game...");

            restAPI.createGame(
                gameTime,
                gameDate,
                _playerAmount,
                currLatitude,
                currLongitude).then((BoolResponse serverResponse) {
                  if (serverResponse.boolResponse) {
                    Navigator.pop(context, LatLng(currLatitude, currLongitude));
                  } else {
                    sendToastMessage(context, serverResponse.errorMessage);
                  }
                }
            );

          } else {
            sendToastMessage(context, "There was an error validating game...");
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}