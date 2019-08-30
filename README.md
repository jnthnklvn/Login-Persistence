# Login Persistence

An example of Login with BLoC using SharedPreferences to persit and Slidy to structure the project.

![](20190830_144445.gif)

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

## How I'm doing this?

Using BLoC Pattern when the app starts the AppBloc starts with him. And here's the key, every logic we need to do before render the first page we can do using AppBloc.

At the AppBloc is every logical code to manage the SharedPreferences.

We start defining a controller for de user. We also define de sink(to change the user), stream(to listen the changes) and a get for the user as follow below:
```
  final _userController = BehaviorSubject<UserModel>();

  Sink get inUser => _userController.sink;
  Stream<UserModel> get outUser => _userController.stream;
  UserModel get getUser => _userController.value;
```

The constructor set the fuction to be listen and calls initBloc
```
  AppBloc() {
    _userController.listen(onData);
    initBloc();
  }
```

The onData is called everytime that the user changes to set the user in SharedPreferences
```
  Future onData(UserModel event) async {
    await prefs.setString('user', getUser?.toString());
  }
```

The initBloc gets the instance of SharedPreferences and try to recover some user from there. If the user isn't null, the user value is set in AppBloc.
```
  Future initBloc() async {
    prefs = await SharedPreferences.getInstance();
    var userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> decoded = jsonDecode(userJson);
      _userController.value = UserModel.fromJson(decoded);
    }
  }
```

### Packages in this project

- Slidy and BLoC
https://github.com/Flutterando/slidy

- SharedPreferences
https://pub.dev/packages/shared_preferences

### API

- ReqRes
https://reqres.in/
