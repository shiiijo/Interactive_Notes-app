import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tizeno/ui/about.dart';
import 'package:tizeno/screens/picnote_page.dart';
import 'package:tizeno/ui/staggered_page.dart';
import 'package:tizeno/data/notes.dart';
import 'package:tizeno/screens/note_page.dart';
import 'package:tizeno/data/utility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:tizeno/data/SqliteHandler.dart';

enum viewType { List, Staggered }

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var notesViewType;

  @override
  void initState() {
    notesViewType = viewType.Staggered;
    super.initState();
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1440, allowFontScaling: true);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      drawer: Drawer(
        child: NavigationRail(
            trailing: Column(
              children: <Widget>[
                AboutButton(),
                Padding(
                  padding: const EdgeInsets.only(right: 100, bottom: 100),
                  child: Text('about'),
                ),
              ],
            ),
            unselectedIconTheme: IconThemeData(color: Colors.black87),
            selectedIconTheme: IconThemeData(color: Colors.black),
            labelType: NavigationRailLabelType.selected,
            backgroundColor: Colors.white70,
            onDestinationSelected: (int index) {
              if (index != 4 || index != 5) {
                setState(() {
                  CentralStation.updateNeeded = true;
                  _selectedIndex = index;
                });
              }
            },
            destinations: [
              NavigationRailDestination(
                icon: Padding(
                  padding: EdgeInsets.only(right: 80, top: 50),
                  child: Row(
                    children: [
                      Icon(
                        LineAwesomeIcons.sticky_note_o,
                        size: 22,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'All',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                ),
                selectedIcon: Padding(
                  padding: const EdgeInsets.only(right: 80, top: 50),
                  child: FaIcon(
                    FontAwesomeIcons.solidStickyNote,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                label: Padding(
                  padding: const EdgeInsets.only(right: 80, top: 10),
                  child: Text(
                    'All',
                    style: GoogleFonts.montserrat(
                        fontSize: 23, color: Colors.black),
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Row(
                    children: [
                      Icon(
                        LineAwesomeIcons.star_o,
                        size: 22,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Starred',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                ),
                selectedIcon: Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                label: Padding(
                  padding: const EdgeInsets.only(right: 80, top: 10),
                  child: Text(
                    'Starred',
                    style: GoogleFonts.montserrat(
                        fontSize: 23, color: Colors.black),
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Row(
                    children: [
                      Icon(
                        LineAwesomeIcons.archive,
                        size: 22,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Archived',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                ),
                selectedIcon: Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: FaIcon(
                    FontAwesomeIcons.archive,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                label: Padding(
                  padding: const EdgeInsets.only(right: 80, top: 10),
                  child: Text(
                    'Archived',
                    style: GoogleFonts.montserrat(
                        fontSize: 23, color: Colors.black),
                  ),
                ),
              ),
              NavigationRailDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: Row(
                    children: [
                      Icon(
                        LineAwesomeIcons.photo,
                        size: 22,
                        color: Colors.black,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Images',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                ),
                selectedIcon: Padding(
                  padding: const EdgeInsets.only(right: 80),
                  child: FaIcon(
                    FontAwesomeIcons.solidImage,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                label: Padding(
                  padding: const EdgeInsets.only(right: 80, top: 10),
                  child: Text(
                    'Images',
                    style: GoogleFonts.montserrat(
                        fontSize: 23, color: Colors.black),
                  ),
                ),
              ),
            ],
            selectedIndex: _selectedIndex),
      ),
      appBar: AppBar(
        brightness: Brightness.light,
        actions: _appBarActions(),
        elevation: 0,
        backgroundColor: Colors.blue[500],
        // centerTitle: true,
        title: Center(
          child: Text(
            "Your Assets",
            style: GoogleFonts.podkova(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      floatingActionButton: Container(
          decoration: BoxDecoration(
              // border: Border.all(width: 2, color: Colors.white),
              borderRadius: BorderRadius.circular(150)),
          child: Container(
            child: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 75,
                    height: 65,
                    child: RawMaterialButton(
                      fillColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(5, 14, 0, 14),
                      key: Key('NewNote'),
                      shape: CircleBorder(),
                      onPressed: () => _newNoteTapped(context),
                      child: Image(image: AssetImage('assets/plus2.png')),
                    ),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  SizedBox(
                    width: 75,
                    height: 65,
                    child: RawMaterialButton(
                      fillColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(5, 14, 0, 14),
                      shape: CircleBorder(),
                      onPressed: () => _newPhotoNoteTapped(context),
                      child: Image(
                        image: AssetImage(
                          'assets/lib.jpg',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          // FloatingActionButton.extended(
          //   heroTag: 'FAB',
          //   elevation: 0,
          //   onPressed: () => _newNoteTapped(context),
          //   label: Text("CREATE"),
          //   icon: Icon(Icons.add),
          // ),
          ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Stack(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.only(
                        //   topRight: Radius.circular(15),
                        // ),
                        // border: Border.all(color: Colors.black, width: 2),
                        border: Border(
                          right: BorderSide(color: Colors.grey[300], width: 2),
                          //top: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                      height: 1440.h,
                      // width: 604.5.w,
                      child: Center(
                        child: Text(''),
                      )),
                  Container(
                    padding: EdgeInsets.only(top: 8),
                    child: SafeArea(
                      child: _body(),
                      right: true,
                      left: true,
                      top: true,
                      bottom: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomSheet: _bottomBar(),
    );
  }

  Widget _body() {
    print(notesViewType);
    return Container(
        child: StaggeredGridPage(
      notesViewType: notesViewType,
      selectedIndex: _selectedIndex,
    ));
  }

  // Widget _bottomBar() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       FlatButton(
  //         child: Text(
  //           "New Note\n",
  //           style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
  //         ),
  //         onPressed: () => _newNoteTapped(context),
  //       )
  //     ],
  //   );
  // }

  void _newNoteTapped(BuildContext ctx) {
    // "-1" id indicates the note is not new
    var emptyNote = new Note(
        -1, "", "", DateTime.now(), DateTime.now(), Colors.white, 0, 0, 0);
    Navigator.push(
        ctx, CupertinoPageRoute(builder: (ctx) => NotePage(emptyNote)));
  }

  void _newPhotoNoteTapped(BuildContext ctx) {
    // "-1" id indicates the note is not new
    var emptyNote = new Note(
        -1, "", "", DateTime.now(), DateTime.now(), Colors.white, 0, 0, 1);
    Navigator.push(
        ctx, CupertinoPageRoute(builder: (ctx) => PhotoPage(emptyNote)));
  }

  void _toggleViewType() {
    setState(() {
      CentralStation.updateNeeded = true;
      if (notesViewType == viewType.List) {
        notesViewType = viewType.Staggered;
      } else {
        notesViewType = viewType.List;
      }
    });
  }

  List<Widget> _appBarActions() {
    return [
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: IconButton(
            color: Colors.black,
            icon: notesViewType == viewType.List
                ? FaIcon(
                    LineAwesomeIcons.copy,
                    size: 30,
                    color: Colors.black87,
                  )
                : FaIcon(
                    LineAwesomeIcons.list,
                    size: 30,
                    color: Colors.black87,
                  ),
            onPressed: () => _toggleViewType(),
          )
          // InkWell(
          //   child: GestureDetector(
          //     onTap: () => _toggleViewType(),
          //     child: Icon(
          //       notesViewType == viewType.List
          //           ? Icons.developer_board
          //           : Icons.view_headline,
          //       color: CentralStation.fontColor,
          //     ),
          //   ),
          // ),
          ),
    ];
  }
}
