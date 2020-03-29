//import 'dart:html';
//
import 'dart:convert';
import 'dart:io';
//import 'dart:html';

import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
//import 'package:image_picker_modern/image_picker_modern.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:path_provider/path_provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

void main() => runApp(MyFirstApp());
var userId = "";
var udchaloId = "";
class MyFirstApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: MyApp());
  }

}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
          appBar:AppBar(
            title: Text("udChalo"),
//            leading: GestureDetector(
//              onTap: (){print("anwar");},
//              child: Icon(
//                  Icons.menu
//              ),
//            ),

            actions: <Widget>[
              FlatButton(
                child: Text("Log In"),
                onPressed: () {
                  print("baba anwar");
                  Navigator.push(context, MaterialPageRoute<void>(
                    builder: (context) => LoginMethod(),
                  ));
                },
              )
            ],
          ),
        body: BodyLayout(),
        bottomNavigationBar: BottomNavigationBarClass(),
        drawer: DrawerClass(),
      );
    // home: MyHomePage(title: 'Flutter Demo Home Page'),
  }
}

Widget loginSignUpWidget(BuildContext context) {
  final String loginUrl = "https://dev-server.udchalo.com/api/user/login";
  final String getProfileUrl = "https://dev-server.udchalo.com/api/user/getProfile";
  return Form(
    child: Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: "Enter Email Address."
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: "Enter Password."
          ),
        ),
        FlatButton(
          child: Text('Log In'),
          onPressed: () async {
            var body = {
              "email": "271coder271@gmail.com",
              "password": "Udchalo@123"
            };
            var loginData =  await createPost(loginUrl,body: body);
            userId = loginData;
            var userName = await getProfile(getProfileUrl);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Future<String> signInWithFacebook() async {
  print(1);
  //final facebookLogin = FacebookLogin();
  print("anwart");
  //print(facebookLogin);
  //final result = await facebookLogin.logInWithReadPermissions(['email']);
  //print(result);
}

Future<String> signInWithGoogle() async {
  print(1);
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  print(googleSignInAccount);
  final GoogleSignInAuthentication googleSignInAuthentication =
  await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final AuthResult authResult = await _auth.signInWithCredential(credential);
  final FirebaseUser user = authResult.user;

  assert(!user.isAnonymous);
  assert(await user.getIdToken() != null);

  final FirebaseUser currentUser = await _auth.currentUser();
  assert(user.uid == currentUser.uid);

  return 'signInWithGoogle succeeded: $user';
}

Widget _loginSignUpCard(BuildContext context) {
  return ListView(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          children: <Widget>[
            Card(
              color: Colors.blue,
              child: ListTile(title: Text('LOG IN', textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute<void> (
                  builder: (context) => Login(),
                ));
              }),
            ),
            Card(child: ListTile(title: Text('SIGN UP', textAlign: TextAlign.center, style: TextStyle(color: Colors.blue),),
            onTap: () {
              Navigator.push(context, MaterialPageRoute<void> (
                builder: (context) => SignUp(),
              ));
            },),

              color: Colors.grey,),
            Card(child: ListTile(title: Text('CONNECT WITH GOOGLE ',style: TextStyle(color: Colors.white),),
            onTap: () async {
              var googleUser = await signInWithGoogle();
            },
            leading: Icon(MdiIcons.google)),
              color: Colors.red,),
            Card(child: ListTile(title: Text('CONNECT WITH FACEBOOK',style: TextStyle(color: Colors.white),),
                onTap: () async {
                  var facebookUser = await signInWithFacebook();
                },
                leading: Icon(MdiIcons.facebook)),
              color: Colors.blue,),
          ],
        ),
      ),
    ],
  );
}

class loginSignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return loginSignUpWidget(context);
  }

}

class LoginSignUpCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _loginSignUpCard(context);
  }
}

class LoginMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login/SignUp Card'),
      ),
      body: LoginSignUpCard(),
    );
  }
}


class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign UP Form'),
      ),
      body: SignUpFormBody(),
    );
  }
}

class SignUpFormBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _signUpFormBody(context);
  }
}

Widget _signUpFormBody(BuildContext context) {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController buddyInvite = TextEditingController();


  return Form(
    child: Column(
      children: <Widget>[
        TextFormField(
          controller: fullName,
          decoration: InputDecoration(labelText: 'Full Name*'),
        ),
        TextFormField(
          controller: email,
          decoration: InputDecoration(labelText: 'Email Address*'),
        ),
        TextFormField(
          controller: phoneNumber,
          decoration: InputDecoration(labelText: 'Phone Number*'),
        ),
        TextFormField(
          controller: password,
          obscureText: true,
          decoration: InputDecoration(labelText: 'Choose Password*',
          suffixIcon: Container(
            child: Icon(Icons.visibility),
          )
          ),

        ),
        TextFormField(
          controller: buddyInvite,
          decoration: InputDecoration(labelText: 'Enter Buddy Invite Code'),
        ),
        Container(
          padding: EdgeInsets.all(40),
          child: Card(
            child: ListTile(
              //Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
              title: Text('Sign Up'),
            ),
            color: Colors.blue,
          ),
        )
      ],
    ),
  );
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login/SignUp Form'),
      ),
      body: loginSignUp(),
    );
  }

}

class DrawerClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _drawer(context);
  }
} // drawerClass

Widget _drawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        //Divider(),
        DrawerHeader(
          child: Text("Hi Welcome!"),
          decoration: BoxDecoration(
            color: Colors.blue
          ),
        ),
        ListTile(
          title: Text("Flights"),
          leading: Icon(Icons.flight),
          onTap: () async {
            var url = "https://www.udchalo.com/flights";
            LaunchUrl(url);
          },
        ),
        //Divider(),
        ListTile(
          title: Text("Hotels"),
          leading: Icon(Icons.hotel),
          onTap: () async {
            var url = "https://www.udchalo.com/hotels";
            LaunchUrl(url);
          },
        ),
        //Divider(),
        ListTile(
          title: Text("Cabs"),
          leading: Icon(Icons.directions_car),
          onTap: () async {
            var url = "https://www.udchalo.com/cabs";
            LaunchUrl(url);
          },
        ),
        //Divider(),
        ListTile(
          title: Text("Buses"),
          leading: Icon(Icons.directions_bus),
          onTap: () async {
            var url = "https://www.udchalo.com/buses";
            LaunchUrl(url);
          },
        ),
        //Divider(),
        ListTile(
          title: Text("Support"),
          contentPadding: EdgeInsets.only(left: 22),
          trailing: Icon(Icons.arrow_right),
        ),
        //Divider(),
        ListTile(
          title: Text("Company"),
          contentPadding: EdgeInsets.only(left: 22),
          trailing: Icon(Icons.arrow_right),
        ),
        //Divider(),
        ListTile(
          title: Text("Opertunities"),
          contentPadding: EdgeInsets.only(left: 22),
          trailing: Icon(Icons.arrow_right),
        ),
        ListTile(
          title: Text("Important Links"),
          contentPadding: EdgeInsets.only(left: 22),
          trailing: Icon(Icons.arrow_right),
        ),
      ],
    ),
  );
}

class BottomNavigationBarClass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _bottomNavigationBar(context);
  }
} // BottomNavigationBarClass

Widget _bottomNavigationBar(BuildContext context) {
  return BottomNavigationBar(
    currentIndex: 0,
    type: BottomNavigationBarType.fixed,
    onTap: (int val) async {
      var url = "";
      switch(val) {
        case 1: url = "https://www.udchalo.com/flights";
          break;
        case 2: url = "https://www.udchalo.com/hotels";
        break;
        case 3: url = "https://www.udchalo.com/cabs";
        break;
        case 4: url = "https://www.udchalo.com/buses";
        break;
      };
      LaunchUrl(url);
    },
    items: [
      BottomNavigationBarItem(
        title: Text("Home"),
        icon: Icon(Icons.home)
      ),
      BottomNavigationBarItem(
          title: Text("Flights"),
          icon: Icon(Icons.flight),

      ),
      BottomNavigationBarItem(
          title: Text("Hotels"),
          icon: Icon(Icons.hotel)
      ),
      BottomNavigationBarItem(
          title: Text("Cabs"),
          icon: Icon(Icons.directions_car)
      ),
      BottomNavigationBarItem(
          title: Text("Buses"),
          icon: Icon(Icons.directions_bus)
      ),
      BottomNavigationBarItem(
          title: Text("Profile"),
          icon: Icon(Icons.person)
      ),
      BottomNavigationBarItem(
          title: Text("Support"),
          icon: Icon(Icons.headset)
      ),
    ],
  );
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
} // BodyLayout

class Post {
  final String origin;
  final String destination;
//  final int year;
//  final int month;
//  final int date;
  final Object travelDate = {
    "year":2020,
    "month":4,
    "day": 25
  };
  final String tripType;
  final int adults;
  final int children;
  final int infants;
  final String cabin;
  final bool isDefence;
  final bool isLTCClaim;
  final String originCountryCode;
  final String destinationCountryCode;
  final String referrer;
  final String serviceNumber;
  final String userCategory;
  Post({this.origin, this.destination, this.tripType,
  this.adults, this.children, this.infants, this.cabin, this.isDefence,
  this.isLTCClaim, this.originCountryCode, this.destinationCountryCode,
  this.referrer, this.serviceNumber, this.userCategory});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      origin: json['userId'],
      destination: json['response']['udchaloId']
    );
  }

  Map toMap() {
    var map = new Map<dynamic, dynamic>();
    map["origin"] = origin;
    map["destination"] = destination;
    map["travelDate"] = travelDate;
    map["tripType"] = tripType;
    map["adults"] = adults;
    map["children"] = children;
    map["infants"] = infants;
    map["cabin"] = cabin;
    map["isDefence"] = isDefence;
    map["isLTCClaim"] = isLTCClaim;
    map["originCountryCode"] = originCountryCode;
    map["destinationCountryCode"] = destinationCountryCode;
    map["referrer"] = referrer;
    map["serviceNumber"] = serviceNumber;
    map["userCategory"] = userCategory;
    return map;
  }
}
class User {
  final String email;
  final String userId;
  final String phoneNumber;
//  final int year;
//  final int month;
//  final int date;
   Object name = {
    "title":"Mr.",
    "firstName":"Guest",
    "middleName": "",
    "lastName": ""
  };
  User({this.email,this.userId,this.name,this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        email: json['email'],
        userId: json['userId'],
        phoneNumber: json['phoneNumber']
    );
  }
}

Future<dynamic> createPost(String url, {body}) async {
  print(body);
  //url = "http://localhost:4300/api/flights/searchInit";
  print(url);
//  body = {
//    "email": "271coder271@gmail.com",
//    "password": "Udchalo@123"
//  };
  //url = "https://dev-server.udchalo.com/api/user/login";
  //return "anwar";
  //final data = await http.get('https://dev-server.udchalo.com/api/flights/getAirports');
  var bodyData = {"tripType":"oneway","origin":"PNQ","destination":"DEL","departDate":{"year":2020,"month":3,"day":21},"adults":1,"children":0,"infants":0,"cabin":"Economy","isDefence":false,"isLTCClaim":false,"originCountryCode":"IN","destinationCountryCode":"IN","referrer":"","serviceNumber":"","userCategory":"Retail"};
  final data = await http.post(url,body: body);
  print(json.decode(data.body));
  var x = Post.fromJson(json.decode(data.body));
  userId = x.origin;
  udchaloId = x.destination;
  print(x.origin);
  print(x.destination);
  return x.origin;
  //var x = json.decode(data);
}

Future<dynamic> getProfile(String url) async {
  //url = "http://localhost:4300/api/flights/searchInit";
  print(url);
//  body = {
//    "email": "271coder271@gmail.com",
//    "password": "Udchalo@123"
//  };
  //url = "https://dev-server.udchalo.com/api/user/login";
  //return "anwar";
  //final data = await http.get('https://dev-server.udchalo.com/api/flights/getAirports');
  var headers = {HttpHeaders.authorizationHeader: udchaloId};
  final data = await http.get(url, headers: headers);
  var decodeData = json.decode(data.body);
  var x = User.fromJson(json.decode(data.body));
  userId = x.userId;
  print(decodeData);
  return x.email;
  //var x = json.decode(data);
}

class SearchFlightPage extends StatelessWidget {
  final Future<Post> post;
  SearchFlightPage({Key key, this.post}) : super(key: key);
  static final searchUrl = "https://dev-server.udchalo.com/api/flights/searchInit";
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("anwar");
    return Scaffold(
      appBar: AppBar(title: Text('Search Flight')),
      body: Container(
//        child: Column(
//          children: <Widget>[
//            Container(
//              child: Row(
//                children: <Widget>[
//                  TextFormField(
//                    controller: originController,
//                    decoration: InputDecoration(labelText: "Origin"),
//                  ),
//                  TextFormField(
//                    controller: destinationController,
//                    decoration: InputDecoration(labelText: "Destination"),
//                  )
//                ],
//              ),
//            ),
//            RaisedButton(
//              onPressed: () async {
//                Post newPost = new Post(origin: originController.text,destination: destinationController.text,
//                              tripType: "oneWay", adults: 1, children: 0, infants: 0,
//                              cabin: "Economy", isDefence: false, isLTCClaim: false, originCountryCode: "IN",
//                              destinationCountryCode: "IN", referrer: "", serviceNumber: null, userCategory: "Retail");
//              },
//              child: Text("Search"),
//            ),
//          ],
//        ),

        child: new Column(

          children: <Widget>[
            new TextField(
              controller: originController,
              decoration: InputDecoration(labelText: 'Origin'),
            ),
            new TextField(
              controller: destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
            ),
            RaisedButton(
              onPressed: () async {
                var newPost = {"origin": originController.text,"destination": destinationController.text,
                              "tripType": "oneWay", "adults": 1, "children": 0, "infants": 0,
                              "cabin": "Economy", "isDefence": false, "isLTCClaim": false, "originCountryCode": "IN",
                              "destinationCountryCode": "IN", "referrer": "", "serviceNumber": null, "userCategory": "Retail"};
                var searchData = await createPost(searchUrl, body: newPost);
                },
              child: Text("Search"),
            ),
          ],
        ),
//      child: TextFormField(
//        controller: destinationController,
//        decoration: InputDecoration(labelText: "Destination"),
//      ),
      ),
    );
  }

}

Future<dynamic> LaunchUrl(url) async{
  print(url);
  if(await canLaunch(url)) {
    launch(url);
  }
  else {
    print('can`t load $url');
  }
}

Widget _myListView(BuildContext context) {
  return ListView(
    children: <Widget>[
      ListTile(
        title: Text("Flights"),
        leading: Icon(Icons.flight),
        onTap: (){
          Navigator.push(context, MaterialPageRoute<void>(
            builder: (context) => SearchFlightPage(),
          ));
        },
        subtitle: Text("Search & book domestic flights."),
      ),
      Divider(),
      ListTile(
        title: Text("Hotels"),
        leading: Icon(Icons.hotel),
        subtitle: Text("Search & book domestic hotels."),
        onTap: () async {
          var url = "https://www.udchalo.com/hotels";
          LaunchUrl(url);
        },
      ),
      Divider(),
      ListTile(
        title: Text("Cabs"),
        leading: Icon(Icons.directions_car),
        subtitle: Text("Search & book intercity cabs."),
        onTap: () async {
          var url = "https://www.udchalo.com/cabs";
          LaunchUrl(url);
        },
      ),
      Divider(),
      ListTile(
        title: Text("Buses"),
        leading: Icon(Icons.directions_bus),
        subtitle: Text("Search & book buses."),
        onTap: () async {
          var url = "https://www.udchalo.com/buses";
          LaunchUrl(url);
        },
      ),
      Divider(),
      ListTile(
        title: Text("Support Elements"),
        leading: Icon(Icons.help),
        subtitle: Text("others."),
        onTap: () {
          print("anwar");
          Navigator.push(context, MaterialPageRoute<void> (
            builder: (context) => SupportElement(),
          ));
        },
      ),
    ],

  );
}// _myListView

class SupportElement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support Elements.',
        style: TextStyle(color: Colors.black),),
      ),
      body: _supportElement(context),
    );
  }
}

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);
  final VideoPlayerController controller;
  @override
  _aspectRatioVideo createState() => _aspectRatioVideo();
}

class _aspectRatioVideo extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;
  void _onVideoControllerUpdate() {
    print("baba data");
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    // _controller = VideoPlayerController.network(
    //      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    //    );
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

}

class VideoPickerClass extends StatefulWidget {
  @override
  _videoPickerClass createState() => _videoPickerClass();
}

class _videoPickerClass extends State<VideoPickerClass> {
  dynamic _video;
  VideoPlayerController _controller;

  Future<void> _videoPlayer(file) async {
    if(file != null) {
      await _disposeVideoController();
      _controller = VideoPlayerController.file(file);
      await _controller.setVolume(1.0);
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();
      setState(() {});
    }
  }
  void getVideo() async {
    final File file = await ImagePicker.pickVideo(source: ImageSource.gallery);
    await _videoPlayer(file);
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.pause();
    }
    super.deactivate();
  }
  Future<void> _disposeVideoController() async {
    if (_controller != null) {
      await _controller.dispose();
      _controller = null;
    }
  }
  Widget _previewVideo() {
    if (_controller == null) {
      return Center(
           child: Text(
             'You have not yet picked a video',
             textAlign: TextAlign.center,
             style: TextStyle(color: Colors.blue),
           ),
      );
    }
    else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            AspectRatioVideo(_controller),
            Padding(
              padding: EdgeInsets.only(top:10),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    if(_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                tooltip: 'play',
                child: _controller.value.isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              ),
            ),
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: _previewVideo(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Video',
        child: Icon(Icons.video_label),
        onPressed: getVideo,
      ),
    );
  }

}

class ImagePickerClass extends StatefulWidget {
  @override
  _imagePickerclass createState() => _imagePickerclass();
}

class _imagePickerclass extends State<ImagePickerClass> {

  File _image;
  Future<dynamic> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    print('imagepicker');
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      body: Center(
        child: _image == null
        ? Text('No Image Selected',style: TextStyle(color: Colors.blue))
        : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

}

class OpenPdfClass extends StatefulWidget {
  @override
  _openPdfClass createState() => _openPdfClass();
}
class _openPdfClass extends State<OpenPdfClass> {
  String pathPdf = "";
  @override
  void initState() {
    super.initState();
    var url = "https://www.qualitychess.co.uk/ebooks/Grandmaster-vs-Amateur-excerpt.pdf";
    getPdfFile(url).then((file) {
      setState(() {
        pathPdf = file.path;
        print(pathPdf);
      });
    });
  }
  Future<dynamic> getPdfFile(url) async {
    var data = await http.get(url);
    var bytes = data.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/anwar.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  Widget previewPdf() {
    return Center(
      child: Text('Pdf not yet selected', style: TextStyle(color: Colors.blue),),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Prf'),
      ),
      body: previewPdf(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => PDFScreen(pathPdf),
          ));
        },
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }
}

class PDFScreen extends StatelessWidget {

  String pathPdf = "";
  PDFScreen(this.pathPdf);
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
        title: Text('Pdf'),
      ),
      path: pathPdf,
    );
  }

}

Widget _supportElement(BuildContext context) {
  return ListView(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Card(child: ListTile(title: Text('Open Url.'),
            onTap: () async {
              print("anwar raha");
              //const url = 'https://flutter.dev/exapmle.pdf';
              const url = 'https://www.youtube.com/watch?v=VbKY5eUGSJU';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },),
            ),
            Card(child: ListTile(title: Text('Image Picker.'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ImagePickerClass(),
              ));
            },
            ),),
            Card(child: ListTile(title: Text('Video Picker.'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => VideoPickerClass(),
                ));
              },
            ),),
            Card(child: ListTile(title: Text('Open Pdf.'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => OpenPdfClass(),
                ));
              },
            ),),
          ],
        ),
      ),
//      ListTile(
//        title: Text("Open Pdf."),
//        onTap: () {
//
//        },
//      ),
//      Divider(),
    ],
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
