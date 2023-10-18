
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../colors.dart';

class FilmHallLocation extends StatefulWidget {
  const FilmHallLocation({Key? key}) : super(key: key);

  @override
  _FilmHallLocationState createState() => _FilmHallLocationState();
}

class _FilmHallLocationState extends State<FilmHallLocation> {
  final LatLng _filmHallLocation =
      const LatLng(6.9552417712128705, 80.20619311258943);
  late GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }


  final Uri toLaunchMaps = Uri(
    scheme: 'https',
    host: 'www.google.com',
    path: 'maps/dir/',
    queryParameters: {
      'api': '1',
      'destination': '6.9552417712128705,80.20619311258943',
    },
  );

  Future<void> _openDirectionsInGoogleMaps(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Film Hall Location'),
          backgroundColor: kc1,
        ),
        body: Container(
          child: SafeArea(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _filmHallLocation,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('filmHall'),
                  position: _filmHallLocation,
                  infoWindow: const InfoWindow(title: 'Film Hall'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              },
            ),
          ),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            onPressed: () => _openDirectionsInGoogleMaps(toLaunchMaps),
            child: const Icon(
              Icons.directions,
              color: kc3,
            ),
            backgroundColor: kc2,
          ),
        ));
  }
}
