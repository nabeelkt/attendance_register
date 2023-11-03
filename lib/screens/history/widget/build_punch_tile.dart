import 'package:attendance_register/core/constants/colors.dart';
import 'package:flutter/material.dart';

class BuildPunchTile extends StatelessWidget {
  const BuildPunchTile({
    super.key,
    required this.data,
  });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      height: 70,
      decoration: const BoxDecoration(
        color: kWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(2, 2),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          data,
          style: const TextStyle(color: kBlack),
        ),
      ),
    );
  }
}
