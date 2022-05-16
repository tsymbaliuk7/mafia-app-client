import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/views/account_page.dart';

import '../cofig/styles.dart';
import '../controllers/auth_controller.dart';
import '../controllers/rooms_controller.dart';
import '../widgets/elipsis_buttons.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key, this.removedFromRoom = false}) : super(key: key);
  
  final bool removedFromRoom;
  final RoomsController roomsController = Get.put(RoomsController());
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 138, 189, 230),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
            child: Obx((){
              if(removedFromRoom){
                Get.defaultDialog(
                  title: "Error",
                  backgroundColor: Colors.white,
                  titleStyle: TextStyle(color: gradientColors[0], fontSize: 18, fontWeight: FontWeight.w600),
                  middleTextStyle: const TextStyle(color: Colors.black),
                  textConfirm: "OK",
                  confirmTextColor: Colors.white,
                  buttonColor: gradientColors[0],
                  barrierDismissible: true,
                  onConfirm: (){
                    Get.back();
                  },
                  radius: 50,
                  content: const Text('Game is already in progress. Wait for the players to finish current session and join room again')
                );
              }
              if(roomsController.roomStatus.value == Status.success){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: (){
                            Get.to(() => AccountPage());
                          }, 
                          icon: const Icon(Icons.account_circle_outlined)
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: ElipsisPrimaryButton(onTap: (){
                        roomsController.checkJoiningRoom(isCreating: true);
                      }, 
                      title: 'Create room',),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElipsisSecondaryButton(onTap: (){
                        bool isMobile = MediaQuery.of(context).size.width <= 900;
                        var roomIdController = TextEditingController();
                        var _formKey = GlobalKey<FormState>();
                        Get.defaultDialog(
                          title: "Input room id",
                          backgroundColor: Colors.white,
                          titleStyle: TextStyle(color: gradientColors[0], fontSize: 18, fontWeight: FontWeight.w600),
                          middleTextStyle: const TextStyle(color: Colors.black),
                          textConfirm: "Confirm",
                          textCancel: "Cancel",
                          cancelTextColor: gradientColors[0],
                          confirmTextColor: Colors.white,
                          buttonColor: gradientColors[0],
                          barrierDismissible: true,
                          onConfirm: (){
                            if (_formKey.currentState!.validate()) {
                              Get.back();
                              roomsController.checkJoiningRoom(isCreating: false, room: roomIdController.text);
                            }
                          },
                          radius: 50,
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
                                        borderRadius: BorderRadius.circular(15.0),
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
