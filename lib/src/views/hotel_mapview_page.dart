import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:rolanda/src/constants/colors.dart';

class HotelMapviewPage extends StatefulWidget {
  const HotelMapviewPage({super.key});

  @override
  State<HotelMapviewPage> createState() => _HotelMapviewPageState();
}

class _HotelMapviewPageState extends State<HotelMapviewPage> {
  final _defaultPosition = GeoPoint(latitude: -6.181240, longitude: 35.748160);
  final _destinationPosition =
      GeoPoint(latitude: -6.814920, longitude: 39.288410);
  late MapController _mapController;

  Future<void> _addDestinationMarker() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      await _mapController.addMarker(_defaultPosition,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              size: 40,
              color: redColor,
            ),
          ));
      await _mapController.addMarker(_destinationPosition,
          markerIcon: const MarkerIcon(
            icon: Icon(
              Icons.location_on,
              size: 40,
              color: blackColor,
            ),
          ));
      await _mapController.moveTo(_defaultPosition, animate: true);
      double currentZoom = 4.0;
      double targetZoom = 15.0;
      double stepSize = 0.1;
      await Future.delayed(const Duration(milliseconds: 1000));
      for (double zoomLevel = currentZoom;
          zoomLevel <= targetZoom;
          zoomLevel += stepSize) {
        await _mapController.setZoom(zoomLevel: zoomLevel);

        await Future.delayed(const Duration(milliseconds: 5));
      }
      await _mapController.moveTo(_defaultPosition, animate: true);
    });
    Future.delayed(Duration(milliseconds: 3), () async {
      await _mapController.drawRoad(_defaultPosition, _destinationPosition,
          roadOption: RoadOption(
            roadWidth: 7,
            roadBorderWidth: 5,
            roadBorderColor: blackColor,
            roadColor: redColor,
          ));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mapController = MapController(initPosition: _defaultPosition);
    _addDestinationMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OSMFlutter(controller: _mapController, osmOption: OSMOption()),
    );
  }
}
