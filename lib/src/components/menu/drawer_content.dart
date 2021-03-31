import 'package:flutter/material.dart';

import 'package:tinawork/src/screens/approval_for_leave/approval_for_leave.dart';
import 'package:tinawork/src/screens/approval_for_participate/approval_for_paticipate.dart';
import 'package:tinawork/src/screens/day_off_management/day_off_management.dart';
import 'package:tinawork/src/screens/department/department.dart';
import 'package:tinawork/src/screens/employees/employees.dart';
import 'package:tinawork/src/screens/home/home.dart';
import 'package:tinawork/src/screens/personal_information/personalInformation.dart';
import 'package:tinawork/src/screens/statistic/statistic.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class DrawerContent extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Trang chủ", Icons.home),
    new DrawerItem("Quản lí ngày nghỉ", Icons.today_outlined),
    new DrawerItem("Nhân viên", Icons.people_alt),
    new DrawerItem("Phòng ban", Icons.meeting_room),
    new DrawerItem("Phê duyệt nghỉ phép", Icons.verified),
    new DrawerItem("Phê duyệt tham gia", Icons.person_add_alt_1),
    new DrawerItem("Thống kê", Icons.leaderboard),
    new DrawerItem("Thông tin cá nhân", Icons.person),
    new DrawerItem("Đăng xuất", Icons.logout),
  ];

  @override
  State<StatefulWidget> createState() {
    return new DrawerContentState();
  }
}

class DrawerContentState extends State<DrawerContent> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Home();
      case 1:
        return new DayOffManagement();
      case 2:
        return new Employees();
      case 3:
        return new Department();
      case 4:
        return new ApprovalForLeave();
      case 5:
        return new ApprovalForPaticipate();
      case 6:
        return new Statistic();
      case 7:
        return new PersonalInformation();
      case 8:
        return Navigator.pop(context);
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return new Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        centerTitle: true,
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(
          widget.drawerItems[_selectedDrawerIndex].title,
        ),
      ),
      drawer: new Drawer(
          child: SafeArea(
        child: Column(
          children: [
            Container(
              height: 120,
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    child: Center(
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.asset("assets/images/logo.png",
                              height: 70, width: 70),
                        ),
                      ),
                    ),
                  )),
                  Expanded(
                      flex: 2,
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Phạm Ngọc Quang',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '@ngocquangpn',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
            // Container(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(
            //         Icons.email,
            //         color: Colors.red,
            //       ),
            //       Text('quangpn.dev@gmail.com'),
            //     ],
            //   ),
            // ),
            // Container(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Icon(
            //         Icons.phone,
            //         color: Colors.green,
            //       ),
            //       Text('0868358969'),
            //     ],
            //   ),
            // ),
            const Divider(
              height: 20,
              thickness: 3,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: drawerOptions),
              ),
            )
          ],
        ),
      )),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
