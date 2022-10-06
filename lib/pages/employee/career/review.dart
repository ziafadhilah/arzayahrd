import 'dart:convert';

import 'package:arzayahrd/pages/employee/career/review_detail.dart';
import 'package:arzayahrd/utalities/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:arzayahrd/services/api_clien.dart';
import 'package:format_indonesia/format_indonesia.dart';
import 'package:http/http.dart' as http;

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  bool _loading = true;
  List? _reviews;
  var nextreview;
  var user_id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDatapref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: Get.mediaQuery.size.width,
          height: Get.mediaQuery.size.height,
          child: _loading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Container(
                      color: baseColor1.withOpacity(0.4),
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            child: Icon(
                              Icons.info,
                              color: blackColor,
                            ),
                          ),
                          nextreview != null
                              ? Container(
                                  child: Text(
                                  "Review selanjutnya pada tanggal  ${nextreview}",
                                  style: TextStyle(
                                      color: blackColor,
                                      fontSize: 11,
                                      fontFamily: "Roboto-regular",
                                      letterSpacing: 0.5),
                                ))
                              : Container()
                        ],
                      ),
                    ),
                    Container(
                      width: Get.mediaQuery.size.width,
                      height: Get.mediaQuery.size.height - 100,
                      child: ListView.builder(
                          itemCount: _reviews?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: ReviewDetail(
                                      date: _reviews?[index]['date'].toString(),
                                      note: _reviews?[index]['note'].toString(),
                                      result:
                                          _reviews?[index]['result'].toString(),
                                      status:
                                          _reviews?[index]['status'].toString(),
                                      position: _reviews?[index]['career'] !=
                                              null
                                          ? _reviews![index]['career']
                                              ['position_setting']['position']
                                          : "",
                                      nextReview: nextreview,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: Get.mediaQuery.size.width,
                                height: 150,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 5,
                                        bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                "${Waktu(DateTime.parse(_reviews?[index]['date'])).yMMMMEEEEd()}",
                                                style: TextStyle(
                                                  color: baseColor,
                                                  fontSize: 11,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: double.maxFinite,
                                                child: Container(
                                                  width: 100,
                                                  height: 20,
                                                  alignment: Alignment.center,
                                                  margin: EdgeInsets.only(
                                                      top: 10, bottom: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: _reviews?[index]
                                                                ['status'] ==
                                                            "approved"
                                                        ? greenColorInfo
                                                        : redColorInfo,
                                                  ),
                                                  child: Text(
                                                    "${_reviews?[index]['status'] == "approved" ? "LOLOS" : "TIDAK LOLOS"}",
                                                    style: TextStyle(
                                                      color: _reviews?[index]
                                                                  ['status'] ==
                                                              "approved"
                                                          ? greenColor
                                                          : redColor,
                                                      fontSize: 10,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Divider(
                                          height: 1,
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Text(
                                            "${_reviews?[index]['status'] == "approved" ? "Naik Jabatan ke ${_reviews?[index]['career']['position_setting']['position']}" : "Tidak Naik jabatan"} ",
                                            style: TextStyle(
                                                color: blackColor2,
                                                fontSize: 12,
                                                letterSpacing: 0.5),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: RichText(
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            strutStyle:
                                                StrutStyle(fontSize: 12.0),
                                            text: TextSpan(
                                              style: TextStyle(
                                                  height: 1.4,
                                                  letterSpacing: 1,
                                                  fontSize: 10,
                                                  color: blackColor4,
                                                  fontFamily: "roboto-regular"),
                                              text:
                                                  // "Saya ingin mengambil cuti di awal tahun ini selama 10 hari. Terimakasih banyak atas perhatiannya. ",
                                                  "Catatan: ${_reviews?[index]['note']}",
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future getDatapref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      user_id = sharedPreferences.getString("user_id");
      _dataLeave(user_id);
    });
  }

  Future _dataLeave(var user_id) async {
    try {
      setState(() {
        _loading = true;
      });
      http.Response response =
          await http.get(Uri.parse("$base_url/api/employees/$user_id/reviews"));
      var data = jsonDecode(response.body);
      //  print("data ${data}");
      _reviews = data['data']['reviews'];

      setState(() {
        nextreview = data['data']['next_review'];
        _loading = false;
      });
    } catch (e) {
      print("${e}");
    }
  }
}
