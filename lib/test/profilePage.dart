import 'package:challenge_1/resources/data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/rendering.dart';
import 'SignUp.dart';

bool editable =
    false; //this decides weather info appears as readonly or editable text fields

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    getDocs();
    if (isSignedIn)
      return MyProfilePage(userEmail, userName, userGender, userPhone,
          userBirthdate, userAddress, userImage);
    else
      return SignUp();
  }
}

//--------------

class MyProfilePage extends StatefulWidget {
  final _userEmail;
  final name;
  final gender;
  final phone;
  final birthdate;
  final address;
  final image;

  MyProfilePage(this._userEmail, this.name, this.gender, this.phone,
      this.birthdate, this.address, this.image);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 10, left: 5),
              child: Text(
                //in here, an out-of-range error is thrown when name is not ready yet
                'Hello, ' +
                    '${widget.name.toString().substring(0, widget.name.toString().indexOf(' '))}' +
                    '!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Divider(),
            //the image and 'edit my profile'
            Stack(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      //this should be at the far right with a margin
                      padding: EdgeInsets.zero,
                      width: 100,
                      height: 100,
                      child: Image(
                        image: AssetImage('coffee.png'),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
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
                Positioned(
                  left: 50,
                  child: OutlineButton(
                    onPressed: () => null,
                    child: Row(
                      children: <Widget>[
                        //this should be at the far right with a margin
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            "Edit profile",
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            editable
                ? userInfoBoxEditable('Name', '${widget.name}', 40)
                : userInfoBox('Name', '${widget.name}', 40),
            editable
                ? userInfoBoxEditable('Address', '${widget.address}', 80)
                : userInfoBox('Address', '${widget.address}', 80),
            FlatButton(
                child: Text('Get location'),
                onPressed: () {
                  _getCurrentLocation();
                }),
            Text(_currentPosition!=null?'LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}':'location undefined'),
            editable
                ? userInfoBoxEditable('Gender', '${widget.gender}', 40)
                : userInfoBox('Gender', '${widget.gender}', 40),
            editable
                ? userInfoBoxEditable('Phone Number', '${widget.phone}', 40)
                : userInfoBox('Phone Number', '${widget.phone}', 40),
            editable
                ? userInfoBoxEditable(
                    'Date of Birth', '${widget.birthdate}', 40)
                : userInfoBox('Date of Birth', '${widget.birthdate}', 40),
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
            },
          ),
        ),
      ],
    );
  }

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
Widget userInfoBoxEditable(String label, String info, int boxHeight) {
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
Widget userInfoBox(String label, String info, int boxHeight) {
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
          child: Text(info),
        ),
      ),
    ],
  );
}
