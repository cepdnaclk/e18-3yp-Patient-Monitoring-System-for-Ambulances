class User {
  final String userID;
  final String password;

  User(this.userID, this.password);

  User.fromJson(Map<String, dynamic> json)
      : userID = json['userID'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
    'userID': userID,
    'password': password,
  };



  @override
  String toString() {
    // TODO: implement toString
    return '{userID:$userID, password:$password}';
  }


}