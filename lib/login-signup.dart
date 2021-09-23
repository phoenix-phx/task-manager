import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasks/management.dart';
import 'package:tasks/servers/User.dart';
import 'servers/task server.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _error1, _error2;
  bool _secureText = true;
  Future<bool> _reject;

  TextEditingController _userCtrl = TextEditingController();
  TextEditingController _passCtrl = TextEditingController();
  var _userFormKey = GlobalKey<FormState>();
  var _passFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber[700], Colors.amber[500]],
              begin: Alignment.topLeft,
              end: Alignment.centerRight
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 45.0, horizontal: 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back!', style: TextStyle(
                        color: Colors.white,
                        fontSize: 42.0,
                        fontWeight: FontWeight.w800,
                      )),
                      SizedBox(height: 10,),
                      Text('Login and continue creating your tasks', style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300
                      )),
                    ],
                  ),
                )
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: _reject,
                          builder: (context, snapshot){
                            if(snapshot.hasData){
                              bool msg = snapshot.data;
                              if(msg == false){
                                return Column(
                                  children: [
                                    Text('Invalid credentials, try again', style: TextStyle(color: Colors.red),),
                                    SizedBox(height: 30,)
                                  ],
                                );
                              }
                              else{
                                return SizedBox(height: 0,);
                              }
                            }
                            return SizedBox(height: 0,);
                          },
                        ),
                        Form(
                          key: _userFormKey,
                          child: TextField(
                            controller: _userCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "User",
                              suffixIcon: Icon(Icons.account_circle,),
                              errorText: _error1,
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Form(
                          key: _passFormKey,
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(_secureText ? Icons.remove_red_eye : Icons.lock,),
                                onPressed: (){
                                  setState(() {
                                    _secureText = !_secureText;
                                  });
                                }
                              ),
                              errorText: _error2
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _secureText,
                            controller: _passCtrl,
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              User currentUser;
                              setState(() {
                                if(_userCtrl.text.length == 0) {
                                  _error1 = "Enter your username";
                                  return;
                                }
                                if(_passCtrl.text.length == 0){
                                  _error2 = "Enter your password";
                                  return;
                                }
                                _error1 = _error2 = null;
                                print("Todo nice");
                                currentUser = new User(0, _userCtrl.text, _passCtrl.text);
                                _reject = Provider.of<TaskServer>(context, listen: false).login(currentUser, context);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 18.0),
                              child: Text('Login', style: TextStyle(color: Colors.white),),
                            )
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Container(
                          child: FlatButton(
                              onPressed: (){

                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18.0),
                                child: Text('Not registered yet? Sign up!', style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget popup(int id){
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        PopupMenuItem(child: Text("Check"), value: 0,),
        PopupMenuItem(child: Text("Edit"), value: 1,),
        PopupMenuItem(child: Text("Delete"), value: 2,),
      ],
      onSelected: (value){
        setState(() {
          switch(value){
            case 0:
              print("Check $id");
              Provider.of<TaskServer>(context, listen: false).editStatus(id, false);
              break;
            case 1:
              print("Edit $id");
              Route route = MaterialPageRoute(builder: (context) => ManageTask(id));
              Navigator.push(context, route);
              break;
            case 2:
              print("Delete $id");
              Provider.of<TaskServer>(context, listen: false).deleteTask(id);
              break;
          }
        });
      },
    );
  }

  Widget reset(int id){
    return IconButton(
        icon: Icon(Icons.autorenew),
        onPressed: (){
          Provider.of<TaskServer>(context, listen: false).editStatus(id, true);
        }
    );
  }
}
