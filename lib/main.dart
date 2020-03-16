import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = 'You are not sign in';

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    setState(() {
      // User đã login
      _message = "You are signed in";
    });
    return user;
  }

  Future _handleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    setState(() {
      // log out
      _message = "You are not sign out";
    });
  }

  Future _checkLogin() async {
    // Khi mở app lên thì check xem user đã login chưa
    final FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      setState(() {
        _message = "You are signed in";
      });
    }
  }

  @override

  void initState() {
    _checkLogin();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase login'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_message),

          OutlineButton(
            onPressed: () {
              _handleSignIn();
            },
            child: Text('Login'),
          ),
          OutlineButton(
            onPressed: () {
              _handleSignOut();
            },
            child: Text('Logout'),
          )
        ],
      )),
    );
  }
}
