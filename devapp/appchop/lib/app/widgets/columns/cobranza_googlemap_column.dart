import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/color_list.dart';

class CobranzaGooglemapColumn extends StatelessWidget {
  final Set<Marker> markers;
  final LatLng target;
  final CustomInfoWindowController? googleController;
  final void Function(LatLng) onTap;
  final double zoom;
  final void Function(bool)? onChanged;
  final bool value;
  const CobranzaGooglemapColumn({
    super.key,
    this.markers = const <Marker>{},
    required this.target,
    this.googleController,
    required this.onTap,
    this.zoom = 19,
    required this.onChanged,
    this.value = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding:const EdgeInsets.all(10,),
          child: Text(
            'Ubicación del cliente',
            style: TextStyle(
              color: Color(ColorList.sys[0]),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(
              'Utilizar esta ubicacion',
              style: TextStyle(
                color: Color(ColorList.sys[0]),
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              minFontSize: 12,
            ),
            Container(
              padding: const EdgeInsets.all(0),
              child: Transform.scale(
                scale: 0.7,
                child: Switch(
                  thumbColor: MaterialStateProperty.all(Color(ColorList.sys[0])),
                  activeTrackColor: Color(ColorList.sys[1]),
                  inactiveTrackColor: Color(ColorList.sys[2]),
                  value: value,
                  onChanged: onChanged,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            rotateGesturesEnabled: false,
            zoomGesturesEnabled: false,
            tiltGesturesEnabled: false,
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: target,
              zoom: zoom,
            ),
            onTap: onTap,
            onCameraMove: (position) {
              googleController!.onCameraMove!();
            },
            onMapCreated: (GoogleMapController googleMapController) {
              googleController!.googleMapController = googleMapController;
            },
          ),
        ),
      ],
    );
  }
}