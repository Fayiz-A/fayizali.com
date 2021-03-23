import 'package:flutter/material.dart';

class GoBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height * 0.05,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
          ),
        ),
      ),
    );
  }
}
