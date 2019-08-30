import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';

import 'package:login_persistence/src/repositories/user_repository.dart';
import 'login_bloc.dart';
import 'login_page.dart';

class LoginModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => LoginBloc()),
      ];

  @override
  List<Dependency> get dependencies => [
        Dependency((i) => UserRepository()),
      ];

  @override
  Widget get view => LoginPage();

  static Inject get to => Inject<LoginModule>.of();
}
