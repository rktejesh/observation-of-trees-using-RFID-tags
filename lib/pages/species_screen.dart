import 'package:flutter/material.dart';

class SpeciesScreen extends StatefulWidget {
  final Map<String, dynamic> mp;
  const SpeciesScreen({Key? key, required this.mp}) : super(key: key);

  @override
  State<SpeciesScreen> createState() => _SpeciesScreenState();
}

class _SpeciesScreenState extends State<SpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text("Plant Tag"),),
      body: ListView(
        children: [
          ListTile(
            title: Text("kingdom"),
            trailing: Text(widget.mp["kingdom"].toString()),
          ),
          ListTile(
            title: Text("phylum"),
            trailing: Text(widget.mp["phylum"].toString()),
          ),
          ListTile(
            title: Text("family"),
            trailing: Text(widget.mp["family"].toString()),
          ),
          ListTile(
            title: Text("Genus"),
            trailing: Text(widget.mp["genus"].toString()),
          ),
          ListTile(
            title: Text("Species"),
            trailing: Text(widget.mp["species"].toString()),
          ),
        ],
      ),
    );
  }
}
