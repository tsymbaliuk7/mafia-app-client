import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mafiaclient/controllers/rooms_controller.dart';
import 'package:mafiaclient/controllers/webrtc_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/video_view.dart';



class RoomPage extends StatefulWidget{

  RoomPage({Key? key, required this.id}) : super(key: key);

  final String id;
  final WebRTCController webrtcController = Get.put(WebRTCController());

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {

  late FToast fToast;

  @override
  void initState() {
    widget.webrtcController.startCapturing(widget.id);
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }


  @override
  void dispose() {
    widget.webrtcController.leaveRoom();
    super.dispose();
  }


_showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: const Color.fromARGB(255, 237, 237, 237),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
            Text("Copied to clipboard"),
        ],
      ),
    );


    fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 1),
    );
    
}

  

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                child: Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                        int count = constraints.maxWidth >= 900 ? 4 : 2;
                        return Obx(() {
                            if(widget.webrtcController.status.value == Status.success){
                              var itemList = widget
                                  .webrtcController
                                  .webrtcClients
                                  .keys
                                  .where((element) => widget
                                    .webrtcController
                                    .webrtcClients[element]
                                    !.isReadyToDisplay.value 
                                    && 
                                    widget
                                    .webrtcController
                                    .webrtcClients[element]
                                    ?.user != null)
                                  .toList();
                              return GridView.builder(
                                itemCount: itemList.length,
                                gridDelegate: 
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: count,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 1.2
                                  ),
                                itemBuilder: (context, index){
                                  return VideoView(peer: itemList[index],);
                                }
                              );
                            }
                            else if(widget.webrtcController.status.value == Status.failure){
                              return const Center(child: Text('Ooops\nCammera access denied', textAlign: TextAlign.center,),);
                            }
                            else{
                              return const Center(child: CircularProgressIndicator(),);
                            }
                          }
                        );
                      },) 
                    )
                  ],
                ),
              ),
              Obx(() {
                if(widget.webrtcController.status.value == Status.success){
                  return Positioned(
                    top: 0,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: widget.webrtcController.room));
                                  _showToast();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(widget.webrtcController.room),
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                else{
                  return Container();
                }
              }),
              
              
              Obx(() {
                if(widget.webrtcController.status.value == Status.success){
                  return Positioned(
                    bottom: 0,
                    left: 0,
                    child: BottomNavBar(),
                  );
                }
                else{
                  return Container();
                }
              })

            ]
          ),
        ),
      )

    );
  }
}