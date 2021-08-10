import 'package:flutter/material.dart';
class AuthForm extends StatefulWidget {
  final void Function(String email,String username,String password,bool islogin,BuildContext ctx,)submitFn;
  final bool _isloading;

  AuthForm(this.submitFn,this._isloading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey= GlobalKey<FormState>();
  bool _islogin=true;
  String _email='';
  String _username='';
  String _password='';

  void _submit(){
    final isValid= _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if(isValid){
      _formkey.currentState!.save();
      widget.submitFn(
        _email.trim(),_username.trim(),_password.trim(),_islogin,context );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height *0.4,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 40,),
                Text('Baramej',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),

                Form(
                  key: _formkey,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 300),
                    child: Column(
                      children: [
                        SizedBox(height: 15,),
                        TextFormField(
                          key: ValueKey('email'),
                          validator: (val){
                            if(val==null||val.isEmpty || !val.contains('@')){
                              return 'Please enter avalid email address';
                            } return null;
                          },
                          onSaved: (String? val)=>_email =val.toString(),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email'
                          ),
                        ),
                        SizedBox(height: 10,),
                        if(!_islogin)
                          TextFormField(
                            key: ValueKey('username'),
                            validator: (val){
                              if(val==null||val.isEmpty || val.length<4){
                                return 'Please enter at least  4 characters';
                              } return null;
                            },
                            onSaved: (String? val)=>_username =val.toString(),
                            decoration: InputDecoration(
                                labelText: 'username'
                            ),
                          ),
                        SizedBox(height: 10,),
                        TextFormField(
                          key: ValueKey('password'),
                          validator: (val){
                            if(val==null||val.isEmpty || val.length <7){
                              return 'Please enter least character';
                            } return null;
                          },
                          onSaved: (String? val)=>_password =val.toString(),
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'password'
                          ),
                        ),
                        SizedBox(height: 10,),
                        if(widget._isloading)
                          CircularProgressIndicator(),
                        if(!widget._isloading)

                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)
                          ),
                          onPressed: _submit,
                          child: Text(_islogin ?'Login':'Sing Up',style: TextStyle(color: Colors.white,fontSize: 20),),
                          color: Colors.blue,),
                        if(!widget._isloading)
                        FlatButton(onPressed: (){
                          setState(() {
                            _islogin =!_islogin;
                          });
                        }, child: Text(_islogin ? 'Create new account':'I already havean account',style: TextStyle(fontSize: 25),))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
