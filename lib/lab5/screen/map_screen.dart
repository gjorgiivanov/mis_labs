import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mis_labs/lab5/data/constants.dart';
import 'package:mis_labs/lab5/model/list_item.dart';

class MapScreen extends StatefulWidget {
  final List<ListItem> _itemList;

  MapScreen(this._itemList);

  @override
  _MapScreenState createState() => _MapScreenState(_itemList);
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  final List<Marker> markers = <Marker>[];
  final List<ListItem> _items;
  double? userLat;
  double? userLon;

  _MapScreenState(this._items);

  @override
  void initState() {
    super.initState();
    getUserCurrentLocation();
    _setMarkers(_items);
  }

  Future<void> getUserCurrentLocation() async {
    try {
      final locData = await Location().getLocation();
      if (locData.latitude != null && locData.longitude != null) {
        setState(() {
          userLat = locData.latitude;
          userLon = locData.longitude;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("p");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 10,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  void _getShortestRoute(LatLng userLocationCoordinates,
      LatLng destinationLocationCoordinates) async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPI,
      PointLatLng(
          userLocationCoordinates.latitude, userLocationCoordinates.longitude),
      PointLatLng(destinationLocationCoordinates.latitude,
          destinationLocationCoordinates.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      addPolyLine(polylineCoordinates);
    }
  }

  void _setMarkers(List<ListItem> items) {
    for (var index = 0; index < items.length; index++) {
      markers.add(
        Marker(
          markerId: MarkerId(index.toString()),
          position: LatLng(
              items[index].location.latitude, items[index].location.longitude),
          infoWindow: InfoWindow(
            title: items
                .where((item) => item.location.equals(items[index].location))
                .map((item) => item.name)
                .join(', '),
            snippet:
                "${DateFormat.yMMMd().format(items[index].date)} at ${items[index].time.hour}:${items[index].time.minute} ${items[index].time.period.name.toUpperCase()}",
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () async {
            if (userLat != null && userLon != null) {
              LatLng destinationLocationCoordinates = LatLng(
                  items[index].location.latitude,
                  items[index].location.longitude);
              LatLng userLocationCoordinates = LatLng(userLat!, userLon!);
              _getShortestRoute(
                  userLocationCoordinates, destinationLocationCoordinates);
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map with the events locations'),
      ),
      body: userLat != null
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(userLat!, userLon!),
                zoom: 16,
              ),
              markers: Set<Marker>.of(markers),
              polylines: Set<Polyline>.of(polylines.values),
              mapType: MapType.normal,
              myLocationEnabled: true,
              compassEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            )
          : const Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
