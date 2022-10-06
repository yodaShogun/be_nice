import 'package:be_nice/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/query.dart';
import 'Home.dart';

class Login extends StatefulWidget{
  const Login({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Login> createState()=> LoginState();
}

class LoginState extends State<Login> {
  final keyLogin = GlobalKey<FormState>();
  final loginStyle = const TextStyle(fontSize: 20, fontStyle: FontStyle.italic);
  late bool session;

  TextEditingController mailControl = TextEditingController();
  TextEditingController authControl = TextEditingController();

  final StorageService storage = StorageService();

  @override
  void initState() {
    super.initState();
    session = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Container(
          height: double.infinity,
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
          alignment: Alignment.center,
          child:Form(
              key: keyLogin,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  loginField(mailControl, hint: "Enter:{mor_2314}", hide: false),
                  const SizedBox(
                    height: 8,
                  ),
                  loginField(authControl, hint: "Enter:{83r5^_}", hide: true),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Checkbox(value: session,
                        onChanged: (value) {
                          if(value!=null){
                            setState(() {
                                session = value;
                            });
                          }
                      },
                      activeColor: Colors.indigo,
                      ),
                      const Text("Remember Me")
                    ],
                  ),
                  const SizedBox(height: 15,),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if(keyLogin.currentState!.validate()){
                          Map<String,String> input = {"username": mailControl.text, "password": authControl.text};
                          log(input);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Invalid information")
                              )
                          );
                        }
                      },
                      child: Text("Login",style:GoogleFonts.robotoCondensed(textStyle:loginStyle),),
                    ),
                  )
                ],
          )
      )
      )
    );
  }

  void log(Map<String,String>data) async {

    var logQuery = await Query.auth(data);

    if(logQuery!=null && logQuery['token']!=null){

      storage.write("isGuest", logQuery['token']);

      Navigator.push(context, MaterialPageRoute(
        builder: (context)=>const Home(title: 'Home',)
      ));

    }else{

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Connection failed \n incorrect data")
          )
      );

    }
  }

}

TextFormField loginField(fieldControl,{required String hint, required bool hide}){
  return TextFormField(
    controller: fieldControl,
    style: const TextStyle(
      fontSize: 14,
      fontFamily: 'italic',
      color: Colors.black87
    ),
    decoration: InputDecoration(
      hintText: hint,
        focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(color: Colors.blue)),
        filled: true,
    ),
    obscureText: hide,
      validator: (value){
        if(value ==  null  || value.isEmpty){
          return 'Empty field';
        }
        return null;
      }
  );
}


