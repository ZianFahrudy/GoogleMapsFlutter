import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapsflutter/map_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final addressController = TextEditingController();
  final latLongController = TextEditingController();
  final ValueNotifier<LatLng> location =
      ValueNotifier<LatLng>(const LatLng(-7.766354706341709, 110.33551839537));

  // final Completer<GoogleMapController> _mapController = Completer();

  GoogleMapController? _mapController;

  String addressLine = '';

  @override
  void initState() {
    super.initState();
  }

  /// get update location with the last longitude and latitude
  void getUpdateLocation(LatLng pos) {
    setState(() {
      addressLine = '';
      location.value = pos;
      _goToMyLocation();
      _getAddress(pos);
    });
  }

  Marker _createMarker() {
    return Marker(
      markerId: const MarkerId('MarkerId'),
      position: location.value,
    );
  }

  Future<void> _getAddress(LatLng position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude).then(
      (value) {
        setState(() {
          final administrativeArea = value.first.administrativeArea ?? '';
          final locality = value.first.locality ?? '';
          final street = value.first.street ?? '';
          final subAdministrativeArea = value.first.subAdministrativeArea ?? '';
          final subLocality = value.first.subLocality ?? '';

          addressLine =
              '''$street, $subLocality, $locality, $subAdministrativeArea, $administrativeArea''';
          addressController.text = addressLine;
          latLongController.text =
              '''${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}''';
        });
      },
    );
  }

  Future<void> _goToMyLocation() async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location.value,
          zoom: 18,
        ),
      ),
    );
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: location.value, zoom: 18),
        onMapCreated: onMapCreated,
        zoomControlsEnabled: false,
        zoomGesturesEnabled: false,
        liteModeEnabled: true,
        markers: <Marker>{_createMarker()},
        onTap: (latlng) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MapsPage(
                address: addressController,
                location: location,
                onConfirmation: (value) {
                  getUpdateLocation(value);
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
