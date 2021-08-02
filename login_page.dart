import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/constants.dart';
import 'package:shopping_app/screens/custom_input.dart';
import 'package:shopping_app/screens/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _alertDialogBuilder(String error) async{
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text('Error'),
            content: Container(
              child: Text(error),
            ),
            actions: [
              TextButton(
                  child: Text('close'),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              )
            ],
          );
        }
    );
  }

  Future<String> _loginToAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _loginemail,
        password: _loginpassword,
      );
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return ('Wrong password provided for that user.');
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async{
    setState(() {
      _loginFormLoading = true;
    });
    String _loginToAccountFeedback = await _loginToAccount();
    if(_loginToAccountFeedback != '') {
      _alertDialogBuilder(_loginToAccountFeedback);
      setState(() {
        _loginFormLoading = false;
      }
      );
    }
  }

  String _loginemail = '';
  String _loginpassword = '';
  bool _loginFormLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 5,
          ),
          Center(
            child: Text('WELCOME',
              style: TextStyle(
                fontSize: 40, fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text('Login to Your Account',
              style: Constants.boldHeading,
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Column(
              children: [
                Center(
                  child: CustomInput(
                    hintText: 'Email',
                    onChanged: (value) {
                      _loginemail = value;
                    },
                    textInputAction: TextInputAction.next,
                    isPassword: false,
                  ),
                ),
                Center(
                  child: CustomInput(
                    hintText: 'Password',
                    onChanged: (value) {
                      _loginpassword = value;
                    },
                    textInputAction: TextInputAction.done,
                    isPassword: true,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Stack(
                    children: [
                      Visibility(
                        visible: _loginFormLoading?false:true,
                        child: Center(
                          child: ElevatedButton(
                            child: Text('Login'),
                            onPressed: () {
                              _submitForm();
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _loginFormLoading,
                        child: Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(50, 12.5, 50, 10),
                              child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                            )),
                      ),
                    ]
                ),
              ],
            )
          ),
          Center(
            child: ElevatedButton(
              child: Text('Create New Account'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      )
    );
  }
}