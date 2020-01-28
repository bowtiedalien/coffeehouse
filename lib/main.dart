import 'package:flutter/material.dart';
import 'test/widget_test.dart';
import 'resources/models.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized(); //initialises flutter's framework - need to use if I'm using systemChannels before runApp()
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: bgColor),
    debugShowCheckedModeBanner: false,
    home: ChangeNotifierProvider<MyModel>(
      create: (context) => MyModel(),
      child: MyApp(),
    ),
  ));
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

class MyModel with ChangeNotifier {
  bool userIsSignedIn = true;
  bool userHasAccount = false;

  void signOut() {
    userIsSignedIn = false;
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

var text = [1,2,3,4];
class Whatever extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
        children: List.generate(text.length,(index){
      return Text(text[index].toString());
    }),
    ),
    );
  }
}
