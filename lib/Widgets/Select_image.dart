import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as Im;
import 'package:flutter/material.dart';
import 'package:flutterway/Models/usermodel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SelectImage extends StatefulWidget {
  final UserModel currentuser;
  SelectImage(this.currentuser);

  @override
  _SelectImageState createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> with AutomaticKeepAliveClientMixin<SelectImage> {
  TextEditingController captionController = TextEditingController();
  late File file;
  bool isUploading = false;
  String postId = Uuid().v4();
  final Reference storageRef = FirebaseStorage.instance.ref();
  final DateTime timestamp = DateTime.now();

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
                onPressed: () => {}),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync())!;
    final compressedImageFile = File('$path/img_$postId.jpg')..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    UploadTask uploadTask = storageRef.child("post_$postId.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() => print("DONE"));
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  CollectionReference posts = FirebaseFirestore.instance.collection("insta_posts");

  createPostInFirestore({required String mediaUrl, required String description}) {
    posts.doc(widget.currentuser.id).collection("userPosts").doc(postId).set({
      "postId": postId,
      "ownerId": widget.currentuser.id,
      "username": widget.currentuser.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "timestamp": timestamp,
      "likes": {},
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    createPostInFirestore(
      mediaUrl: mediaUrl,
      description: captionController.text,
    );
    captionController.clear();
    setState(() {
      file;
      isUploading = false;
      postId = Uuid().v4();
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: clearImage),
        title: Text(
          "Caption Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? LinearProgressIndicator() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(widget.currentuser.photoUrl),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: "Write a caption...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return file == null ? buildSplashScreen() : buildUploadForm();
  }

  @override
  bool get wantKeepAlive => true;
}
