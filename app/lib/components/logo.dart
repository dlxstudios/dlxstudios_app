import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DLXLogo extends StatelessWidget {
  final double? height;
  const DLXLogo({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('assets/images/logo.2021.svg',
        height: height,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black);
  }
}
