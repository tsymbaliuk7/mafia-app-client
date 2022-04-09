import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/rooms_controller.dart';
import '../widgets/logout_button.dart';
import '../widgets/primary_buttons.dart';



class AccountPage extends StatefulWidget {
  AccountPage({
    Key? key,
  }) : super(key: key);

  final AuthController authController = Get.find();

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool isMutedAudio;
  late bool isMutedVideo;

  @override
  void initState() {
    usernameController.text = widget.authController.user.value.username;
    isMutedAudio = widget.authController.user.value.isMutedAudio;
    isMutedVideo = widget.authController.user.value.isMutedVideo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width <= 900;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: const Color.fromARGB(255, 138, 189, 230),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: const BorderRadius.all(Radius.circular(25))
                    ),
                    width: isMobile ? MediaQuery.of(context).size.width : 500,
                    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                    margin: EdgeInsets.symmetric(horizontal: isMobile ? 25 : 0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 35),
                          child: Text(
                            'My Account',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 55, 55, 55),
                            ),
                          ),
                        ),
    
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
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
                                  keyboardType: TextInputType.emailAddress,
                                  autocorrect: false,
                                  cursorColor: const Color(0xff181B19),
                                  style: const TextStyle(
                                    color: Color(0xff181B19),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Username',
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
                              
                              Obx((){
                                if (widget.authController.updateUserStatus.value == Status.failure 
                                  && widget.authController.errorMessage.value.isNotEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(widget.authController.errorMessage.value,
                                        style: const TextStyle(color: Colors.red, fontSize: 12)),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Mute audio on connect',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xFF6957FE),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: isMutedAudio,
                                      activeColor: const Color(0xFF6957FE),
                                      onChanged: (value) {
                                        setState(() {
                                          isMutedAudio = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Mute video on connect',
                                      style: TextStyle(
                                        color: Color(0xFF6957FE),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: isMutedVideo,
                                      activeColor: const Color(0xFF6957FE),
                                      onChanged: (value) {
                                        setState(() {
                                          isMutedVideo = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 35, bottom: 25),
                                child: PrimaryButton(
                                  buttonHeight: 42,
                                  title: 'confirm',
                                  onTap: () {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      widget.authController.updateUser(usernameController.text, isMutedAudio, isMutedVideo);
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: LogoutButton(
                                  buttonHeight: 42,
                                  onTap: () {
                                    widget.authController.logout();
                                  },
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
            ),
            Positioned(
              top: 30,
              left: 20,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  splashColor: const Color(0xFF6957FE).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 25,
                      color:Color(0xFF6957FE),
                    )
                  )
                ),
              )
            )
          ],
        )
      ),
    );
  }
}
