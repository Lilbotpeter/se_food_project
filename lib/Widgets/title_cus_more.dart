import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Screen/Profile/my_food.dart';
import '../constants.dart';

class TitleCustomWithMore extends StatelessWidget {
  const TitleCustomWithMore({
    super.key, required this.text,
  });

  final String text;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          TitleCustim(text: text),
          Spacer(),//ตัวคั่นกลาง
          InkWell(
                  onTap: (){
                    //move user to login paage
                    Get.to(MyFoods());
                  },
                  child: const Text(
                    " +เพิ่มเติม",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class TitleCustim extends StatelessWidget {
  const TitleCustim({
    super.key, required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Stack(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child:Container(
            margin: EdgeInsets.only(right: kDefaultPadding/4),
          height: 7,
          color: kPrimaryColor.withOpacity(0.1),
          
        ),
        )
        ],
      ),
      );
  }
}