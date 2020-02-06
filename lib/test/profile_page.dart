import 'package:challenge_1/resources/data.dart';
import 'package:challenge_1/resources/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up.dart';
import 'package:challenge_1/main.dart';
import 'package:provider/provider.dart';
import 'package:challenge_1/resources/data.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool editable =
    true; //this decides weather info appears as readonly or editable text fields
var _nameController = new TextEditingController();
var _addressController = new TextEditingController();
var _genderController = new TextEditingController();
var _phoneController = new TextEditingController();
var _dobController = new TextEditingController();
var _LatAndLongController = new TextEditingController();

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<MyModel>(
        context); //this makes the ProfilePage act as a consumer

    if (myModel.signOutLoading) {
      return CircularProgressIndicator();
    } else {
      if (myModel.userIsSignedIn && userID != '' && userID != null) {
        print('if statement entered and userID = ' + '$userID');
        print(
            'userIsSignedIn from ProfilePage():' + '${myModel.userIsSignedIn}');
        return MyProfilePage();
      } else
        return SignInSignUp();
    }
  }
}

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  Position _currentPosition;
  bool loading = false;

  //when profile page info is updated, send new data to firebase
  void updateProfileInfo() {
    Firestore.instance.collection('users').document(userID).updateData({
      'FirstName': userName.contains(' ')
          ? (userName).substring(0, userName.toString().indexOf(' '))
          : userName,
      'LastName': userName.contains(' ')
          ? (userName)
              .substring(userName.toString().indexOf(' '), userName.length)
          : '',
      'address': userAddress,
      'birthdate': userBirthdate,
      'gender': userGender,
      'phone number': userPhone,
      'LAT': _currentPosition != null ? _currentPosition.latitude : '',
      'LONG': _currentPosition != null ? _currentPosition.longitude : '',
    });
  }

  //display "Hello, User!" at the top of screen
  Widget displayName() {
    if (userName == null)
      return displayName();
    else
      return Text(
        //in here, an out-of-range error is thrown when name is not ready yet
        'Hello, ' +
            '${userName.toString().substring(0, userName.toString().indexOf(' '))}' +
            '!',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      );
  }

  //get user information from Firebase
  Future getUserInfo() async {
    final mymodel = Provider.of<MyModel>(context, listen: false);
    setState(() {
      profilePageIsFetched = false;
      loading = true;
    });
    if (userID == null || userID == '') {
      await fetchUserIDAfterRestart();
    }
    if (userID == null || userID == '') {
      //if fetchUserIDAfterRestart returns empty-handed, userID is still null, so sign out.
      //probs userID is null because it does not exist in the prefs anymore
      mymodel.signOut();
    }
    await findUser(
        userID); //await here prevents next line from executing until getUsers returns its value.
    final result =
        await Firestore.instance.collection('users').document(userID).get();
    print("getUserInfo is accessing document id: " + '$userID');
    if (result.exists) {
      if (result.data['FirstName'] != null) {
        print(result.data['FirstName'] + ' ' + result.data['LastName']);
        userName = result.data['FirstName'] + ' ' + result.data['LastName'];
        userAddress = result.data['address'];
        userGender = result.data['gender'];
        userPhone = result.data['phone_number'];
        userImage = result.data['profile_picture'];
        userBirthdate = result.data['birthdate'];
        locationLAT = result.data['LAT'];
        locationLONG = result.data['LONG'];
      } else {
        userName = "User 1";
        userAddress = "";
        userGender = "";
        userPhone = "";
        userPhone = "";
        userImage = "";
        userBirthdate = "";
      }
      setState(() {
        loading = false;
        profilePageIsFetched = true;
      });
    } else
      print('can not access user info from getUserInfo()');
  }

  //retrieve longitude and latitude of user's location
  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      print(position);
      setState(() {
        _currentPosition = position;
        print(position);
      });
    });
    //this prevents info from being sent to Firestore when location has not been retrieved. Unnecessary error catching.
//        .catchError((e) {
//      print(e);
//    });
    print(_currentPosition);
  }

  @override
  void initState() {
    getUserInfo();
    print('initSatte');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mymodel = Provider.of<MyModel>(
        context); //this makes the ProfilePage act as a consumer

    print('MyProfilePage() says userIsSignedIn:' + '${mymodel.userIsSignedIn}');
    return loading && !profilePageIsFetched
        ? Center(child: CircularProgressIndicator())
        : ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 10, left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Hello, ' +
                              (userName.contains(' ')
                                  ? '${userName.toString().substring(0, userName.toString().indexOf(' '))}'
                                  : userName) +
                              '!',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        OutlineButton(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          child: Text('Edit Profile'),
                          onPressed: () {
                            editable = true;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Row(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: 120,
                            child: Image(
                              image: AssetImage('affogato.png'),
                            ),
                          ),
                          Positioned(
                            top: 70,
                            left: 90,
                            child: FloatingActionButton(
                              child: Icon(Icons.camera_alt),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  //the image and 'edit my profile'
                  editable
                      ? userInfoBoxEditable(
                          'Name', _nameController, userName, 40)
                      : userInfoBox('Name', userName, _nameController, 40),
                  editable
                      ? userInfoBoxEditable(
                          'Address', _addressController, userAddress, 80)
                      : userInfoBox(
                          'Address', userAddress, _addressController, 80),
                  editable
                      ? Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 27),
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: Colors.brown[200]),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.5),
                                    blurRadius: 5.0, // soften the shadow
                                    offset: Offset(
                                      3.0, // Move to right 10  horizontally
                                      0.0, // Move to bottom 10 Vertically
                                    ),
                                  )
                                ],
                              ),
                              height: 40,
                              width: 250,
                              child: TextField(
                                controller: _LatAndLongController,
                                decoration: InputDecoration(
                                  hintText: 'undefined coordinates',
                                  border: InputBorder.none,
                                ),

                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.location_on),
                              onPressed: () {
                                _getCurrentLocation();
                                _LatAndLongController.text = '${_currentPosition.latitude}' + ',' + '${_currentPosition.longitude}';
                              },
                            ),
                          ],
                        )
                      : Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: ppBoxColor),
                    ),
                    height: 40,
                    width: 310,
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        _currentPosition != null
                            ? '-> LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude} <-'
                            : 'location undefined',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),

                  editable
                      ? userInfoBoxEditable(
                          'Gender', _genderController, userGender, 40)
                      : userInfoBox(
                          'Gender', userGender, _genderController, 40),
                  editable
                      ? userInfoBoxEditable(
                          'Phone Number', _phoneController, userPhone, 40)
                      : userInfoBox(
                          'Phone Number', userPhone, _phoneController, 40),
                  editable
                      ? userInfoBoxEditable(
                          'Date of Birth', _dobController, userBirthdate, 40)
                      : userInfoBox(
                          'Date of Birth', userBirthdate, _dobController, 40),
                ],
              ),
              !editable
                  ? Container()
                  : Container(
                      width: 100,
                      child: OutlineButton(
                        child: Text('Save'),
                        onPressed: () {
                          //1. refresh page to be read-only
                          editable = false;

                          //2. send info to firestore
                          setState(() {
                            if (_nameController.text == "" ||
                                _nameController.text == null)
                              _nameController.text = userName;
                            else {
                              userName = _nameController.text;
                            }
                            if (_addressController.text == "" ||
                                _addressController.text == null)
                              _addressController.text = userAddress;
                            else {
                              userAddress = _addressController.text;
                            }
                            if (_phoneController.text == "" ||
                                _phoneController.text == null)
                              _phoneController.text = userPhone;
                            else {
                              userPhone = _phoneController.text;
                            }
                            if (_genderController.text == "" ||
                                _genderController.text == null)
                              _genderController.text = userGender;
                            else {
                              userGender = _genderController.text;
                            }
                            if (_dobController.text == "" ||
                                _dobController.text == null)
                              _dobController.text = userBirthdate;
                            else {
                              userBirthdate = _dobController.text;
                            }
                            updateProfileInfo(); //send all information to firebase
                          });
                        },
                      ),
                    ),
              Container(
                color: Colors.red,
                child: FlatButton(
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    editable = false;
                    setState(() {
                      mymodel.signOut();
                    });
                  },
                ),
              ),
            ],
          );
  }
}

//shows text fields with user info
Widget userInfoBoxEditable(String label, var cont, String info, int boxHeight) {
  return Column(
    children: <Widget>[
      //box label
      Container(
        margin: EdgeInsets.only(left: 20, bottom: 5),
        alignment: Alignment.topLeft,
        child: Text(label),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.brown[200]),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 5.0, // soften the shadow
              offset: Offset(
                3.0, // Move to right 10  horizontally
                0.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        height: boxHeight.toDouble(),
        width: 310,
        child: TextField(
          controller: cont,
          decoration: InputDecoration(
            hintText: info,
            border: InputBorder.none,
          ),
        ),
      ),
    ],
  );
}

//shows containers with user info
Widget userInfoBox(String label, String info, var cont, int boxHeight) {
  return Column(
    children: <Widget>[
      //box label
      Container(
        margin: EdgeInsets.only(left: 20, bottom: 5),
        alignment: Alignment.topLeft,
        child: Text(label),
      ),
      Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: ppBoxColor),
//          color: ppBoxColor,
        ),
        height: boxHeight.toDouble(),
        width: 310,
        child: Container(
          color: Colors.transparent,
          child: Text(
            (cont.text == null || cont.text == "") ? info : cont.text,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    ],
  );
}
