import 'package:flutter/material.dart';
import 'package:google_maps/Constants.dart';
import 'package:google_maps/login_wit_sqlite_database/DBHelperForLogin.dart';
import 'package:google_maps/login_wit_sqlite_database/HomePage.dart';
import 'package:google_maps/sqlite_curd_operations/UserData.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  var userNameConntroller = TextEditingController();
  var passWordConntroller = TextEditingController();
  var formKey = GlobalKey<FormState>();

  DBHelperForLogin dbHelperForLogin;

  Future<List<UserData>> loginList;

  @override
  void initState() {
    dbHelperForLogin = DBHelperForLogin();
    refreshStudentList();
    super.initState();
  }

  refreshStudentList() {
    setState(() {
      loginList = dbHelperForLogin.getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: userNameConntroller,
              validator: (value) {
                if (value.length == 0) {
                  return "Please Enter Username";
                }
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "User Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: passWordConntroller,
              validator: (value) {
                if (value.length == 0) {
                  return "Please Enter Password";
                }
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Password"),
            ),
          ),
          RaisedButton(
            onPressed: () async {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                Constants.progressDialog(true, context);
                bool userNameIsExist = await dbHelperForLogin
                    .isExist(userNameConntroller.text.toString());
                if (!userNameIsExist) {
                  UserData userData = new UserData(
                      null,
                      userNameConntroller.text.toString(),
                      passWordConntroller.text.toString());
                  dbHelperForLogin.add(userData);
                  Constants.progressDialog(false, context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  Constants.progressDialog(false, context);
                  print("User Allready esist");
                }
              }
            },
            child: Text("Login"),
          )
        ],
      ),
    ));
  }
}
