import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

import 'package:login_persistence/src/models/user_model.dart';

class AppBloc extends BlocBase {
  final _userController = BehaviorSubject<UserModel>();

  Sink get inUser => _userController.sink;
  Stream<UserModel> get outUser => _userController.stream;
  UserModel get getUser => _userController.value;

  SharedPreferences prefs;

  AppBloc() {
    _userController.listen(onData);
    initBloc();
  }

  Future onData(UserModel event) async {
    await prefs.setString('user', getUser?.toString());
  }

  Future initBloc() async {
    prefs = await SharedPreferences.getInstance();
    var userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> decoded = jsonDecode(userJson);
      _userController.value = UserModel.fromJson(decoded);
    }
  }

  @override
  void dispose() {
    _userController.close();
    super.dispose();
  }
}
