import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/constants.dart';
import 'package:shopping_app/screens/custom_input.dart';
import 'package:shopping_app/screens/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
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

  Future<String> _createAccount() async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registeremail,
          password: _registerpassword,
      );
      return '';
    }on FirebaseAuthException catch(e) {
       if (e.code == 'weak-password') {
         return('The password provided is too weak.');
       } else if (e.code == 'email-already-in-use') {
         return('The account already exists for that email.');
       }
       return e.message;
    } catch(e){
        return(e.toString());
    }
}

void _submitForm() async{
    setState(() {
      _registerFormLoading = true;
    });
    String _createAccountFeedback = await _createAccount();
    if(_createAccountFeedback != '') {
      _alertDialogBuilder(_createAccountFeedback);
      setState(() {
        _registerFormLoading = false;
      }
      );
    }
    else{
      Navigator.pop(context);
    }
}

  String _registeremail = '';
  String _registerpassword = '';
  bool _registerFormLoading = false;

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
              child: Text('Create a New Account',
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
                          _registeremail = value;
                        },
                        textInputAction: TextInputAction.next,
                        isPassword: false,
                      ),
                    ),
                    Center(
                      child: CustomInput(
                        hintText: 'Password',
                        onChanged: (value) {
                          _registerpassword = value;
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
                          visible: _registerFormLoading?false:true,
                          child: Center(
                            child: ElevatedButton(
                              child: Text('Create Account'),
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
                          visible: _registerFormLoading,
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
                child: Text('Back to Login'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
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