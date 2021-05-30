import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_amiis_tutorial/Firebase_Contro.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool addUser = false;

  AmisCall fire = new AmisCall();

  void _addUserToFirebase() async {

    try {
      fire.imageadding(imgFile).then((val){
        print('Image url : '+val.toString());
        Map<String, String> userTable = {
          "name": _name.text,
          "email": _email.text,
          "phone": _mob.text,
          "image" : val.toString()
        };
        fire.uploadUserInfo(userTable,"user@"+_name.text);
        setState(() {
          addUser=false;
          _name.text = "";
          _email.text = "";
          _mob.text = "";
          imgFile=null;

        });
      });

    } catch (e) {
      print('error messaaggeeee : $e');
    }
  }

  Stream userData;

  _getUserInfo() {
    fire.getUserInfo().then((val) {
      print("GGGGGGGGGGGGGGG :" + val.toString());
      setState(() {
        userData = val;
      });
    });
  }

  TextEditingController _name = TextEditingController();
  TextEditingController _mob = TextEditingController();
  TextEditingController _email = TextEditingController();

  @override
  void initState() {
    _getUserInfo();
    // TODO: implement initState
    super.initState();
  }

  File imgFile;

  Future<Null> _pickImage() async {
    var file = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    if (file != null) {
      setState(() {
        imgFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Amiis Firebase"),
      ),
      body: addUser
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          labelText: "Name"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          labelText: "Email"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _mob,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          labelText: "Phone Number"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                imgFile !=null ? Container(
                    height: 80,
                    width: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Image.file(imgFile,fit: BoxFit.cover,)) :  Container(),
                    SizedBox(
                      height: 10,
                    ),

                    MaterialButton(
                      height: 30,
                      minWidth: 100,
                      color: Colors.red,
                      onPressed: (){
                        _pickImage();
                      },
                      child: Center(child: Text("Add profile",style: TextStyle(color: Colors.white),),),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          _addUserToFirebase();
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          setState(() {
                            _name.text = "";
                            _email.text = "";
                            imgFile=null;
                            _mob.text = "";
                          });
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue[800],
                      ),
                    )
                  ],
                ),
              ),
            )
          : StreamBuilder(
              stream: userData,
              builder: (context, dattta) {
                return dattta.hasData ? Padding(
                      padding: const EdgeInsets.only(left:12,right: 12,top: 10),
                      child: dattta.data.documents.length>0
                          ?  ListView.builder(
                          itemCount: dattta.data.documents.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.grey[300],spreadRadius: 1,blurRadius: 1)]
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: (){
                                              fire.deleteUser(dattta.data.documents[index].documentID);
                                            },
                                            icon: Icon(Icons.delete_outline),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                              height: 80,
                                              width: 80,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(100)
                                              ),
                                              child: Image.network(dattta.data.documents[index]["image"],fit: BoxFit.cover,)),
                                          SizedBox(width: 10,),
                                          Column(
                                            children: [
                                              Text("Name : "+dattta.data.documents[index]["name"]),
                                              SizedBox(height: 5,),
                                              Text("Email : "+dattta.data.documents[index]["email"]),
                                              SizedBox(height: 5,),
                                              Text("Mobile : "+dattta.data.documents[index]["phone"]),
                                            ],
                                          ),

                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            );
                          }) : Center(
                        child: Text("No Users !!!"),
                      )
                    ) : Container();
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            addUser = true;
          });
        },
        tooltip: 'Add User',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
