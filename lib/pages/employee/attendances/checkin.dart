import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'package:intl/intl.dart';
import 'package:js/js.dart';
import 'package:location/location.dart';
import 'package:arzayahrd/pages/employee/attendances/map.dart';
import 'package:arzayahrd/pages/employee/location/utalities/helper.dart';
import 'package:arzayahrd/services/api_clien.dart';
import 'package:arzayahrd/utalities/alert_dialog.dart';
import 'package:arzayahrd/utalities/color.dart';
import 'package:arzayahrd/utalities/fonts.dart';
import 'package:arzayahrd/vaidasi/validator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart' as Path;

import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:geocode/geocode.dart';

class CheckinPage extends StatefulWidget {
  @override
  _CheckinPageState createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> {
  ///variable
  File? _image;
  Map? _employee;
  bool _isLoading = true;
  bool _loading_image = true;
  bool _disposed = false;
  Uint8List webImage = Uint8List(10);
  File _file = File("0");

  Image? _photos;

  Location location = new Location();
  LocationData? _locationData;

  // final Geolocator geolocator = Geolocator();
  Position? _currentPosition;
  String? _currentAddress;
  String? _imagePath;
  GeoCode geoCode = GeoCode();
  var Cremark = new TextEditingController();
  var time,
      _latitude = "0.0",
      _longitude = "0.0",
      _employee_id,
      _check_in,
      _category_absent,
      _firts_name,
      _last_name,
      _profile_background,
      _gender,
      _departement_name,
      _lat_mainoffice,
      _long_mainoffice;
  String? base64;
  Validasi validator = new Validasi();
  double _distance = 0.0;

  ///main context
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // iconTheme: IconThemeData(
        //   color: Colors.white, //modify arrow color from here..
        // ),
        backgroundColor: baseColor,
        title: new Text(
          "Checkin",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto-medium",
              fontSize: 18,
              letterSpacing: 0.5),
        ),
      ),
      body: _isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height + 50,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child:
                            _distance > 20 ? _builddistaceCompany() : Text(""),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: _file.path == "0"
                            ? _buildPhoto(context)
                            : InkWell(
                                onTap: () {
                                  aksesCamera();
                                  //_onAddPhotoClicked(context);
                                },
                                child: Container(
                                    width: 200,
                                    height: 200,
                                    child: Image.memory(webImage))),
                      ),
                      _buildText(),
                      SizedBox(
                        height: 15,
                      ),
                      // _buildCategoryabsence(),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      _buildLocation(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildremark(),
                      SizedBox(
                        height: 10,
                      ),
                      _buildtime(),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              _buildfingerprint(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  ///widge widget
  //Widger photo default
  Widget _buildPhoto(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          aksesCamera();
          //_onAddPhotoClicked(context);
        },
        child: Container(
          margin: EdgeInsets.only(top: 15),
          child: Image.asset("assets/photo.png",
              width: 200, height: 200, fit: BoxFit.fill),
        ),
      ),
    );
  }

  // -------end photo default-----
  //Widget text
  Widget _buildText() {
    return Container(
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Text(
          "Take Your Photo",
          style: TextStyle(fontSize: 30, color: Colors.black38),
        ),
      ),
    );
  }

  //build remark
  // Widget _buildremark() {
  //   return Container(
  //     margin: EdgeInsets.only(left: 25, right: 20),
  //     child: TextFormField(
  //       controller: Cremark,
  //       cursorColor: Theme.of(context).cursorColor,
  //       maxLength: 100,
  //       decoration: const InputDecoration(
  //         icon: Icon(
  //           Icons.lock,
  //           color: Colors.black12,
  //         ),
  //         labelText: 'Catatan',
  //         labelStyle: TextStyle(
  //           color: Colors.black38,
  //         ),
  //         enabledBorder: UnderlineInputBorder(
  //             borderSide: BorderSide(
  //               color: Colors.black38,
  //             )),
  //       ),
  //     ),
  //   );
  // }

  //build remark
  Widget _buildremark() {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Catatan",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Roboto-mdium",
                  letterSpacing: 0.5)),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: Cremark,
            maxLines: 3,
            cursorColor: Theme.of(context).cursorColor,
            maxLength: 100,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(width: 0, color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: baseColor, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: blackColor.withOpacity(0.5), width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startJam() {
    Timer.periodic(new Duration(seconds: 1), (_) {
      var tgl = new DateTime.now();
      var formatedjam = new DateFormat.Hms().format(tgl);
      if (!_disposed) {
        setState(() {
          time = formatedjam;
          _getCurrentLocation();

          _getDistance(
              _lat_mainoffice, _long_mainoffice, _latitude, _longitude);
        });
      }
    });
  }

  Widget _buildtime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 20,
          margin: EdgeInsets.only(left: 25),
          child: TextFormField(
            enabled: false,
            cursorColor: Theme.of(context).cursorColor,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              icon: Icon(
                Icons.timer,
                color: Colors.black,
                size: 30,
              ),
              labelText: '$time',
              labelStyle: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontFamily: "Roboto-regular",
                  letterSpacing: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryabsence() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
      width: double.maxFinite,
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          Container(
            child: Icon(
              Icons.merge_type,
              color: Colors.black12,
              size: 30,
            ),
          ),
          Expanded(
            child: Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(left: 10),
              child: DropdownButton<String>(
                isExpanded: true,

                value: _category_absent,
                //elevation: 5,
                style: TextStyle(color: Colors.black),

                items: <String>[
                  'Present',
                  'Sick',
                  'Permission',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text(
                  "Present",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                onChanged: (String? value) {
                  // setState(() {
                  //   _category_absent = value;
                  // });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return Container(
      margin: EdgeInsets.only(left: 25),
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
                  onTap: () {
                    // print(_long_mainoffice);
                    // print(_lat_mainoffice);

                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: Maps(
                              address: _currentAddress,
                              longitude: _longitude,
                              latitude: _latitude,
                              firts_name: _firts_name,
                              last_name: _last_name,
                              profile_background: _profile_background,
                              gender: _gender,
                              departement_name: _departement_name,
                              distance: _distance,
                              latmainoffice: _lat_mainoffice,
                              longMainoffice: _long_mainoffice,
                            )));

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => Maps(
                    //               address: _currentAddress,
                    //               longitude: _long,
                    //               latitude: _lat,
                    //               firts_name: _firts_name,
                    //               last_name: _last_name,
                    //               profile_background: _profile_background,
                    //               gender: _gender,
                    //               departement_name: _departement_name,
                    //               distance: _distance,
                    //               latmainoffice: _lat_mainoffice,
                    //               longMainoffice: _long_mainoffice,
                    //             )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Lokasi",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Roboto-mdium",
                                letterSpacing: 0.5)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: Get.mediaQuery.size.width / 2 + 50,
                          child: Text(
                            "${_currentAddress ?? ""}",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontFamily: "Roboto-regular",
                                letterSpacing: 0.5,
                                fontSize: 13),
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
    );
  }

  //Widger photo
  Widget _buildfingerprint() {
    return InkWell(
      onTap: () {
        if (_currentAddress != null) {
          upload();
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),

        width: Get.mediaQuery.size.width,

        child: ElevatedButton(
            onPressed: () {
              if (_currentAddress != null) {
                upload();
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(baseColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              )),
            ),
            child: _currentAddress != null
                ? Text(
                    "Checkin",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Roboto-regular"),
                  )
                : Container(
                    width: 10,
                    height: 10  ,
                    child: CircularProgressIndicator(color: baseColor1,),
                  )),
        // child: Card(
        //   color: baseColor,
        //
        //   elevation: 1,
        //   shape: RoundedRectangleBorder(
        //
        //     borderRadius: BorderRadius.circular(30.0),
        //   ),
        //   child: Container(
        //     margin: EdgeInsets.all(15.0),
        //     child: Image.asset(
        //       "assets/fingerprint.png",
        //     ),
        //   ),
        // ),
      ),
    );
  }

  Future upload() async {
    print("data base 64 ${base64}");
    var date = DateFormat("yyyy:MM:dd").format(DateTime.now());
    if (_category_absent == null) {
      _category_absent = "Present";
    }

    if (_category_absent.toString().toLowerCase() != 'present') {
      if (base64.toString() == "null") {
        Toast.show("Foto wajib digunakan", context,
            duration: 5, gravity: Toast.BOTTOM);
      } else if (Cremark.text.toString().isEmpty) {
        Toast.show("Remarks tidak boleh kosong", context,
            duration: 5, gravity: Toast.BOTTOM);
      } else {
        Toast.show("$_category_absent", context);
        validation_checkin(
            context,
            base64.toString(),
            Cremark.text,
            _latitude.toString(),
            _longitude.toString(),
            _employee_id,
            date,
            time,
            _departement_name,
            _distance,
            _lat_mainoffice,
            _long_mainoffice,
            "present");
      }
    } else {
      validation_checkin(
          context,
          base64.toString(),
          Cremark.text,
          _latitude.toString(),
          _longitude.toString(),
          _employee_id,
          date,
          time,
          _departement_name,
          _distance,
          _lat_mainoffice,
          _long_mainoffice,
          _category_absent.toString().toLowerCase());
    }
  }

  ///fucntion
  //akses kamera
  aksesCamera() async {
    if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _file = File("a");
          base64 = base64Encode(f);
          webImage = f;
        });
      } else {
        toast_success("No file selected");
      }
    } else {
      toast_error("Permission not granted");
    }
    // final checkinImage =
    //     await ImagePicker().pickImage(source: ImageSource.camera);
    // if (checkinImage != null) {
    //   setState(() {
    //     _imagePath = checkinImage.path.toString();
    //     print("data phoho${checkinImage.path.toString()}");
    //     //_photos = checkinImage;
    //     // final bytes = File(checkinImage.path).readAsBytesSync();
    //     // base64 = base64Encode(bytes);
    //   });
    // }
  }

  Future<void> _onAddPhotoClicked(context) async {
    final image = await ImagePickerWeb.getImageAsWidget();
    // String mimeType = mim(Path.basename(image.fi));

    if (image != null) {
      setState(() {
        print("data iamge${image}");
        _photos = image;
        // final bytes = _photos?.readAsBytesSync();

        // String img64 = base64Encode(bytes);
      });
    } else {}
  }

  Widget _builddistaceCompany() {
    return Container(
      color: baseColor1.withOpacity(0.4),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
            child: Icon(
              Icons.info,
              color: blackColor,
            ),
          ),
          Container(
              child: Text(
            "Anda  berada di luar area kantor",
            style: TextStyle(
                color: blackColor,
                fontFamily: "Roboto-regular",
                letterSpacing: 0.5),
          ))
        ],
      ),
    );
  }

  //get curret locatin lat dan long
  _getCurrentLocation() async {
    _locationData = await location.getLocation();
    // getCurrentPosition(allowInterop((pos) {
    //   setState(() {
    //     // _latitude = pos.coords.latitude.toString();
    //     // _longitude = pos.coords.longitude.toString();
    //   });
    // }));
    setState(() {
      _latitude = _locationData!.latitude.toString();
      _longitude = _locationData!.longitude.toString();

      _getAddressFromLatLng(_locationData!.latitude.toString(),
          _locationData!.longitude.toString());
    });
  }

  //convert lat dan long to address
  _getAddressFromLatLng(var latitude, longitude) async {
    try {
      Address address = await geoCode.reverseGeocoding(
          latitude: double.parse(latitude.toString()),
          longitude: double.parse(_longitude.toString()));
      setState(() {
        _currentAddress =
            "${address.streetAddress} ${address.region} ${address.city} ";
      });
    } catch (e) {
      print(e);
    }
  }

  _getDataPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _employee_id = sharedPreferences.getString("user_id");

      dataEmployee(_employee_id.toString());
    });
  }

  /**/
  _getDistance(latMainoffice, longMainoffice, currentlat, currentlong) async {
    try {
      final double d = GeolocatorPlatform.instance.distanceBetween(
          double.parse(latMainoffice),
          double.parse(longMainoffice),
          double.parse(currentlat),
          double.parse(currentlong));

      setState(() {
        _distance = d;
        print("jarak sekarang $d");
        // print(d);
      });
    } catch (e) {
      print("${e}");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   setState(() {
    //     _latitude = currentLocation.latitude.toString();
    //     _longitude = currentLocation.longitude.toString();
    //
    //   });
    //   // Use current location
    // });

    super.initState();

    _startJam();
    _getDataPref();
  }

  Future dataEmployee(var id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      http.Response response =
          await http.get(Uri.parse("$base_url/api/employees/$id"));
      _employee = jsonDecode(response.body);

      setState(() {
        _departement_name = _employee!['data']['work_placement'];

        _gender = _employee!['data']['gender'];
        // _last_name = _employee['data']['last_name'];
        _profile_background = _employee!['data']['photo'];
        _firts_name = _employee!['data']['first_name'];
        _lat_mainoffice = _employee!['data']['location']['latitude'];
        _long_mainoffice = _employee!['data']['location']['longitude'];

        // print(_lat_mainoffice);

        _isLoading = false;
      });

      setState(() {
        _getCurrentLocation();

        _getDistance(_lat_mainoffice, _long_mainoffice, _latitude, _longitude);
      });
    } catch (e) {}
  }
}
