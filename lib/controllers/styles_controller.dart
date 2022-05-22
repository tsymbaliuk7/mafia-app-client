import 'dart:math';

import 'package:get/get.dart';

class StylesController extends GetxController{
  var styleKey = 'day'.obs;

  var styles = ['day', 'night', 'evening', 'morning'];

  void getRandomStyle(){
    final _random = Random();
    var element = styles[_random.nextInt(styles.length)];
    styleKey(element);
  }

}