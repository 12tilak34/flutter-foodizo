import 'package:flutter/material.dart';
import 'package:flutterway/Consts.dart';
import 'package:flutterway/MainScreen%20Content/MainScreen.dart';
import 'package:flutterway/auth/Auth.dart';
import 'package:flutterway/auth/SignUp.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  checkFields() {
    final form = _formkey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String? validateEmail(String value) {
    final regex = new RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  Widget EmailPass() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                "Foodizo",
                style: kbigstyle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 40, top: 70),
            child: Text(
              "Email",
              style: ktextstyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              child: TextFormField(
                style: khintstyle,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email.text = value;
                },
                validator: (value) => value!.isEmpty ? "Email Is Required" : validateEmail(value),
                decoration: InputDecoration(
                  hintText: "Enter Your Email",
                  hintStyle: khintstyle,
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
              ),
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: kboxdecoration,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 40,
            ),
            child: Text(
              "Password",
              style: ktextstyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              child: TextFormField(
                obscureText: true,
                keyboardType: TextInputType.name,
                style: khintstyle,
                onChanged: (value) {
                  password.text = value;
                },
                validator: (value) => value!.isEmpty ? "Password Is Required" : null,
                decoration: InputDecoration(
                  hintText: "Enter Your Password",
                  hintStyle: khintstyle,
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
              ),
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: kboxdecoration,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Widget LoginButton() {
    return Center(
      child: Container(
        padding: EdgeInsets.only(
          top: 30,
        ),
        child: GestureDetector(
          onTap: () {
            if (checkFields()) Authentication().login(email.text, password.text);
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "LOGIN",
                style: ktextstyle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget orelse() {
    return Center(
      child: Text(
        "-- OR -- Sign In With",
        style: khintstyle,
      ),
    );
  }

  Widget SocialIcons() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => Authentication.signInWithGoogle(context: context).whenComplete(
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
              ),
            ),
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    color: Colors.white,
                    blurRadius: 20,
                  ),
                ],
                image: DecorationImage(
                  image: AssetImage('assets/images/google.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signup() {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUp(),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(
            "           CLICK HERE \n To Register If You Are new",
            style: khintstyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF222222),
        body: ListView(
          children: [
            EmailPass(),
            LoginButton(),
            SizedBox(
              height: 30,
            ),
            signup(),
          ],
        ),
      ),
    );
  }
}
