import 'package:flutter/material.dart';

Offset globalCenter(GlobalKey key) {
  final box = key.currentContext!.findRenderObject() as RenderBox;

  return box.localToGlobal(box.size.center(Offset.zero));
}
