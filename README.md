 " class UserModel {
  String id;
  String strCustomerProfileImageUrl = "";
  String firstName;
  String lastName;
  String email;
  String phone;
  String password;
  bool isPhone = true;

UserModel(
  {this.id,
  this.strCustomerProfileImageUrl,
  this.firstName,
  this.lastName,
  this.email,
  this.phone,
  this.password});

   UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'].toString();
    firstName = map['first_name'];
    lastName = map['last_name'];
    email = map['email'];
    password = map['Phone_number'];
    strCustomerProfileImageUrl = map['avatar_url'];
  } 

  //   Post Data

    static String addUserInfo(emailId, firstName, lastName, phoneNumber) {
     Map<String, dynamic> map = {
  'emailId': emailId.toString(),
  'firstName': firstName.toString(),
  'lastName': lastName.toString(),
  'phoneNumber': phoneNumber.toString()
   };
return json.encode(map);
}


 //post

 String strJson = UserModel.addUserInfo(
  emailController.text.toString(),
  firstNameController.text.toString(),
  lastNameController.text.toString(),
  widget.phoneNumber.toString(),
);

 Future callApiForRegistration(String strJson) async {
   Map result = await UserRegistrationPassword.userRegistration(
    "${Config.strBaseURL}customers/register", strJson);
if (!result["isError"]) {
  Constants.progressDialog(true, context);
  checkValidation(result);
} else {
  String msg = result["value"];
  Constants.progressDialog(false, context);
  Fluttertoast.showToast(
      msg: Strings.registrationUnsuccessfully,
      toastLength: Toast.LENGTH_SHORT);
}
 }


static Future userRegistration(String url, var strJson) async {
 var client = new http.Client();

Map body = json.decode(strJson);

http.Response response = await client.post(url,
    headers: Config.httpPostHeaderForEncode,
    body: body,
    encoding: Encoding.getByName("utf-8"));

final statusCode = response.statusCode;

try {
  if (statusCode == 200) {
    Map body = json.decode(response.body);
    if (body != null) {
      if (body.containsKey("CustomerId")) {
        var customerId = body['CustomerId'];
        return Constants.resultInApi(customerId, false);
      } else {
        return Constants.resultInApi("body doesn't contain code", true);
      }
    } else {
      return Constants.resultInApi("body is null", true);
    }
  } else {
    return Constants.resultInApi("status code", true);
  }
} catch (e) {
  print(e);
  return {'errorCode': "-1", 'msg': "$e"};
}
}

 static resultInApi(var value,var isError){
 Map<String,dynamic> map = {
  "isError" : isError,
  "value" : value
};
return map;
 }
 
//for list
   List<CategoryModel> categoryList = categories.map((c) => new CategoryModel.parseForHomeScreen(c)).toList();
//for map 
  SearchModelAddress search = new SearchModelAddress.fromMapForLatitudeLongitude(mGeometry);"
