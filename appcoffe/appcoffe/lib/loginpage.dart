import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:appcoffe/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  bool _isLogin=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue,Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        ),
        child: _isLogin ? Center(child: CircularProgressIndicator()): ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            buttonSection()
          ],
        ),
      ),
    );
  }

singIn(String email,pass) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Map data={
    'email': email,
    'password': pass
  };
  var jsonResponse = null;
  var response = await http.post("http://deniv.pythonanywhere.com/admin/", body:data);
  if (response.statusCode==200){
    jsonResponse=json.decode(response.body);
    if(jsonResponse != null){
      setState(() {
        _isLogin=false;
      });
      sharedPreferences.setString("token", jsonResponse['response']['token']);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
    }
  }
  else {
    setState(() {
      _isLogin= false;
    });
    print(response.body);
  }
}

Container buttonSection(){
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 40.0,
    padding: EdgeInsets.symmetric(horizontal: 15.0),
    margin: EdgeInsets.only(top: 15.0),
    child: RaisedButton(
      onPressed: emailController.text =="" || passwordController.text=="" ? null: (){
        setState(() {
          _isLogin=true;
        });
        singIn(emailController.text, passwordController.text);
      },
      elevation: 0.0,
      color: Colors.purple,
      child: Text("Ingresar", style: TextStyle(color: Colors.white70)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
  );
}

final TextEditingController emailController = new TextEditingController();
final TextEditingController passwordController= new TextEditingController();

Container textSection(){
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
    child: Column(
      children: <Widget>[
        TextFormField(
          controller: emailController,
          cursorColor: Colors.white,

          style: TextStyle(color: Colors.white70),
          decoration: InputDecoration(
            icon: Icon(Icons.email,color: Colors.white70),
            hintText: "Usuario",
            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
            hintStyle: TextStyle(color: Colors.white70),           
          ),
        ),
        SizedBox(height: 30.0),
        TextFormField(
          controller: passwordController,
          cursorColor: Colors.white,
          obscureText: true,
          style: TextStyle(color: Colors.white70),
          decoration: InputDecoration(
            icon: Icon(Icons.lock,color: Colors.white70),
            hintText: "Contraseña",
            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    ),
  );
}

Container headerSection(){
  return Container(
    margin: EdgeInsets.only(top: 50.0),
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
    child: Text("Inicio",
    textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 40.0,
        fontWeight: FontWeight.bold)),
    );
  }
}