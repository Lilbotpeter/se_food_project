import 'package:flutter/material.dart';

class FeedAppBar extends StatelessWidget {
  const FeedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: (){},
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                color: Colors.black26,
                blurRadius: 6
              ),
              ],
            
            ),
            child: Icon(
              Icons.menu,
              size: 28,
            ),
          ),
        )
      ],
    );
  }
}