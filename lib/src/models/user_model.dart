class UserModel {
  String _username;
  String _password;

  UserModel(this._username, this._password);

  UserModel.fromJson(Map<String, dynamic> json)
      : _username = json['username'],
        _password = json['password'];

  String get username => _username;
  set setUsername(String username) => _username = username;

  String get password => _password;
  set setPassword(String password) => _password = password;

  Map<String, Object> toJson() {
    return {
      "username": _username,
      "password": _password,
    };
  }

  @override
  String toString() {
    return '{"username": "$_username", "password": "$_password"}';
  }
}
