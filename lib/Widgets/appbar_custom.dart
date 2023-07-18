import 'package:flutter/cupertino.dart';

class AppbarCustom extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    double height = size.height;
    double width = size.width;
    var path = Path();

    path.lineTo(0, height - 10);//height เส้นล่าง
    path.quadraticBezierTo(width/2, height, width, height-10);
    path.lineTo(width, 0);
    path.close();

    return path;

  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper){

    //throw UnimplementedError();
    return true;
  }

}