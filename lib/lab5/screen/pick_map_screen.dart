import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mis_labs/lab5/model/location.dart';

class PickMapScreen extends StatefulWidget {
  final Location initialLocation;
  final bool isSelecting;

  PickMapScreen({
    this.initialLocation = const Location(
        latitude: 41.43782472791181, longitude: 22.640611996137377),
    this.isSelecting = false,
  });

  @override
  _PickMapScreenState createState() => _PickMapScreenState();
}

class _PickMapScreenState extends State<PickMapScreen> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: <Widget>[
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: {
          Marker(
            markerId: MarkerId('m1'),
            position: _pickedLocation != null
                ? _pickedLocation!
                : const LatLng(41.43782472791181, 22.640611996137377),
          ),
        },
      ),
    );
  }
}
