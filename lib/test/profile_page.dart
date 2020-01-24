import 'package:challenge_1/resources/data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'sign_up.dart';
import 'package:challenge_1/main.dart';
import 'package:provider/provider.dart';

bool editable =
    true; //this decides weather info appears as readonly or editable text fields
var _nameController = new TextEditingController();
var _addressController = new TextEditingController();
var _genderController = new TextEditingController();
var _phoneController = new TextEditingController();
var _dobController = new TextEditingController();

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final myModel = Provider.of<MyModel>(
        context); //this makes the ProfilePage act as a consumer

    if (myModel.userIsSignedIn)
      return MyProfilePage();
    else
      return SignInSignUp();
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
    Firestore.instance.collection('users').document(userDocID).updateData({
      'FirstName': userName.contains(' ')?(userName).substring(0, userName.toString().indexOf(' ')):userName,
      'LastName': userName.contains(' ')?(userName)
          .substring(userName.toString().indexOf(' '), userName.length):'',
      'address': userAddress,
      'birthdate': userBirthdate,
      'gender': userGender,
      'phone number': userPhone,
      'LAT': _currentPosition != null ? _currentPosition.latitude : '',
      'LONG':
          _currentPosition != null ? _currentPosition.longitude : '',
    });
    print('printing out the data');
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
    setState(() {
      loading = true;
    });
    final result =
        await Firestore.instance.collection('users').document(userDocID).get();
    if (result.exists) {
      if (result.data['FirstName'] != null) {
        print(result.data['FirstName'] + ' ' + result.data['LastName']);
        userName = result.data['FirstName'] + ' ' + result.data['LastName'];
        userAddress = result.data['address'];
        userGender = result.data['gender'];
        userPhone = result.data['phone number'];
        userImage = result.data['profile picture'];
        userBirthdate = result.data['birthdate'];
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
      print('retrieving data');
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mymodel = Provider.of<MyModel>(
        context); //this makes the ProfilePage act as a consumer

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
                          'Hello, ' + (userName.contains(' ')?'${userName.toString().substring(0, userName.toString().indexOf(' '))}':userName) +
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
                  //the image and 'edit my profile'
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
//                Container(
//                  margin: EdgeInsets.only(left: 10),
//                  //this should be at the far right with a margin
//                  padding: EdgeInsets.zero,
//                  width: 100,
//                  height: 100,
//                  child: Image(
//                    image: AssetImage('coffee.png'),
//                    fit: BoxFit.fitWidth,
//                  ),
//                ),
//                Positioned(
//                  left: 50,
//                  child: OutlineButton(
//                    onPressed: () => null,
//                    child: Text(
//                      "Edit profile",
//                    ),
//                  ),
//                ),
                      //),
                    ],
                  ),
                  editable
                      ? userInfoBoxEditable(
                          'Name', _nameController, userName, 40)
                      : userInfoBox('Name', userName, _nameController, 40),
                  editable
                      ? userInfoBoxEditable(
                          'Address', _addressController, userAddress, 80)
                      : userInfoBox(
                          'Address', userAddress, _addressController, 80),
                  IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () {
                      _getCurrentLocation();
                    },
                  ),
                  Text(_currentPosition != null
                      ? '-> LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude} <-'
                      : 'location undefined'),
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
                      ? userInfoBoxEditable('Date of Birth', _dobController,
                          userBirthdate, 40)
                      : userInfoBox('Date of Birth', userBirthdate,
                          _dobController, 40),
                ],
              ),
              Container(
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
                      print('before updating data');
                      updateProfileInfo(); //send all information to firebase
                    });
                  },
                ),
              ),
              Container(
                width: 100,
                color: Colors.red,
                child: OutlineButton(
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
        child: Container(
          child:
              Text((cont.text == null || cont.text == "") ? info : cont.text),
        ),
      ),
    ],
  );
}
