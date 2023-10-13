import 'package:flutter/material.dart';

//Button With Icon

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClick;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClick,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onClick,
        child: buildContent(),
        style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          minimumSize: const Size.fromHeight(50),
        ),
      );

  Widget buildContent() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28,color: Colors.white,),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 22, color: Colors.white),
          )
        ],
      );
}
