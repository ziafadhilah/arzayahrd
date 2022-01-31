import 'dart:collection';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:magentahrdios/services/api_clien.dart';
import 'package:magentahrdios/utalities/color.dart';

import 'package:magentahrdios/utalities/fonts.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsDetail extends StatefulWidget {
  @override
  _MapsDetailState createState() => _MapsDetailState();

  MapsDetail(
      {this.address,
        this.longitude,
        this.latitude,
        this.gender,
        this.last_name,
        this.firts_name,
        this.profile_background,
        this.distance,
        this.longMainoffice,
        this.latmainoffice,
        this.image,
        this.departement_name});

  var address,
      latitude,
      longitude,
      gender,
      firts_name,
      last_name,
      profile_background,
      distance,
      latmainoffice,
      longMainoffice,
      image,
      departement_name;
}

class _MapsDetailState extends State<MapsDetail> {
  // GoogleMapController? _controller;
  Position? position;

  // BitmapDescriptor? companyIcon;
  var employee_id;
  var _latmainoffice, _longmainoffice;

  final center = LatLng(-11.989816, -77.063096);
  MapboxMapController? mapController;

  Widget _child = Center(
    child: Text('Loading...'),
  );

  // BitmapDescriptor? _sourceIcon;

  double _pinPillPosition = -100;
  static const String ACCESS_TOKEN = String.fromEnvironment(
      "pk.eyJ1Ijoia2l0dG9rYXR0byIsImEiOiJja2t5eTducm4wYmhwMnFwNXI4ejA4cGhuIn0.xoSKS41bJtuetZ8v5p_aiQ");

  // PinData? _sourcePinInfo;

  Future<void> getPermission() async {
    // PermissionStatus permission = await PermissionHandler()
    //     .checkPermissionStatus(PermissionGroup.location);
    //
    // if (permission == PermissionStatus.denied) {
    //   await PermissionHandler()
    //       .requestPermissions([PermissionGroup.locationAlways]);
    // }
    //
    // var geolocator = Geolocator();
    //
    // GeolocationStatus geolocationStatus =
    // await geolocator.checkGeolocationPermissionStatus();
    //
    // switch (geolocationStatus) {
    //   case GeolocationStatus.denThe plugin `path_provider` uses a deprecated version of the Android embedding.ied:
    //     showToast('Access denied');
    //     break;
    //   case GeolocationStatus.disabled:
    //     showToast('Disabled');
    //     break;
    //   case GeolocationStatus.restricted:
    //     showToast('restricted');
    //     break;
    //   case GeolocationStatus.unknown:
    //     showToast('Unknown');
    //     break;
    //   case GeolocationStatus.granted:
    //     showToast('Accesss Granted');
    //     _getCurrentLocation();
    // }
  }

  void _getCurrentLocation() async {
    // Position res = await Geolocator().getCurrentPosition();
    // setState(() {
    //   position = res;
    //   _child = _mapWidget();
    // });
  }

  ///set raidus
  // Set<Circle> circles = Set.from([
  //
  //   Circle(
  //       circleId: CircleId("1"),
  //       center: LatLng(_longmainoffice, _longmainoffice),
  //       radius: 20,
  //       strokeColor: baseColor1,
  //       fillColor: baseColor.withOpacity(0.25),
  //       strokeWidth: 1)
  // ]);

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // void setSourceAndDestinationIcons() async {
  //   companyIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 2.5), 'assets/home.png');
  // }

  ///style map json
  // void _setStyle(GoogleMapController controller) async {
  //   String value = await DefaultAssetBundle.of(context)
  //       .loadString('assets/map_style.json');
  //
  //   controller.setMapStyle(value);
  // }

  // Widget _mapWidget() {
  //
  //   return GMap(document.getElementById("map-canvas"), mapOptions);
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            _map(),
            AnimatedPositioned(
              bottom: _pinPillPosition,
              right: 0,
              left: 0,
              duration: Duration(milliseconds: 200),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(20),
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 20,
                          offset: Offset.zero,
                          color: Colors.grey.withOpacity(0.5),
                        )
                      ]),
                ),
              ),
            ),
            new Positioned(
                top: MediaQuery.of(context).size.height * 0.6,
                child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(40.0),
                          topRight: const Radius.circular(40.0),
                        )),
                    child: _info()))
          ],
        ));
  }

  Widget _info() {
    return Container(
      child: Container(
        child: Column(
          children: <Widget>[
            ///widget profile
            Container(
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage(
                            "${image_ur}/${widget.profile_background}"),
                        backgroundColor: Colors.transparent,
                      )),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "${widget.firts_name}",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            "${widget.departement_name}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black38,
                            ),
                          ),
                        ),

                        //detail acount
                      ],
                    ),
                  ) //Container
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25, top: 20),
              //Row for time n location
              child: Row(
                children: <Widget>[
                  //container  icon location
                  Container(
                    child: Row(
                      children: <Widget>[
                        // Container(
                        //   child: Icon(
                        //     Icons.location_on,
                        //     color: Colors.black12,
                        //     size: 30,
                        //   ),
                        // ),
                        //container for name location
                        InkWell(
                          child: Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Alamat", style: subtitleMainMenu),
                                SizedBox(
                                  height: 10,
                                ),
                                if (widget.address != null &&
                                    widget.address != null)
                                  InkWell(
                                    onTap: () {
                                      mapController!.addSymbol(SymbolOptions(
                                          geometry: LatLng(
                                              double.parse(
                                                  widget.latmainoffice),
                                              double.parse(
                                                  widget.longMainoffice)),
                                          textField: "",
                                          iconImage: "assetImage",
                                          iconSize: 0.5,
                                          textOffset: Offset(0, 2)));

                                      mapController!.addSymbol(SymbolOptions(
                                          geometry: LatLng(
                                              double.parse(widget.latitude),
                                              double.parse(widget.longitude)),
                                          textField: "",
                                          iconImage: "assetImageEmployee",
                                          iconSize: 0.5,
                                          textOffset: Offset(0, 2)));
                                    },
                                    child: Container(
                                      width: Get.mediaQuery.size.width / 2 + 40,
                                      child: Text(
                                        widget.address,
                                        style: TextStyle(color: Colors.black38),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              color: Colors.amber.withOpacity(0.5),
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    margin:
                    EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
                    // child: Icon(
                    //   Icons.info,
                    //   color: Colors.black45,
                    // ),
                  ),
                  Container(
                      child: widget.distance > 20
                          ? Text(
                        "Anda berada di luar area kantor",
                        style: subtitleMainMenu,
                      )
                          : Text(
                        "Anda berada di dalam area kantor",
                        style: subtitleMainMenu,
                      ))
                ],
              ),
            )

            ///widget location
          ],
        ),
      ),
    );
  }

  void _setCircles() {
    // _circles.add(
    //   Circle(
    //       circleId: CircleId("0"),
    //       center: LatLng(double.parse(widget.latmainoffice), double.parse(widget.longMainoffice)),
    //       radius: 10,
    //       strokeColor: baseColor1,
    //       fillColor: baseColor.withOpacity(0.25),
    //       strokeWidth: 1),
    // );
  }

  void getDatapref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      employee_id = sharedPreferences.getString("employee_id");
    });
  }



  void _onMapCreated(MapboxMapController controller) async {
    mapController = controller;
    _onStyleLoaded();

  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController!.addImage(name, list);
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/office.png");
    addImageFromAsset("assetImageEmployee", "assets/emplyee_maps.png");
  }

  Widget _map() {
    // mapController.addSymbol(SymbolOptions(
    //   geometry:
    // ))

    return MapboxMap(
      accessToken:
      "pk.eyJ1Ijoia2l0dG9rYXR0byIsImEiOiJja2t5eTducm4wYmhwMnFwNXI4ejA4cGhuIn0.xoSKS41bJtuetZ8v5p_aiQ",
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: () {
        addCircle(mapController!);
        mapController!.addSymbol(SymbolOptions(
            geometry: LatLng(double.parse(widget.latmainoffice),
                double.parse(widget.longMainoffice)),
            textField: "",
            iconImage: "assetImage",
            iconSize: 0.5,
            textOffset: Offset(0, 2)));

        mapController!.addSymbol(SymbolOptions(
            geometry: LatLng(
                double.parse(widget.latitude), double.parse(widget.longitude)),
            textField: "",
            iconImage: "assetImageEmployee",
            iconSize: 0.5,
            textOffset: Offset(0, 2)));
      },
      initialCameraPosition: CameraPosition(
          target: LatLng(
              double.parse(widget.latitude), double.parse(widget.longitude)),
          zoom: 15),
    );
  }

  void addCircle(MapboxMapController mapController) {
    mapController.addCircle(CircleOptions(
        geometry: LatLng(double.parse(widget.latmainoffice),
            double.parse(widget.longMainoffice)),
        circleColor: "#3498db",
        circleStrokeColor: '#3498db',
        circleOpacity: 0.25,
        circleRadius: 20));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapController!.dispose();
  }

  @override
  void initState() {
    print(widget.departement_name);
    print(widget.profile_background);
    getPermission();
    // _setSourceIcon();
    super.initState();
    _setCircles();
  }
}
