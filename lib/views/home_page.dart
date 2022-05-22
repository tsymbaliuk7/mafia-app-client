import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/styles_controller.dart';
import 'package:mafiaclient/views/account_page.dart';
import 'package:mafiaclient/widgets/primary_buttons.dart';

import '../cofig/styles.dart';
import '../controllers/auth_controller.dart';
import '../controllers/rooms_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, this.removedFromRoom = false}) : super(key: key);
  
  final bool removedFromRoom;
  final RoomsController roomsController = Get.put(RoomsController());
  final AuthController authController = Get.find();
  final StylesController styles = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors[styles.styleKey.value],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 25, right: 25, top: 30),
            child: Obx((){
              if(removedFromRoom){
                Get.defaultDialog(
                  title: "Error",
                  backgroundColor: Colors.white,
                  titleStyle: TextStyle(color: mainColors[styles.styleKey.value], fontSize: 18, fontWeight: FontWeight.w600),
                  middleTextStyle: const TextStyle(color: Colors.black),
                  textConfirm: "OK",
                  confirmTextColor: Colors.white,
                  buttonColor: mainColors[styles.styleKey.value],
                  barrierDismissible: true,
                  onConfirm: (){
                    Get.back();
                  },
                  radius: 5,
                  content: const Text('Game is already in progress. Wait for the players to finish current session and join room again')
                );
              }
              if(roomsController.roomStatus.value == Status.success){
                return Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                child: SvgPicture.asset(
                                  'icons/logo_${styles.styleKey.value}.svg',
                                  height: MediaQuery.of(context).size.height / 2,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: PrimaryButton(
                                  buttonHeight: 45,
                                  onTap: (){
                                  roomsController.checkJoiningRoom(isCreating: true);
                                }, 
                                title: 'Create room',),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: SecondaryButton(
                                  buttonHeight: 45,
                                  onTap: (){
                                  bool isMobile = MediaQuery.of(context).size.width <= 900;
                                  var roomIdController = TextEditingController();
                                  var _formKey = GlobalKey<FormState>();
                                  Get.defaultDialog(
                                    title: "Input room id",
                                    backgroundColor: Colors.white,
                                    titleStyle: TextStyle(color: mainColors[styles.styleKey.value], fontSize: 18, fontWeight: FontWeight.w600),
                                    middleTextStyle: const TextStyle(color: Colors.black),
                                    textConfirm: "Confirm",
                                    textCancel: "Cancel",
                                    cancelTextColor: mainColors[styles.styleKey.value],
                                    confirmTextColor: Colors.white,
                                    buttonColor: mainColors[styles.styleKey.value],
                                    barrierDismissible: true,
                                    onConfirm: (){
                                      if (_formKey.currentState!.validate()) {
                                        Get.back();
                                        roomsController.checkJoiningRoom(isCreating: false, room: roomIdController.text);
                                      }
                                    },
                                    radius: 5,
                                    content: Form(
                                      key: _formKey,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      child: SizedBox(
                                        width: isMobile ? MediaQuery.of(context).size.width - 10 : 500,
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 15, top: 10),
                                            child: TextFormField(
                                              validator: (value) {
                                              if (value ==null || value.isEmpty) {
                                                return 'Enter room id';
                                              } else if (value.length < 3) {
                                                return 'Room id should be longer than 3 characters';
                                              }
                                               else if (value.length > 10) {
                                                return 'Room id should have less than 10 characters';
                                              }
                                              return null;
                                            },
                                              controller: roomIdController,
                                              keyboardType: TextInputType.emailAddress,
                                              autocorrect: false,
                                              cursorColor: const Color(0xff181B19),
                                              style: const TextStyle(
                                                color: Color(0xff181B19),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: 'Room ID',
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
                                                  borderRadius: BorderRadius.circular(5.0),
                                                  borderSide: const BorderSide(
                                                    width: 0,
                                                    style: BorderStyle.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],),
                                      )
                                    ),
                                  );
                                }, 
                                title: 'Join room',),
                              ),
                                  
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 25,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            Get.to(() => AccountPage());
                          },
                          splashColor: mainColors[styles.styleKey.value]!.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.account_circle_outlined,
                              size: 25,
                              color: mainColors[styles.styleKey.value],
                            )
                          )
                        ),
                      )
                    )
                  ],
                );
              }
              else{
                return const Center(child: CircularProgressIndicator(),);
              }
            }),
          ) 
        ),
      )
    );
  }
}
