import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sale_garage_platform/components/back_button.dart';

class ItemMapScreen extends StatefulWidget {
  final GeoFirePoint geoPoint;

  const ItemMapScreen({Key key, @required this.geoPoint}) : super(key: key);

  @override
  _ItemMapScreenState createState() => _ItemMapScreenState();
}

class _ItemMapScreenState extends State<ItemMapScreen> {
  GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    GeoFirePoint point = widget.geoPoint;
    return Scaffold(

      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(point.latitude, point.longitude),
                zoom: 12,
              ),
              onMapCreated: _onMapCreated,
              mapType: MapType.normal,
              myLocationEnabled: true,
              markers: _createMarkers(),
            ),
            TopBackBtn(),
          ],
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return <Marker>[
      Marker(
        markerId: MarkerId(widget.geoPoint.toString()),
        position: LatLng(widget.geoPoint.latitude, widget.geoPoint.longitude),
        icon: BitmapDescriptor.defaultMarker,
      )
    ].toSet();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
