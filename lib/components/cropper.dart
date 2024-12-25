import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:path_provider/path_provider.dart';

class Cropper extends StatefulWidget {
  const Cropper({super.key});

  @override
  _CropperPageState createState() => _CropperPageState();
}

class _CropperPageState extends State<Cropper> {
  File? _image; // 存储选中的图片
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();
  final ImageEditorController _editorController = ImageEditorController();
  final ImagePicker picker = ImagePicker();
  
  get io => null;

  /// 打开相册选择图片
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /// 获取裁剪后的结果
  Future<void> _cropImage() async {
    final ExtendedImageEditorState? editor = editorKey.currentState;
    if (editor == null) return;

    print(editor.rawImageData);
    // editorKey.currentState?.getCropRect();
    // _editorController.state.saveCurrentState();
    // ImageEditor.;
    // ExtendedImageProvider.
    final Uint8List result = editor.rawImageData;
    
      final Directory tempDir = await getTemporaryDirectory();
      final File croppedFile = File('${tempDir.path}/cropped_image.png');
      await croppedFile.writeAsBytes(result);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image cropped successfully!')),
      );
  }

  /// 构建裁剪工具按钮
  Widget _buildToolButton({required IconData icon, required VoidCallback onPressed}) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(S.of(context).common_components_cropper_title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _cropImage,
            icon: const Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
      body: _image != null
          ? Column(
              children: [
                Expanded(
                  child: ExtendedImage.file(
                    kIsWeb ? _image as File : io.File(_image!.path), // 确保类型匹配,
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    extendedImageEditorKey: editorKey,
                    cacheRawData: true,
                    initEditorConfigHandler: (state) {
                      return EditorConfig(
                        maxScale: 8.0,
                        cropRectPadding: const EdgeInsets.all(20.0),
                        hitTestSize: 20.0,
                        cropAspectRatio: 1.0, // 默认裁剪比例为 1:1
                        controller: _editorController
                      );
                    },
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:  Container(
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  alignment: Alignment.center,
                  child: Center(
                    child: Space(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      right: 15.w,
                      children: [
                        Space(
                          direction: 'column',
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildToolButton(
                              icon: Icons.rotate_left,
                              onPressed: () {
                                editorKey.currentState?.rotate(degree: 15);
                              }
                            ),
                            Text(
                              S.of(context).common_components_cropper_actions_rotateLeft, 
                              style: const TextStyle(color: Colors.white)
                            ),
                          ]
                        ),
                        Space(
                          direction: 'column',
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildToolButton(
                              icon: Icons.rotate_right,
                              onPressed: () {
                                editorKey.currentState?.rotate(degree: -15);
                              }
                            ),
                            Text(
                              S.of(context).common_components_cropper_actions_rotateRight, 
                              style: const TextStyle(color: Colors.white)
                            ),
                          ]
                        ),
                        Space(
                          direction: 'column',
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildToolButton(
                              icon: Icons.flip,
                              onPressed: () {
                              editorKey.currentState?.flip();
                              }
                            ),
                            Text(
                              S.of(context).common_components_cropper_actions_flip, 
                              style: const TextStyle(color: Colors.white)
                            ),
                          ]
                        ),
                        Space(
                          direction: 'column',
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildToolButton(
                              icon: Icons.undo,
                              onPressed: () {
                                editorKey.currentState?.undo();
                              }
                            ),
                          Text(
                              S.of(context).common_components_cropper_actions_undo, 
                              style: const TextStyle(color: Colors.white)
                            ),
                          ]
                        ),
                        Space(
                          direction: 'column',
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildToolButton(
                              icon: Icons.redo,
                              onPressed: () {
                                editorKey.currentState?.redo();
                              }
                            ),
                            Text(
                              S.of(context).common_components_cropper_actions_redo, 
                              style: const TextStyle(color: Colors.white)
                            ),
                          ]
                        ),
                        Space(
                          direction: 'column',
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildToolButton(
                              icon: Icons.restore,
                              onPressed: () {
                                editorKey.currentState?.reset();
                              }
                            ),
                            Text(
                              S.of(context).common_components_cropper_actions_reset, 
                              style: const TextStyle(color: Colors.white)
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
                ),
                )
              ],
            )
          : Center(
              child: ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: const Text("Pick Image from Gallery"),
              ),
            ),
    );
  }
}
