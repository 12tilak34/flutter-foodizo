import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const kgoldencolor = Color(0xFFFBB03B);

const ktextstyle = TextStyle(color: kgoldencolor, fontFamily: 'reggae', fontSize: 23, fontWeight: FontWeight.w500);
const khintstyle = TextStyle(color: Colors.white, fontFamily: 'reggae', fontSize: 19, fontWeight: FontWeight.w300);
const kbigstyle = TextStyle(color: kgoldencolor, fontFamily: 'reggae', fontSize: 38, fontWeight: FontWeight.w700);
const kappbartext = TextStyle(color: Colors.white, fontFamily: 'reggae', fontSize: 28, fontWeight: FontWeight.w600);
const kdialogtext = TextStyle(color: Colors.black, fontFamily: 'reggae', fontSize: 17, fontWeight: FontWeight.w500);
final Color darkColor = Color(0xFF100E20);
final Color greenColor = Colors.greenAccent;

CollectionReference usercollection = FirebaseFirestore.instance.collection('USERS');

final kboxdecoration = BoxDecoration(
  color: Color(0xFF383838),
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      offset: Offset(0, 4),
      color: Colors.white,
      blurRadius: 2.0,
    ),
  ],
);
