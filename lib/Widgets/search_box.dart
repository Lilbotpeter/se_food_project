import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:se_project_food/constants.dart';

class HeadSearch extends StatelessWidget {
  const HeadSearch({
    Key? key,
    required this.size, required this.curuser, required this.image,
    }) : super(key: key);

    final Size size;
    final String curuser,image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultPadding*2.5),
      height: size.height*0.2,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: 36 + kDefaultPadding,
            ),
            height: size.height*0.2-27,
            decoration: BoxDecoration(
              color: Colors.orange,
              gradient: LinearGradient(
                colors:[
                  Color.fromARGB(255, 255, 127, 8),
                  Color.fromARGB(255, 255, 198, 55),],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight, 
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20), 
                ),
            ),
            child: Row(
              children: <Widget>[
                Text("Hi $curuser",style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                ),
                Spacer(),
                Image.asset(image)
              ],
            ),
          ),
          //Search Box
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0,10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ]
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child:
                  TextField(
                    decoration: InputDecoration(
                      hintText: "ค้นหา",
                      hintStyle: TextStyle(color: kPrimaryColor.withOpacity(0.5),
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  ),
                  SvgPicture.asset("images/search-svgrepo-com.svg"),
                ],
              ),
            ),
            ),
        ],
      ),
    );
  }
}