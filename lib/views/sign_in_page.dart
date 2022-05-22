import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/cofig/styles.dart';
import 'package:mafiaclient/controllers/styles_controller.dart';

import '../controllers/auth_controller.dart';
import '../controllers/rooms_controller.dart';
import '../widgets/primary_buttons.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);
  
  final AuthController authController = Get.find();
  final StylesController styles = Get.find();

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  bool showVisibilityIcon = false;


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
          color: backgroundColors[widget.styles.styleKey.value],
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'icons/logo_${widget.styles.styleKey.value}.svg',
                height: 100,
              ),
              Container(
                margin: EdgeInsets.only(top: 20, left: isMobile ? 25 : 0, right: isMobile ? 25 : 0),
                width: isMobile ? MediaQuery.of(context).size.width : 500,
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        'Sign In',
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
                        'Enter your account',
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
                            padding: const EdgeInsets.only(bottom: 10),
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
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
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
                                borderRadius: BorderRadius.circular(10.0),
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
                                  borderRadius: BorderRadius.circular(5.0),
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
                              buttonHeight: 50,
                              title: 'confirm',
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                if (_formKey.currentState!.validate()) {
                                  widget.authController.signIn(emailController.text, passwordController.text);
                                }
                              },
                            ),
                          ),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Don\'t have an account? ',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff6C6C6C),
                                  letterSpacing: 0.7,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: mainColors[widget.styles.styleKey.value],
                                      letterSpacing: 0.7,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        widget.authController.goToSignUp();
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