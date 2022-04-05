import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

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
      return 'Введіть правильну електронну адресу';
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
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
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
                          TextFormField(
                            controller: passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Введіть пароль';
                              } else if (value.length < 8) {
                                return 'Довжина паролю повинна бути не менше 8 символів';
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
                              hintText: 'Пароль',
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