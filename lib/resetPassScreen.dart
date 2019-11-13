import 'package:flutter/material.dart';
import 'package:my_food_never_waste/loginScreen.dart';
import 'package:my_food_never_waste/registerScreen.dart';
import 'package:toast/toast.dart';

String urlReset = "http://mobilehost2019.com/MyFoodNoWaste/php/dbresetPass.php";

final TextEditingController _emailController = TextEditingController();
String _email;

class ResetPassScreen extends StatefulWidget {
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPassScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Forgot Password'),
          centerTitle: true,
          backgroundColor: Color(0xff273b7a),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 15, 40, 20),
            child: ResetPassWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
    return Future.value(false);
  }
}

class ResetPassWidget extends StatefulWidget {
  @override
  ResetPassWidgetState createState() => ResetPassWidgetState();
}

class ResetPassWidgetState extends State<ResetPassWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 65),
          Image.asset(
            "assets/images/lock.jfif",
            width: 150,
            height: 150,
          ),
          SizedBox(height: 10),
          Text(
            'Trouble Logging In?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
              'Enter your email address and we\'ll send you a link to get back into your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17)),
          SizedBox(height: 10),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration:
                InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
          ),
          SizedBox(height: 15),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            minWidth: 200,
            height: 40,
            child: Text(
              'Send Login Link',
              style: TextStyle(fontSize: 16),
            ),
            textColor: Colors.white,
            color: Colors.indigo[900],
            splashColor: Colors.blue,
            elevation: 15,
            onPressed: _onSendLink,
          ),
          SizedBox(height: 10),
          Text('OR'),
          SizedBox(height: 10),
          GestureDetector(
              onTap: _onRegister,
              child: Text('Create New Account',
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent))),
        ]);
  }

  void _onSendLink() {
    print('onSendLink button from resetPassScreen()');
    sendLink();
  }

  void _onRegister() {
    print("move to RegisterScreen");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void sendLink() {
    _email = _emailController.text;
    if (_email == null) {
      Toast.show("Failed. Please take photo.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (!_isEmailValid(_email)) {
      Toast.show("Failed. Please make sure your email is valid.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Please check your email to reset password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
