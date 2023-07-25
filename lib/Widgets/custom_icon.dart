import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({super.key, required this.icon, required this.press});
  final Widget icon;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        shape: BoxShape.circle,

      ),
      child: IconButton(
        constraints: const BoxConstraints.tightFor(width: 40),
        color: Colors.black54,
        onPressed: (){press();}, icon: icon,
        splashRadius: 22,
      ),
    );
  }
}