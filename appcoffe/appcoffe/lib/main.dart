import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:appcoffe/loginpage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Login",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
        accentColor: Colors.white70
      ),
    );
  }
}

class MainPage extends StatefulWidget{
  
  @override
  _MainPageState createState() =>_MainPageState();

}


class _MainPageState extends State<MainPage>{
  SharedPreferences sharedPreferences;

  @override 
  void initState(){
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async{
    sharedPreferences= await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token")==null){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> LoginPage()),(Route<dynamic> Route)=>false);
    }
  } 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar (
        title:Text("Login", 
        style: TextStyle(
          color: Colors.white )
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> LoginPage()),(Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
       ),
       body: Center(child: Text("Main Page")),
       drawer: Drawer(),
    );
  }
}