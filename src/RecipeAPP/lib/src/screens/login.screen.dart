import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:it20025526/src/models/authentication.model.dart';
import 'package:it20025526/src/screens/list.screen.dart';
import 'package:it20025526/src/screens/register.screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    Key? key,
  }) : super(key: key);

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.blue,
                    )),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name is required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Email'),
                      controller: widget.userNameController,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 15, bottom: 0),
                      //padding: EdgeInsets.symmetric(horizontal: 15),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }

                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          hintText: 'Password'),
                      controller: widget.passwordController,
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => RegisterScreen()));
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.blue, fontSize: 15),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            AuthenticationModel authModel = AuthenticationModel(
                                email: widget.userNameController.text,
                                password: widget.passwordController.text);
                            signInWithEmail(authModel);
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 130,
                    ),
                  ]),
                )),
          ],
        ),
      ),
    );
  }

  //method of user user login
  Future<void> signInWithEmail(AuthenticationModel authenticationModel) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: authenticationModel.email,
        password: authenticationModel.password,
      );

      Navigator.push(context, MaterialPageRoute(builder: (_) => ListScreen()));
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'user-not-found') {
        Fluttertoast.showToast(
            msg: "Cannot found user with this email.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (exception.code == 'wrong-password') {
        Fluttertoast.showToast(
            msg: "Password is incorrect,please try again",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 4,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
