import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_helper/pages/settings_page.dart';
import 'package:study_helper/utils/custom_text_styles.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: customTextStyle(),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.gear,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome back to StudyHelper !',
                textAlign: TextAlign.center,
                style: customTextStyle(
                  size: 30,
                ),
              ),
              SizedBox(height: 60),
              RaisedButton(
                onPressed: () {},
                padding: const EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: Colors.orange,
                elevation: 0,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow[700],
                        Colors.orange,
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(40.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    constraints: const BoxConstraints(
                      minWidth: 88.0,
                      minHeight: 36.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Text(
                        "Continue studying",
                        style: customTextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    height: 200,
                    width: 300,
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}