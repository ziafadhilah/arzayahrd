import 'package:arzayahrd/pages/employee/career/tabmenu.dart';
import 'package:arzayahrd/pages/employee/sop/files.dart';
import 'package:flutter/material.dart';
import 'package:arzayahrd/pages/employee/account/account.dart';

import 'package:arzayahrd/pages/employee/home/home.dart';
import 'package:arzayahrd/utalities/color.dart';

class NavBarEmployee extends StatefulWidget {
  @override
  _NavBarEmployeeState createState() => _NavBarEmployeeState();
}

class _NavBarEmployeeState extends State<NavBarEmployee> {
  // Properties & Variables needed

  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    HomeEmployee(),
    AccountEmployee(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomeEmployee(); // Our first view in viewport

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            HomeEmployee(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: currentTab == 0 ? baseColor : blackColor3,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                              color: currentTab == 0 ? baseColor : blackColor3,
                              fontFamily: "Roboto-medium",
                              letterSpacing: 0.5,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            TabsmenuCareer(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.list_outlined,
                          color: currentTab == 1 ? baseColor : blackColor3,
                        ),
                        Text(
                          'Review',
                          style: TextStyle(
                              color: currentTab == 1 ? baseColor : blackColor3,
                              fontFamily: "Roboto-medium",
                              letterSpacing: 0.5,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            Files(); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.file_copy,
                          color: currentTab == 2 ? baseColor : blackColor3,
                        ),
                        Text(
                          'Files',
                          style: TextStyle(
                              color: currentTab == 2 ? baseColor : blackColor3,
                              fontFamily: "Roboto-medium",
                              letterSpacing: 0.5,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                            AccountEmployee(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: currentTab == 3 ? baseColor : blackColor3,
                        ),
                        Text(
                          'Akun',
                          style: TextStyle(
                              color: currentTab == 3 ? baseColor : blackColor3,
                              fontFamily: "Roboto-medium",
                              letterSpacing: 0.5,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
