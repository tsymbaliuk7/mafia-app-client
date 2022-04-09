import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/rooms_controller.dart';
import '../widgets/primary_buttons.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);
  
  final AuthController authController = Get.find();

  @override
  State<SignUpPage> createState() => _SignUpPagePageState();
}

class _SignUpPagePageState extends State<SignUpPage> {

  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  late TextEditingController usernameController = TextEditingController();
  late TextEditingController passwordConfirmController = TextEditingController();

  bool showVisibilityIcon = false;
  bool showConfirmVisibilityIcon = false;


  final _formKey = GlobalKey<FormState>();


  String? validateEmail(String? value) {
    String pattern = r"^[-!#$%&'*+\/0-9=?A-Z^_a-z{|}~](\.?[-!#$%&'*+\/0-9=?A-Z^_a-z`{|}~])*@[a-zA-Z0-9](-*\.?[a-zA-Z0-9])*\.[a-zA-Z](-?[a-zA-Z0-9])+$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Enter valid email';
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 900;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 138, 189, 230),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: isMobile ? MediaQuery.of(context).size.width : 500,
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: isMobile ? 25 : 0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(25))
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Text(
                        'Create new account',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff7C7C7C),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: TextFormField(
                            validator: (value) {
                              if (value ==null || value.isEmpty) {
                                return 'Enter username';
                              } else if (value.length < 3) {
                                return 'Username should be longer than 3 characters';
                              }
                              return null;
                            },
                            controller: usernameController,
                            autocorrect: false,
                            cursorColor: const Color(
                                0xff181B19),
                            style: const TextStyle(
                              color:
                                  Color(0xff181B19),
                              fontWeight:
                                  FontWeight.w500,
                              fontSize: 14,
                            ),
                            decoration:
                                InputDecoration(
                              hintText: 'Username',
                              hintStyle:
                                  const TextStyle(
                                color:
                                    Color(0xFFA5A5A5),
                                fontWeight:
                                    FontWeight.w500,
                                fontSize: 14,
                              ),
                              filled: true,
                              isDense: true,
                              fillColor: const Color(
                                  0xffF2F3F2),
                              contentPadding:
                                const EdgeInsets.only(
                                      top: 30,
                                      left: 20,
                                      right: 20),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            15.0),
                                borderSide:
                                    const BorderSide(
                                  width: 0,
                                  style: BorderStyle
                                      .none,
                                ),
                              ),
                            ),
                          ),
                        ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: TextFormField(
                              validator: (value) => validateEmail(value),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              cursorColor: const Color(0xff181B19),
                              style: const TextStyle(
                                color: Color(0xff181B19),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: const TextStyle(
                                  color: Color(0xFFA5A5A5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                filled: true,
                                isDense: true,
                                fillColor: const Color(0xffF2F3F2),
                                contentPadding: const EdgeInsets.only(top: 30, left: 20, right: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter password';
                                } else if (value.length < 8) {
                                  return 'Password should be longer than 8 characters';
                                }
                                return null;
                              },
                              
                              obscureText: showVisibilityIcon ? false : true,
                              cursorColor: const Color(0xff030303),
                              style: const TextStyle(
                                color: Color(0xff181B19),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                                hintText: 'Password',
                                filled: true,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                hintStyle: const TextStyle(
                                  color: Color(0xFFA5A5A5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                fillColor: const Color(0xffF2F3F2),
                                suffixIcon: SizedBox(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15.0),
                                    onTap: () {
                                      if (!showVisibilityIcon) {
                                        setState(() {
                                          showVisibilityIcon = true;
                                        });
                                      } else {
                                        setState(() {
                                          showVisibilityIcon = false;
                                        });
                                      }
                                    },
                                    child: Icon(
                                      showVisibilityIcon
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xff7C7C7C),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: passwordConfirmController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm password';
                              } else if (value != passwordController.text) {
                                return 'Password values didn\'t match';
                              }
                              return null;
                            },
                            obscureText: showConfirmVisibilityIcon ? false : true,
                            cursorColor:const Color(0xff030303),
                            style: const TextStyle(
                              color: Color(0xff181B19),
                              fontWeight:
                                  FontWeight.w500,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.only(
                                      top: 20,
                                      left: 20,
                                      right: 20),
                              hintText:
                                  'Password Confirm',
                              filled: true,
                              isDense: true,
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(15.0),
                                borderSide:
                                    const BorderSide(
                                  width: 0,
                                  style:
                                      BorderStyle.none,
                                ),
                              ),
                              hintStyle:
                                  const TextStyle(
                                color:
                                    Color(0xFFA5A5A5),
                                fontWeight:
                                    FontWeight.w500,
                                fontSize: 14,
                              ),
                              fillColor: const Color(
                                  0xffF2F3F2),
                              suffixIcon: SizedBox(
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              15.0),
                                  onTap: () {
                                    if (!showConfirmVisibilityIcon) {
                                      setState(() {
                                        showConfirmVisibilityIcon =
                                            true;
                                      });
                                    } else {
                                      setState(() {
                                        showConfirmVisibilityIcon =
                                            false;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    showConfirmVisibilityIcon
                                        ? Icons
                                            .visibility
                                        : Icons
                                            .visibility_off,
                                    color: Color(
                                        0xff7C7C7C),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Obx((){
                            if (widget.authController.status.value == Status.failure 
                              && widget.authController.errorMessage.value.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(widget.authController.errorMessage.value,
                                    style: const TextStyle(color: Colors.red, fontSize: 12)),
                              );
                            } else {
                              return Container();
                            }
                          }),
                          Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 25),
                            child: PrimaryButton(
                              buttonHeight: 42,
                              title: 'confirm',
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  widget.authController.signUp(usernameController.text, emailController.text, passwordController.text);
                                }
                              },
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff6C6C6C),
                                  letterSpacing: 0.7,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign In',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF6957FE),
                                      letterSpacing: 0.7,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        widget.authController.goToSignIn();
                                      },
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}