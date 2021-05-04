import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterway/Consts.dart';
import 'package:flutterway/Screens/DietPlan.dart';
import 'package:flutterway/Screens/FeedScreen.dart';
import 'package:flutterway/Screens/ProfileScreen.dart';
import 'package:flutterway/Screens/SearchScreen.dart';
import 'package:flutterway/auth/Auth.dart';
import 'package:flutterway/auth/LoginScreen.dart';
import 'package:image_picker/image_picker.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Widget currentscreen = FeedScreen();

  final PageStorageBucket bucket = PageStorageBucket();

  TextEditingController captionController = TextEditingController();
  late File file;
  bool isUploading = false;
  final DateTime timestamp = DateTime.now();

  handleTakePhoto() async {
    Navigator.pop(context);
    PickedFile? file = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    PickedFile? file = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      this.file = file as File;
    });
  }

  selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Center(
              child: Text(
            "Create Post",
            style: kdialogtext,
          )),
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            SimpleDialogOption(
                child: Text(
                  "Photo with Camera",
                  style: kdialogtext,
                ),
                onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text(
                  "Image from Gallery",
                  style: kdialogtext,
                ),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: kdialogtext,
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Widget buildSplashScreen() {
    return Container(
      //color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "Upload Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                color: Colors.brown,
                onPressed: () => selectImage(context)),
          ),
        ],
      ),
    );
  }

  setBottomBarIndex(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Authentication.signOut(context: context).whenComplete(
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              ),
            ),
            icon: Icon(Icons.logout),
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Center(
          child: Text(
            "Foodizo",
            style: kappbartext,
          ),
        ),
      ),
      body: Stack(
        children: [
          PageStorage(bucket: bucket, child: currentscreen),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: size.width,
              height: 80,
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  CustomPaint(
                    size: Size(size.width, 80),
                    painter: BNBCustomPainter(),
                  ),
                  Center(
                    heightFactor: 0.6,
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.add),
                      elevation: 0.1,
                      onPressed: () => selectImage(context),
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.home,
                            size: 30,
                            color: _currentIndex == 0 ? Colors.red : Colors.grey.shade400,
                          ),
                          onPressed: () {
                            setState(() {
                              currentscreen = FeedScreen();
                              _currentIndex = 0;
                            });
                          },
                          splashColor: Colors.white,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.person_search,
                              size: 30,
                              color: _currentIndex == 1 ? Colors.red : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setState(() {
                                currentscreen = SearchScreen();
                                _currentIndex = 1;
                              });
                            }),
                        Container(
                          width: size.width * 0.20,
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.menu_book,
                              size: 30,
                              color: _currentIndex == 2 ? Colors.red : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setState(() {
                                currentscreen = DietPlan();
                                _currentIndex = 2;
                              });
                            }),
                        IconButton(
                            icon: Icon(
                              Icons.person,
                              size: 30,
                              color: _currentIndex == 3 ? Colors.red : Colors.grey.shade400,
                            ),
                            onPressed: () {
                              setState(() {
                                currentscreen = ProfileScreen();
                                _currentIndex = 3;
                              });
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.green, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
