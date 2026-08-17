import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BackButton(
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        iconSize: WidgetStatePropertyAll(20),
        backgroundBuilder: (context, states, child) {
          return child = const Icon(Icons.arrow_back_ios_new, size: 20);
        },
        // foregroundBuilder: (context, states, child) {
        //   return child = Icon(Icons.arrow_back_ios_new, size: 20);
        // },
      ),
      onPressed:
          onTap ??
          () async {
            Get.back();
          },
    );
  }
}
