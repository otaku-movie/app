import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';

class Notfound extends StatelessWidget {
  const Notfound({super.key});

  @override
  Widget build(BuildContext context) {
    // final themeData = Theme.of(context);
    return const Scaffold(
      appBar: CustomAppBar(
        title:  '404'
      ));
  }
}
