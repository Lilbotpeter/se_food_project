import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailFood extends StatefulWidget {
  const DetailFood({super.key});

  @override
  State<DetailFood> createState() => _DetailFoodState();
}

class _DetailFoodState extends State<DetailFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 125,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset('images/food.jpg',
              fit: BoxFit.cover,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              //child: SvgPicture.asset(""),
            ),
          )
        ]
      ),
    );
  }
}