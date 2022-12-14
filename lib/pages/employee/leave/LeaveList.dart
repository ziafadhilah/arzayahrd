import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:get/get.dart';
import 'package:arzayahrd/pages/employee/leave/LeaveAdd.dart';
import 'package:arzayahrd/pages/employee/leave/LeaveEdit.dart';
import 'package:arzayahrd/pages/employee/leave/TabMenuLeave.dart';
import 'package:arzayahrd/pages/employee/permission/shimmer_effect.dart';
import 'package:arzayahrd/services/api_clien.dart';
import 'package:arzayahrd/utalities/color.dart';
import 'package:arzayahrd/utalities/constants.dart';
import 'package:page_transition/page_transition.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LeaveListEmployee extends StatefulWidget {
  LeaveListEmployee({this.status});

  var status;

  @override
  _LeaveListEmployeeState createState() => _LeaveListEmployeeState();
}

class _LeaveListEmployeeState extends State<LeaveListEmployee> {
  //variable
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  var user_id;
  var _leaves;
  var pendingCount = 0;

  Map? _projects;
  bool _loading = true;

  Widget _buildnodata() {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: no_data_leave,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                child: Text(
              "Belum ada cuti",
              style: TextStyle(color: Colors.black38, fontSize: 18),
            )),
          ],
        ),
      ),
    );
  }

//main contex---------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Stack(
            children: [
              pendingCount > 0
                  ? Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        alignment: Alignment.center,
                        width: 13,
                        height: 13,
                        child: Text(
                          "${pendingCount}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: redBaseColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    )
                  : Container(),
              PopupMenuButton<String>(
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return Constants.LeaveStatus.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // iconTheme: IconThemeData(
        //   color: Colors.white, //modify arrow color from here..
        // ),
        backgroundColor: baseColor,
        title: new Text(
          "Pengajuan Cuti",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto-medium",
              fontSize: 18,
              letterSpacing: 0.5),
        ),
      ),
      // appBar: AppBar(
      //   actions: <Widget>[
      //     PopupMenuButton<String>(
      //       onSelected: choiceAction,
      //       itemBuilder: (BuildContext context) {
      //         return Constants.LeaveStatus.map((String choice) {
      //           return PopupMenuItem<String>(
      //             value: choice,
      //             child: Text(choice),
      //           );
      //         }).toList();
      //       },
      //     )
      //   ],
      //   iconTheme: IconThemeData(
      //     color: Colors.black87, //modify arrow color from here..
      //   ),
      //   backgroundColor: Colors.white,
      //   title: new Text(
      //     "pengajuan Cuti",
      //     style: TextStyle(color: Colors.black87),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get.to(LeaveAdd());
          addLeave();
          // Navigator.push(
          //     context,
          //     PageTransition(
          //         type: PageTransitionType.rightToLeft, child: LeaveAdd()));
          // Navigator.pushNamed(context, "leave_add_employee-page");
        },
        child: Icon(Icons.add),
        backgroundColor: baseColor,
      ),
      body: RefreshIndicator(
        child: Container(
          child: Container(
            color: Colors.white38,
            child: Container(
              child: _loading
                  ? Center(
                      child: ShimmerProject(),
                    )
                  : ListView.builder(
                      itemCount: _leaves['data'].length <= 0
                          ? 1
                          : _leaves['data'].length,
                      itemBuilder: (context, index) {
                        return _leaves['data'].length.toString() == '0'
                            ? _buildnodata()
                            : _leave(index);
                      }),
            ),
          ),
        ),
        onRefresh: getDatapref,
      ),
    );
  }

  Widget _leave(index) {
    var id = _leaves['data'][index]['id'];
    var date_of_filing = _leaves['data'][index]['date_of_filing'];
    var leave_dates = _leaves['data'][index]['leave_dates'];
    var description = _leaves['data'][index]['description'];

    // var date_of_filing=DateFormat().format(DateFormat().parse(_leaves['data'][index]['date_of_filing'].toString()));
    return Card(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        width: Get.mediaQuery.size.width,
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: Get.mediaQuery.size.width,
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "${Waktu(DateTime.parse(_leaves['data'][index]['date_of_filing'].toString())).yMMMMEEEEd()}",
                  style: TextStyle(
                      color: baseColor,
                      fontFamily: "Roboto-medium",
                      letterSpacing: 0.5,
                      fontSize: 14),
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 1,
                color: blackColor3,
              ),
              SizedBox(
                height: 10,
              ),

              Container(
                child: Text(
                  "Tanggal Cuti",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontFamily: "Roboto-regular"),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Flex(direction: Axis.horizontal, children: [
                Expanded(
                    child: Container(
                  child: Text(
                    "${leave_dates}",
                    style: TextStyle(
                        color: blackColor3,
                        fontFamily: "Roboto-regular",
                        fontSize: 12),
                  ),
                ))
              ]),
              SizedBox(
                height: 15,
              ),

              description != null
                  ? Container(
                      child: Text(
                        "Keterangan",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: "Roboto-regular"),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 5,
              ),
              description != null
                  ? Flex(direction: Axis.horizontal, children: [
                      Expanded(
                          child: Container(
                        child: Text(
                          "${_leaves['data'][index]['description'].toString()}",
                          style: TextStyle(
                              color: blackColor3,
                              fontSize: 12,
                              fontFamily: "Roboto-regular"),
                        ),
                      ))
                    ])
                  : Container(),
              SizedBox(
                height: 15,
              ),
              // _leaves['data'][index]['status']=="aproved"?Container():btnAction(id,_leaves['data'][index]['date_of_filing'],_leaves['data'][index]['leave_dates'],_leaves['data'][index]['description'])
            ],
          ),
        ),
      ),
    );
  }

  Widget btnAction(id, date_of_filing, leave_dates, description) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 40,
            height: 40,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: IconButton(
                iconSize: 20,
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colors.black45,
                ),
                onPressed: () {
                  // Get.to(LeaveEdit(
                  //   id: id,
                  //   date_of_filing: date_of_filing,
                  //   leave_dates: leave_dates,
                  //   description: description,));
                  editLeave(id, date_of_filing, leave_dates, description);
                },
              ),
            ),
          ),
          Container(
            width: 40,
            height: 40,
            child: Ink(
              decoration: BoxDecoration(
                color: Colors.black12,
              ),
              child: IconButton(
                iconSize: 20,
                icon: Icon(
                  Icons.restore_from_trash_outlined,
                  color: Colors.black45,
                ),
                onPressed: () {
                  //print('pressed');
                  Services services = new Services();
                  // services.deleteLeave(context, id);
                  Alert(
                    context: context,
                    type: AlertType.warning,
                    title: "Apakah anda yakin?",
                    desc: "Data akan dihapus",
                    buttons: [
                      DialogButton(
                        child: Text(
                          "batalkan",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: Colors.grey,
                      ),
                      DialogButton(
                        child: Text(
                          "Iya",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Get.back();
                          services.deleteLeave(context, id).then((value) {
                            _dataLeave(user_id);
                          });
                        },
                        gradient: LinearGradient(
                            colors: [Colors.green, Colors.green]),
                      )
                    ],
                  ).show();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void editLeave(var id, date_of_filing, leave_dates, description) async {
    var result = await Get.to(LeaveEdit(
      id: id,
      date_of_filing: date_of_filing,
      leave_dates: leave_dates,
      description: description,
    ));
    if (result == "update") {
      _dataLeave(user_id);
    }
  }

  //ge data from api--------------------------------
  Future _dataLeave(var user_id) async {
    try {
      setState(() {
        _loading = true;
      });
      http.Response response = await http.get(Uri.parse(
          "$base_url/api/employees/$user_id/leave-submissions?status=${widget.status}"));
      _leaves = jsonDecode(response.body);
      setState(() {
        _loading = false;
      });
    } catch (e) {}
  }

  //ge data from api--------------------------------
  Future _countPending(var user_id) async {
    try {
      setState(() {
        //_loading = true;
      });
      http.Response response = await http.get(Uri.parse(
          "$base_url/api/employees/$user_id/leave-submissions?status=pending"));
      var data = jsonDecode(response.body);
      List list = await data['data'] ?? [];
      setState(() {
        pendingCount = list.length;

        ///_loading = false;
      });
    } catch (e) {}
  }

  Future getDatapref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = sharedPreferences.getString("user_id");
      _dataLeave(user_id);
      _countPending(user_id);
      print(user_id);
    });
  }

  void addLeave() async {
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft, child: LeaveAdd()));

    if (result == "update") {
      _dataLeave(user_id);
      _countPending(user_id);
    }
  }

  void statusleave() async {
    var result = await Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: TabsMenuLeavestatus()));

    if (result == "update") {
       _dataLeave(user_id);
      _countPending(user_id);
    }
  }

  @override
  void initState() {
    super.initState();
    //show modal detail project
    getDatapref();
  }

  void choiceAction(String choice) {
    if (choice == Constants.Leave) {
      Get.testMode = true;

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => TabsMenuLeavestatus()),
      // );
      statusleave();
      // Navigator.push(
      //     context,
      //     PageTransition(
      //         type: PageTransitionType.rightToLeft,
      //         child: TabsMenuLeavestatus()));

      //print(choice);

    }
  }
}
