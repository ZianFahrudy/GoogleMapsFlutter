// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemapsflutter/confirmation_address.dart';

class MapsPage extends StatefulWidget {
  const MapsPage(
      {Key? key,
      required this.location,
      this.onConfirmation,
      required this.address})
      : super(key: key);

  final ValueNotifier<LatLng> location;
  final TextEditingController address;
  final Function(LatLng latLng)? onConfirmation;

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng _currentPositioned;
  String addressLine = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentPositioned = widget.location.value;
    });

    if (widget.address.text.isEmpty) {
      getCurrentLocation();
    } else {
      setState(() {
        addressLine = widget.address.text;
      });
    }
  }

  /// Get current location from gps
  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      setState(() {
        _currentPositioned = LatLng(value.latitude, value.longitude);
      });

      getAddress(LatLng(value.latitude, value.longitude));
      _updateCamera();
    });
  }

  /// Get address text
  Future<void> getAddress(LatLng position) async {
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
        });
      },
    );
  }

  /// Update pisition when drag map
  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentPositioned = position.target;
    });
    getAddress(LatLng(position.target.latitude, position.target.longitude));
  }

  Future<void> _updateCamera() async {
    final controller = await _controller.future;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _currentPositioned,
          zoom: 18,
        ),
      ),
    );
  }

  Marker _createMarker() {
    return Marker(
      markerId: const MarkerId('MarkerId'),
      position: _currentPositioned,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPositioned,
                zoom: 18,
              ),
              onMapCreated: _controller.complete,
              zoomControlsEnabled: false,
              onCameraMove: _onCameraMove,
              markers: <Marker>{_createMarker()},
            ),
            Positioned(
              bottom: 244,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.surface,
                onPressed: getCurrentLocation,
                child: Icon(
                  Icons.my_location,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            ConfirmationAddress(
              addressLine: addressLine,
              onConfirmation: () {
                if (widget.onConfirmation != null) {
                  widget.onConfirmation!(_currentPositioned);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
