import 'package:flutter/material.dart';


class resetPass extends StatefulWidget {
  const resetPass({super.key});

  @override
  State<resetPass> createState() => resetPassState();
}

class resetPassState extends State<resetPass> {

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text('Reset Password'),
      ),

        body: SafeArea(
          child: SingleChildScrollView(
          child : Form(
          key: formKey,
          child: Padding(
          padding:const EdgeInsets.all(12),
          
          child :Column(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Image.asset(
                'assets/logo.png',
                height: 160,
              ),
              Text('Reset Password',style: TextStyle(fontSize:40,fontWeight:FontWeight.bold)),
              SizedBox(height: 15),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Container(
                decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
                child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                  controller: passwordController,
                  obscureText: !isVisible,
                  validator: (value) {
                  if (value!.isEmpty) {
                  return 'Password is required';
              }
                  return null;
              },          decoration: InputDecoration(
                   icon: Icon(Icons.lock),
                  border: InputBorder.none,
                  hintText: 'Enter your Password',
                    labelText: 'Password',
                    suffixIcon: IconButton(
                     onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
              });
              },
                    icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
              ),
              ),
              ),
              ),
              ),
              ),
              ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                   child: Container(
                    decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
              ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: confirmPasswordController,
                    obscureText: !isVisible,
          
                    validator: (value) {
                    if (value!.isEmpty) {
                     return 'Password is required';
              }
                    else if(passwordController.text !=confirmPasswordController.text){
                    return"password don't match";
              }
                    return null;
              },
                    decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    border: InputBorder.none,
                    hintText: 'Enter your Confirm Password',
                      labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                    isVisible = !isVisible;
              });
              },
                    icon: Icon(
                     isVisible ? Icons.visibility : Icons.visibility_off,
              ),
              ),
              ),
              ),
              ),
              ),
              ),
          
          ]
              ),
              ),),
              ),
        ),
    );
  }
}
