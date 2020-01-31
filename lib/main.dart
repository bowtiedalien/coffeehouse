import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'test/widget_test.dart';
import 'resources/models.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'test/sign_in.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized(); //initialises flutter's framework - need to use if I'm using systemChannels before runApp()
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: bgColor),
    debugShowCheckedModeBanner: false,
    home: ChangeNotifierProvider<MyModel>(
      create: (context) => MyModel(),
      child: MyApp(), //change this back to MyApp()
    ),
  ));
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

class MyModel with ChangeNotifier {
  //setters and getters:
  bool _userIsSignedIn = FirebaseAuth.instance.currentUser() !=
      null; //if the currentUser is not null, set userIsSignedIn to true

  bool signOutLoading = false;
  void printFoo() async {
    print('from MyModel: is user signed in? ' + '$_userIsSignedIn');
    print('currentUser:' + '${await FirebaseAuth.instance.currentUser()}');
  }

  bool get userIsSignedIn {
    return _userIsSignedIn;
  }

  set userIsSignedIn(bool v) {
    _userIsSignedIn = v;
    notifyListeners();
  }

  //--------------

  bool userHasAccount = false;

  void signOut() async {

    SharedPreferences pref = await SharedPreferences.getInstance();
//    pref.setString('userID', ''); //discarding the value of userID
    pref.remove('userID');
    pref.clear();

    signOutLoading = true;
    notifyListeners();
    FirebaseAuth.instance.signOut().then((value) {
      userIsSignedIn = false;
      signOutLoading = false;
    });
    notifyListeners();
  }

  void signIn() {
    userHasAccount = true;
    notifyListeners();
  }

  void signUp() {
    userHasAccount = false;
    notifyListeners();
  }

  void showProfile() {
    userIsSignedIn = true;
    notifyListeners();
  }
}
