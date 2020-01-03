class UserData {
  int id;
  String userName;
  String password;


  UserData(this.id, this.userName, this.password);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'username': userName,
      'password': password,
    };
    return map;
  }

  UserData.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userName = map['username'];
    password = map['password'];
  }
}