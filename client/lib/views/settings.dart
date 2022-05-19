import 'dart:core';

import 'package:flutter/material.dart';
import 'package:spaitr_map/blocs/app_bloc.dart';

// StatefulWidget so that map and autocomplete can update their view
class Settings extends StatefulWidget {
  final String username;

  const Settings(this.username, {Key? key}) : super(key: key);

  @override
  State<Settings> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  ApplicationBloc applicationBloc = ApplicationBloc();
  String username = "";

  final textEditingController = TextEditingController();

  @override
  void dispose() {
    // other dispose methods
    textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    username = widget.username;
    textEditingController.text = widget.username;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, username);
          return false;
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  label: Text("Username"),
                ),
                controller: textEditingController,
                onChanged: (value) => {
                  username = value
                },
              ),
            ),
          ],
        ),
      )
    );
  }
}