import 'package:flutter/material.dart';
import 'package:my_food_never_waste/registerScreen.dart';
import 'package:my_food_never_waste/homeScreen.dart';
import 'package:my_food_never_waste/resetPassScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String urlLogin = "http://mobilehost2019.com/MyFoodNoWaste/php/dblogin.php";
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passController = TextEditingController();
String _email = "";
String _password = "";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      home: new LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;

  @override
  void initState() {
    loadpref();
    print('Init: $_email');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Container(
        padding: EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/icon.png",
              width: 150,
              height: 150,
            ),
            Image.asset(
              "assets/images/title.png",
              height: 50,
              width: 250,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Email', icon: Icon(Icons.email))),
            TextField(
              controller: _passController,
              decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                  hintStyle: TextStyle(fontSize: 13),
                  hintText: 'Must be longer than 6 characters'),
              obscureText: true,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(14.0),
                ),
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool value) {
                    _onCheck(value);
                  },
                ),
                Text('Remember Me', style: TextStyle(fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              minWidth: 200,
              height: 40,
              child: Text(
                'Login',
                style: TextStyle(fontSize: 16),
              ),
              textColor: Colors.white,
              color: Colors.indigo[900],
              splashColor: Colors.blue,
              elevation: 15,
              onPressed: _login,
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: _forgotPass,
                child: Text('Forgot Password',
                    style: TextStyle(fontSize: 16, color: Colors.blueAccent))),
            SizedBox(
              height: 10,
            ),
            RichText(
                text: new TextSpan(
                    text: 'Don\'t have an account? ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: <TextSpan>[
                  TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(color: Colors.blueAccent),
                      recognizer: TapGestureRecognizer()..onTap = _onRegister)
                ])),
          ],
        ),
      ),
    );
  }

  void _onCheck(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void _login() {
    _email = _emailController.text;
    _password = _passController.text;
    if (_isEmailValid(_email) && (_password.length > 6)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in");
      pr.show();
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        if (res.body == "Success") {
          pr.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(email: _email)));
        } else {
          pr.dismiss();
        }
      }).catchError((err) {
        pr.dismiss();
        print(err);
      });
    } else {}
  }

  void _onRegister() {
    print("move to RegisterScreen");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void _forgotPass() {
    print("move to ResetPasswordScreen");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ResetPassScreen()));
  }

  void loadpref() async {
    print('Inside loadpref()');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email'));
    _password = (prefs.getString('pass'));
    print(_email);
    print(_password);

    if (_email.length > 1) {
      _emailController.text = _email;
      _passController.text = _password;
      setState(() {
        _isChecked = true;
      });
    } else {
      print('No pref');
      setState(() {
        _isChecked = false;
      });
    }
  }

  void savepref(bool value) async {
    print('Inside savepref');
    _email = _emailController.text;
    _password = _passController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (value) {
      if (_isEmailValid(_email) && (_password.length > 6)) {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        print('Save pref $_email');
        print('Save pref $_password');
        Toast.show("Preferences have been saved", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        print('No email');
        setState(() {
          _isChecked = false;
        });
        Toast.show("Check your credentials", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailController.text = '';
        _passController.text = '';
        _isChecked = false;
      });
      print('Remove pref');
      Toast.show("Preferences have been removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }
}
