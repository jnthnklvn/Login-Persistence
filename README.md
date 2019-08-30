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

Now from the LoginPage we can call to AppBloc and see if there's an user logged. 

In the build we get the AppBloc and the LoginBloc(this one is for doing login stuff). We also take the width of the current screen but it doesn't matters.
```
  Widget build(BuildContext context) {
    final _bloc = LoginModule.to.getBloc<LoginBloc>();
    final _appBloc = AppModule.to.getBloc<AppBloc>();
    final _screenWidth = MediaQuery.of(context).size.width;
```

At the Scaffold's body we have a StreamBuilder which will listen to the changes in the user at AppBloc
```
body: Material(
  child: StreamBuilder<Object>(
  stream: _appBloc.outUser,
  builder: (context, snapshot) {
```

We also have a Column with the content to display. We always will show the logo as the first element after we make a condition, if the snapshot (from the user's stream) doesn't have data we show the fields and button to login, otherwise we show the "login again" and leave buttons.

```
child: Column(
 children: <Widget>[
  Container(
   margin: EdgeInsets.all(20),
   child: Image.asset('assets/sample_logo.png'),
   ),
   if (!snapshot.hasData) ...[
    Container(margin: EdgeInsets.only(top: 10)),
    usernameField(_bloc),
    Container(margin: EdgeInsets.only(top: 10)),
    passwordField(_bloc),
    Container(margin: EdgeInsets.only(top: 15)),
    submitButton(_bloc, context),
    ] else ...[
     entrarNovButton(context),
     sairButton(context, _appBloc)
    ]
   ],
```

The login button calls login at the LoginBloc. The login at LoginBloc request the login from the repository. If the request was successful, it add the user to AppBloc using the sink that we define in AppBloc.
```
  Future<String> login(String username, String password) async {
    _controllerLoading.add(true);
    try {
      _userCorrente = UserModel(username + '@reqres.in', password);
      var token = await _repo.login(_userCorrente);
      if (token != null) {
        _appBloc.inUser.add(_userCorrente);
      }
    } catch (e) {
      _controllerLoading.add(false);
      if (e.message.contains('Connection')) {
        return "Server connection failed.";
      } else {
        return "Username and password didn't match.";
      }
    }
    _controllerLoading.add(false);
    return "true";
  }
```

At the leave button we add null to the sink of user from AppBloc. This makes the login fields and button appear again.
```
onPressed: () => bloc.inUser.add(null),
```

### Packages in this project

- Slidy and BLoC
https://github.com/Flutterando/slidy

- SharedPreferences
https://pub.dev/packages/shared_preferences

### API

- ReqRes
https://reqres.in/
