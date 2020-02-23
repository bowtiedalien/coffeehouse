import 'package:challenge_1/main.dart';
import 'package:challenge_1/resources/data.dart';
import 'package:challenge_1/resources/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'profile_page.dart';
import 'shopping_cart.dart';
import 'dart:async';

bool getAvailableProductsCalled = false;

FontWeight homeScreenTitleFontWeight;
Color homeScreenTitleColor;

//MyApp -- Splash Screen
class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget changeState() {
    changestate();
    return Container();
  }

  void changestate() {
    setState(() {
      homeScreenTitleFontWeight = FontWeight.bold;
      homeScreenTitleColor = Colors.white;
    });
  }

  //splash screen effect - wait for 3 seconds then redirect to HomePage
  @override
  void initState() {
    homeScreenTitleFontWeight = FontWeight.w100;
    homeScreenTitleColor = Colors.grey;

    super.initState();
    Future.delayed(
      Duration(seconds: 5),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    final mymodel = Provider.of<MyModel>(context, listen: false);

    if (!getAvailableProductsCalled) {
      getAvailableProducts(); //debugging
      getAvailableProductsCalled = true;
    }
    double screenWidth = MediaQuery.of(context)
        .size
        .width; //save screen dimensions in a variable
    double screenHeight = MediaQuery.of(context).size.height;

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          localizationDelegate
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        home: Scaffold(
          backgroundColor: bgColor,
          body: Column(
            children: <Widget>[
              Container(
                width: screenWidth - 50,
                margin: EdgeInsets.fromLTRB(59, 70, 0, 0),
                child: AnimatedDefaultTextStyle(
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: homeScreenTitleFontWeight,
                    color: homeScreenTitleColor,
                  ),
                  duration: const Duration(milliseconds: 500),
                  child: Text(
                    "Welcome to" + "\nCoffee House",
                  ),
                ),
              ),
              changeState(),
              Container(
                margin: EdgeInsets.only(top: screenHeight / 7.2),
                child: Image.asset(
                  'coffee.png',
                  fit: BoxFit.scaleDown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Homepage - the bottom Nav Bar + it is where the redirection happens
//it redirects to one of the three pages; MyHomePage, ShoppingCart or ProfilePage

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final _pageOptions = [
    MyHomePage(),
    ShoppingCart(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return ChangeNotifierProvider(
      create: (context) => MyModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(translate('title')),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                  accountEmail: Text(userEmail!=null?userEmail:'user@email.com'),
                  accountName: Text(userName!=null?userName:'User Name'),
                  currentAccountPicture: profilePicture!=null?Image.file(profilePicture):Image.asset('coffee-avatar.png'),),
              ListTile(
                title: Text(
                  translate('language.selected_message', args: {
                    'language': translate(
                        'language.name.${localizationDelegate.currentLocale.languageCode}')
                  }),
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Icon(
                  Icons.translate,
                  color: bgColor,
                ),
                onTap: () => _onActionSheetPress(context),
              ),
            ],
          ),
        ),
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(
              () {
                _selectedPage = index;
              },
            );
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text('home'),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              title: Text('shopping basket'),
              icon: Icon(Icons.shopping_basket),
            ),
            BottomNavigationBarItem(
              title: Text('profile'),
              icon: Icon(Icons.person),
            )
          ],
        ),
      ),
    );
  }

  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String value) {
      changeLocale(context, value);
    });
  }

  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(translate('language.selection.title')),
        message: Text(translate('language.selection.message')),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.name.en')),
            onPressed: () => Navigator.pop(context, 'en_US'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.tr')),
            onPressed: () => Navigator.pop(context, 'tr'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.ar')),
            onPressed: () => Navigator.pop(context, 'ar'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate('button.cancel')),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }
}
