import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/pallete.dart';

class SignInButton extends StatelessWidget {
  const SignInButton(
      {super.key,
      required this.label,
      required this.iconPath,
      required this.onTapFnc});
  final String label;
  final String iconPath;
  final Function onTapFnc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ElevatedButton.icon(
        onPressed: () {
          onTapFnc();
        },
        icon: Image.asset(
          iconPath,
          width: 34,
        ),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
