
import 'package:be_nice/screens/Home.dart';
import 'package:be_nice/screens/Login.dart';
import 'package:be_nice/utils/storage.dart';
import 'package:flutter/material.dart';

String? connected;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final  StorageService systemStorage = StorageService();
  connected = await systemStorage.read("isGuest");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: connected == null || connected!.isEmpty? const Login(title: "Sign In") : const Home(title: 'Home',),
    );
  }

}
