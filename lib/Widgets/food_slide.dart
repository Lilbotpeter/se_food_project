
import 'package:flutter/material.dart';


import '../constants.dart';


class SlideFoodCard extends StatelessWidget {
  const SlideFoodCard({
    super.key, required this.image, required this.title, required this.owner, required this.rating, required this.press,
  });

  final String image,title,owner;
  final String rating;
  final Function press;



  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
      return InkWell(
        onTap: (){press();},
        child: Container(
          width: 350,
          padding: EdgeInsets.all(90),
          margin: EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
              opacity: 0.7,
            ),
          ),
        // child: Column(
        //   children: [
        //     Container(
        //       alignment: Alignment.topLeft,
        //       child: Text(
        //         '$title',
        //         style: TextStyle(
        //           color: kTextColor,
        //           fontSize: 16,
        //           fontWeight: FontWeight.w600
        //         ),
        //       ),
              
              
        //       )
        //   ]),
        ),
      );
  }
}



//Container(
    //   margin: const EdgeInsets.only(
    //     left: kDefaultPadding,
    //     right: kDefaultPadding,
    //     top: kDefaultPadding/2,
    //     bottom: kDefaultPadding*2.5,
    //   ),
    //   width: size.width*0.4,
    //   child: Column(
    //     children: <Widget>[
    //       //Image Show
    //       //showImage(index),
    //       //Image.asset(image),
    //       Image.network(
    //     image),
    //       GestureDetector(
    //         onTap: press(),
    //         child: Container(
    //           padding: EdgeInsets.all(kDefaultPadding/2),
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: const BorderRadius.only(
    //               bottomLeft: Radius.circular(12),
    //               bottomRight: Radius.circular(12),
    //               ),
    //             boxShadow: [
    //               BoxShadow(
    //                 offset: Offset(0,10),
    //                 blurRadius: 50,
    //                 color: kPrimaryColor.withOpacity(0.17),
    //               ),
    //             ],
    //           ),

    //         ),
    //       )
    //     ],
    //   ),
    // );

              // child: Row(
              //   children: <Widget>[
              //     //Text in box
              //     RichText(
              //       text: TextSpan(
              //         children: [
              //           TextSpan(text: "$title"+"\n",
              //           style: Theme.of(context).textTheme.titleSmall,
              //           ),
              //           TextSpan(
              //             text: "by"+" $owner",
              //             style: TextStyle(
              //               color: kPrimaryColor.withOpacity(0.5),
              //             )
              //           ),
              //         ]
                  
              //   ),
              //   ),
              //   const Spacer(),
              //   Text("$rating",style: Theme.of(context).textTheme.bodySmall!
              //   .copyWith(color: kPrimaryColor),)
              //   ],
              // ),