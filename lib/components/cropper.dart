import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_editor/image_editor.dart' as image_editor;
import 'package:image_picker/image_picker.dart';
import 'package:otaku_movie/components/space.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/log/index.dart';

class Cropper extends StatefulWidget {
  final Widget child;
  final void Function(Uint8List file)? onCropSuccess;
  const Cropper({super.key, required this.child, this.onCropSuccess});

  @override
  _CropperPageState createState() => _CropperPageState();
}

class _CropperPageState extends State<Cropper> {
  File? _image; // 存储选中的图片
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();
  final ImageEditorController _editorController = ImageEditorController();
  final ImagePicker picker = ImagePicker();

  /// 打开相册选择图片
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _showCropperDialog(); // 显示裁剪对话框
    }
  }

    /// 获取裁剪后的结果
  Future<void> _cropImage() async {
    final ExtendedImageEditorState? state = editorKey.currentState;
    if (state == null) return;

    final Rect? cropRect = state.getCropRect();
    if (cropRect == null) return;

  final image_editor.ImageEditorOption option = image_editor.ImageEditorOption();
  option.addOption(image_editor.ClipOption.fromRect(cropRect));

  try {
    final Uint8List? result = await image_editor.ImageEditor.editImage(
      image: state.rawImageData,
      imageEditorOption: option,
    );

    if (result != null && widget.onCropSuccess != null) {
      widget.onCropSuccess!(result);
    }
  } catch (e) {
    log.e('Error cropping image: $e');
  }
      
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  /// 显示裁剪对话框
  Future<void> _showCropperDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text(S.of(context).common_components_cropper_title, style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.black,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 关闭对话框
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      _cropImage();
                      Navigator.of(context).pop(); // 关闭对话框
                    },
                    icon: const Icon(Icons.check, color: Colors.white),
                  ),
                ],
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.black, // 状态栏颜色
                  statusBarIconBrightness: Brightness.light, // 状态栏图标颜色
                ),
              ),
              Expanded(
                child: ExtendedImage.file(
                  _image!,
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
                      controller: _editorController,
                    );
                  },
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                  // height: 130.h,
                  // alignment: Alignment.center,
                  child: Space(
                    right: 20.w,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildToolButton(
                        icon: Icons.rotate_left,
                        onPressed: () {
                          editorKey.currentState?.rotate(degree: 15);
                        },
                        label: S.of(context).common_components_cropper_actions_rotateLeft,
                      ),
                      _buildToolButton(
                        icon: Icons.rotate_right,
                        onPressed: () {
                          editorKey.currentState?.rotate(degree: -15);
                        },
                        label: S.of(context).common_components_cropper_actions_rotateRight,
                      ),
                      _buildToolButton(
                        icon: Icons.flip,
                        onPressed: () {
                          editorKey.currentState?.flip();
                        },
                        label: S.of(context).common_components_cropper_actions_flip,
                      ),
                      _buildToolButton(
                        icon: Icons.undo,
                        onPressed: () {
                          editorKey.currentState?.undo();
                        },
                        label: S.of(context).common_components_cropper_actions_undo,
                      ),
                      _buildToolButton(
                        icon: Icons.redo,
                        onPressed: () {
                          editorKey.currentState?.redo();
                        },
                        label: S.of(context).common_components_cropper_actions_redo,
                      ),
                      _buildToolButton(
                        icon: Icons.restore,
                        onPressed: () {
                          editorKey.currentState?.reset();
                        },
                        label: S.of(context).common_components_cropper_actions_reset,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建工具按钮
  Widget _buildToolButton({required IconData icon, required VoidCallback onPressed, required String label}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // 状态栏颜色
        statusBarIconBrightness: Brightness.light, // 白色图标
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GestureDetector(
          onTap: _pickImageFromGallery,
          child: widget.child,
        )
      ),
    );
  }
}
