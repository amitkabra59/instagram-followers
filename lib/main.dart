import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _firstNameFocusNode.dispose();
    _usernameFocusNode.dispose();
    _lastNameFocusNode.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14.0,
  );

  var _followers = 0;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _firstNameFocusNode = FocusNode();
  FocusNode _lastNameFocusNode = FocusNode();
  FocusNode _usernameFocusNode = FocusNode();

  bool isFirstNameCompleted = false;
  bool isLastNameCompleted = false;
  bool isEmailCompleted = false;
  bool isUsernameCompleted = false;
  final checkBoxIcon = 'assets/images/checkbox.svg';

  Future fetchFollowers(username) async {
    try {
      Response res =
          await http.get('https://www.instagram.com/${username}/?__a=1');
      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        setState(() {
          _followers =
              body['graphql']['user']['edge_followed_by']['count'] as int;
        });
      } else {
        throw "Can't get Followers.";
      }
    } catch (e) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return invalidUsername(context);
        },
      );
    }
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    final firstNameField = TextFormField(
      validator: (String arg) {
        if (arg.length < 1)
          return 'Please enter your first name';
        else {
          setState(() {
            isFirstNameCompleted = true;
          });
          return null;
        }
      },
      controller: _firstNameController,
      focusNode: _firstNameFocusNode,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          helperText: ' ',
          suffixIcon: isFirstNameCompleted == true
              ? Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: mediaQueryData.size.width * 0.02),
                    child: SvgPicture.asset(checkBoxIcon),
                  ))
              : Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SvgPicture.asset(checkBoxIcon),
                  )),
          prefixIcon: Icon(Icons.person),
          contentPadding: new EdgeInsets.symmetric(
              vertical: mediaQueryData.size.height * 0.01,
              horizontal: mediaQueryData.size.width * 0.02),
          hintText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onSaved: (val) => _firstNameController.text = val,
      onFieldSubmitted: (val) {
        fieldFocusChange(context, _firstNameFocusNode, _lastNameFocusNode);
      },
    );

    final lastNameField = TextFormField(
      validator: (String arg) {
        if (arg.length < 1)
          return 'Please enter your last name';
        else {
          setState(() {
            isLastNameCompleted = true;
          });
          return null;
        }
      },
      controller: _lastNameController,
      focusNode: _lastNameFocusNode,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          helperText: ' ',
          suffixIcon: isLastNameCompleted == true
              ? Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: mediaQueryData.size.width * 0.02),
                    child: SvgPicture.asset(checkBoxIcon),
                  ))
              : Visibility(
                  visible: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: mediaQueryData.size.width * 0.02),
                    child: SvgPicture.asset(checkBoxIcon),
                  )),
          prefixIcon: Icon(Icons.person),
          contentPadding: new EdgeInsets.symmetric(
              vertical: mediaQueryData.size.height * 0.01,
              horizontal: mediaQueryData.size.width * 0.02),
          hintText: "Last Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onSaved: (val) => _firstNameController.text = val,
      onFieldSubmitted: (val) {
        fieldFocusChange(context, _lastNameFocusNode, _emailFocusNode);
      },
    );

    final emailField = TextFormField(
      focusNode: _emailFocusNode,
      validator: (String value) {
        Pattern pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$";
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value) || value == null)
          return 'Please enter a valid email address';
        else
          return null;
      },
      controller: _emailController,
      obscureText: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          helperText: ' ',
          suffixIcon: isEmailCompleted == true
              ? Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: mediaQueryData.size.width * 0.02),
                    child: SvgPicture.asset(checkBoxIcon),
                  ))
              : Visibility(
                  visible: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: mediaQueryData.size.width * 0.02),
                    child: SvgPicture.asset(checkBoxIcon),
                  )),
          prefixIcon: Icon(Icons.email),
          contentPadding: new EdgeInsets.symmetric(
              vertical: mediaQueryData.size.height * 0.01,
              horizontal: mediaQueryData.size.width * 0.02),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onSaved: (String value) {
        Pattern pattern =
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
            r"{0,253}[a-zA-Z0-9])?)*$";
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(value) || value == null)
          return 'Enter a valid email address';
        else {
          {
            setState(() {
              isEmailCompleted = true;
            });
            return null;
          }
        }
      },
      onFieldSubmitted: (val) {
        fieldFocusChange(context, _emailFocusNode, _usernameFocusNode);
      },
    );

    final usernameField = TextFormField(
      validator: (String arg) {
        if (arg.length < 1)
          return 'Please enter username';
        else {
          setState(() {
            isUsernameCompleted = true;
          });
          return null;
        }
      },
      controller: _usernameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          helperText: ' ',
          suffixIcon: isUsernameCompleted == true
              ? Visibility(
                  visible: true,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: mediaQueryData.size.width * 0.02),
                    child: SvgPicture.asset(checkBoxIcon),
                  ))
              : Visibility(
                  visible: false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: mediaQueryData.size.width * 0.02),
                    child: SvgPicture.asset(checkBoxIcon),
                  )),
          prefixIcon: Icon(Icons.person_add),
          contentPadding: new EdgeInsets.symmetric(
              vertical: mediaQueryData.size.height * 0.02,
              horizontal: mediaQueryData.size.width * 0.02),
          hintText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      onSaved: (val) => _usernameController.text = val,
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blue,
      child: MaterialButton(
        minWidth: mediaQueryData.size.width,
        padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
        onPressed: () {
          if (_formKeyValue.currentState.validate()) {
            _formKeyValue.currentState.save();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert(context);
              },
            );
          }
        },
        child: Text("Register",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final dropDown = new DropdownButton(
      value: 'Instagram',
      items: [
        'Instagram',
      ].map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: Container(
            height: 20,
            child: Row(
              children: [
                Image.asset(
                  'assets/images/instagram.png',
                ),
                new Text(
                  value,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      onChanged: (_) {},
    );
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: width * 0.05),
            child: const Text(
              'Register',
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.only(
                left: width * 0.10,
                right: width * 0.10,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKeyValue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * 0.02),
                        firstNameField,
                        SizedBox(height: height * 0.01),
                        lastNameField,
                        SizedBox(height: height * 0.01),
                        emailField,
                        SizedBox(height: height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Social Media Category',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: mediaQueryData.size.width * 0.040),
                            ),
                            dropDown
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        usernameField,
                        SizedBox(height: height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Followers:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              _followers.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            FlatButton(
                              onPressed: () {
                                if (_usernameController.text.length > 0) {
                                  fetchFollowers(_usernameController.text)
                                      .then((value) => null);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return invalidUsername(context);
                                    },
                                  );
                                }
                              },
                              color: Colors.blue,
                              child: Text('Check',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          mediaQueryData.size.width * 0.045)),
                            )
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        loginButton,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  alert(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      title: Text("You are registered"),
      content: Text("Certificate will be generated and sent to your email"),
      actions: [
        AlertFlatButton(),
      ],
    );
  }

  invalidUsername(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      title: Text("Invalid Username"),
      content: Text("Please enter a valid username to continue"),
      actions: [
        AlertFlatButton(),
      ],
    );
  }
}

class AlertFlatButton extends StatelessWidget {
  const AlertFlatButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
