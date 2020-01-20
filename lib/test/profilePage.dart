import 'package:challenge_1/resources/data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SignUp.dart';

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
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getDocs();
    if (isSignedIn)
      return MyProfilePage(userEmail, userName, userGender, userPhone,
          userBirthdate, userAddress, userImage, refresh);
    else
      return SignUp();
  }
}

//--------------

class MyProfilePage extends StatefulWidget {
  String _userEmail;
  String name;
  String gender;
  String phone;
  String birthdate;
  String address;
  String image;

  final Function() notifyParent;

  MyProfilePage(this._userEmail, this.name, this.gender, this.phone,
      this.birthdate, this.address, this.image, this.notifyParent);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  Position _currentPosition;

  Widget updateProfileInfo() {
    //todo: update the user info according to email information and do not pass static document ID like this
    Firestore.instance
        .collection('users')
        .document('P86syncJAcKjY9PKq60l')
        .updateData({
      'FirstName':
          (widget.name).substring(0, widget.name.toString().indexOf(' ')),
      'LastName': (widget.name)
          .substring(widget.name.toString().indexOf(' '), widget.name.length),
      'address': widget.address,
      'birthdate': widget.birthdate,
      'gender': widget.gender,
      'phone number': widget.phone,
      'LAT': _currentPosition.latitude,
      'LONG': _currentPosition.longitude,
    });
    print('printing out the data');
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;
    return ListView(
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
                    //in here, an out-of-range error is thrown when name is not ready yet
                    'Hello, ' +
                        '${widget.name.toString().substring(0, widget.name.toString().indexOf(' '))}' +
                        '!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
                //this is not doing what it's supposed to do
//                    Positioned(
//                      top: screenHeight / 11,
//                      left: screenWidth / 6,
//                      child: FloatingActionButton(
//                        onPressed: () {},
//                        child: Icon(Icons.camera_alt),
//                      ),
//                    ),
              ],
            ),
            editable
                ? userInfoBoxEditable(
                    'Name', _nameController, '${widget.name}', 40)
                : userInfoBox('Name', '${widget.name}', _nameController, 40),
            editable
                ? userInfoBoxEditable(
                    'Address', _addressController, '${widget.address}', 80)
                : userInfoBox(
                    'Address', '${widget.address}', _addressController, 80),
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
                    'Gender', _genderController, '${widget.gender}', 40)
                : userInfoBox(
                    'Gender', '${widget.gender}', _genderController, 40),
            editable
                ? userInfoBoxEditable(
                    'Phone Number', _phoneController, '${widget.phone}', 40)
                : userInfoBox(
                    'Phone Number', '${widget.phone}', _phoneController, 40),
            editable
                ? userInfoBoxEditable(
                    'Date of Birth', _dobController, '${widget.birthdate}', 40)
                : userInfoBox(
                    'Date of Birth', '${widget.birthdate}', _dobController, 40),
          ],
        ),
        Container(
          width: 100,
          child: OutlineButton(
            child: Text('Save'),
            onPressed: () {
              //take the info that was put in the name, gender, phone, birthdate, and address textfields and send them as
              //arguments to the next page
              //The Next Page: displays the information entered as read-only and has containers instead of textfields
              editable = false;
              setState(() {
                if (_nameController.text == "" || _nameController.text == null)
                  _nameController.text = widget.name;
                else {
                  widget.name = _nameController.text;
                }
                if (_addressController.text == "" ||
                    _addressController.text == null)
                  _addressController.text = widget.address;
                else {
                  widget.address = _addressController.text;
                }
                if (_phoneController.text == "" ||
                    _phoneController.text == null)
                  _phoneController.text = widget.phone;
                else {
                  widget.phone = _phoneController.text;
                }
                if (_genderController.text == "" ||
                    _genderController.text == null)
                  _genderController.text = widget.gender;
                else {
                  widget.gender = _genderController.text;
                }
                if (_dobController.text == "" || _dobController.text == null)
                  _dobController.text = widget.birthdate;
                else {
                  widget.birthdate = _dobController.text;
                }

                updateProfileInfo(); //send all information to firebase
//                DocumentReference document; //?
//                Firestore.instance.runTransaction((transaction) async{
//                  DocumentSnapshot snapshot = await transaction.get(document.reference);
//                  await transaction.update(snapshot.reference, {
//                    'users': snapshot['users']
//                  });
//                });
                //refresh the profile page to become uneditable
              });
            },
          ),
        ),
        Container(
          width: 100,
          color: Colors.red,
          child: OutlineButton(
            child: Text('Sign Out'),
            onPressed: () {
              //take the info that was put in the name, gender, phone, birthdate, and address textfields and send them as
              //arguments to the next page
              //The Next Page: displays the information entered as read-only and has containers instead of textfields
              editable = false;
              setState(() {
                //go to SignUp page somehow
                isSignedIn = false;
                setState(() {
                  widget.notifyParent();
                });
              });
            },
          ),
        ),
      ],
    );
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
    }).catchError((e) {
      print(e);
    });
    print(_currentPosition);
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
//          hint text: info,
//          style: TextStyle(color: Colors.grey),
        ),
      ),
    ],
  );
}

//shows containers with user info
Widget userInfoBox(String label, String info, var cont, int boxHeight) {
  //get data from firebase and store in controller
  //print('cont: ' + cont);
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
          child: Text((cont.text == null || cont.text == "")
              ? info
              : cont
                  .text), //I need to display the value of cont.text with the latest edited user info but if the field was not edited, it
          //should display the hint value of the textfield
        ),
      ),
    ],
  );
}
