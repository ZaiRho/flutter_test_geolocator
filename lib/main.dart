import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Geolocator Demo'),
        ),
        body: GeolocatorDemo(),
      ),
    );
  }
}

class GeolocatorDemo extends StatefulWidget {
  @override
  _GeolocatorDemoState createState() => _GeolocatorDemoState();
}

class _GeolocatorDemoState extends State<GeolocatorDemo> {
  Position? initialPosition;
  Position? finalPosition;
  double distance = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (initialPosition != null)
          Text(
              "Initial Position: ${initialPosition?.latitude}, ${initialPosition?.longitude}"),
        if (finalPosition != null)
          Text(
              "Final Position: ${finalPosition?.latitude}, ${finalPosition?.longitude}"),
        if (distance > 0)
          Text("Distance: ${distance.toStringAsFixed(2)} meters"),
        ElevatedButton(
          onPressed: () async {
            Position currentPosition = await _determinePosition();
            setState(() {
              initialPosition = currentPosition;
            });
          },
          child: Text('Save Initial Position'),
        ),
        ElevatedButton(
          onPressed: () async {
            Position currentPosition = await _determinePosition();
            setState(() {
              finalPosition = currentPosition;
              if (initialPosition != null) {
                distance = Geolocator.distanceBetween(
                  initialPosition!.latitude,
                  initialPosition!.longitude,
                  finalPosition!.latitude,
                  finalPosition!.longitude,
                );
              }
            });
          },
          child: Text('Save Final Position'),
        ),
        ElevatedButton(
          onPressed: () {
            if (finalPosition != null) {
              setState(() {
                distance = Geolocator.distanceBetween(
                  initialPosition!.latitude,
                  initialPosition!.longitude,
                  finalPosition!.latitude,
                  finalPosition!.longitude,
                );
              });
            }
          },
          child: Text('Calculate Distance'),
        ),
      ],
    );
  }

  Future<Position> _determinePosition() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      throw Exception("Location permission is required to use this feature.");
    }
  }
}
