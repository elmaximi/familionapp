import 'package:familionapp/src/util/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:familionapp/src/bloc/authentication_bloc/bloc.dart';
import 'package:familionapp/src/bloc/simple_bloc_delegate.dart';
import 'package:familionapp/src/repository/user_repository.dart';
import 'package:familionapp/src/ui/home_screen.dart';
import 'package:familionapp/src/ui/login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final UserRepository userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(userRepository: userRepository)
        ..add(AppStarted()),
      child: App(userRepository: userRepository),
    )
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
    : assert (userRepository != null),
      _userRepository = userRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          // if (state is Uninitialized) {
          //   return SplashScreen();
          // }
          if (state is Authenticated) {
            return HomeScreen();
          }
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository,);
          }
          return Container();
        },
      ),
    );
  }
}