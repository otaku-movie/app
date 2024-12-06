import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otaku_movie/controller/DictController.dart';
import 'package:otaku_movie/response/dict_response.dart';

class Dict extends StatefulWidget {
  final int? code;
  final String? name;

  const Dict({
    super.key,
    this.code,
    this.name,
  });

  @override
  State<Dict> createState() => _DictState();
}

class _DictState extends State<Dict> {
  final DictController dictController = Get.find(); // 从 GetX 获取 DictController
  late Rx<DictResponse> dict;

  @override
  void initState() {
    super.initState();
    dict = dictController.dict; // 初始化全局变量
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 观察 Rx 数据的变化
      if (widget.name != null && dict.value[widget.name!] != null) {
        List<DictItemResponse> dictList = dict.value[widget.name!]!;
        try {
          DictItemResponse firstWhere = dictList.firstWhere(
            (item) => item.code == widget.code,
            orElse: () => DictItemResponse(name: 'Not Found'), // 提供默认值
          );
          return Text(firstWhere.name ?? '');
        } catch (e) {
          return Text('Error: ${e.toString()}');
        }
      } else {
        return const Text('');
      }
    });
  }
}
