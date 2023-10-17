// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chat_basic/utils/snackbar.dart';

class ImageInput extends StatefulWidget {
  final void Function(File image) onSelectImage;
  final File? initialImage;
  const ImageInput({
    Key? key,
    required this.onSelectImage,
    this.initialImage,
  }) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.initialImage;
  }

  void _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    try {
      final pickedImage = await imagePicker.pickImage(source: source);

      if (pickedImage == null) return;
      final pickedImageFile = File(pickedImage.path);

      setState(() {
        _selectedImage = pickedImageFile;
      });

      widget.onSelectImage(_selectedImage!);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: _selectedImage == null
              ? const AssetImage('assets/person.jpg')
              : FileImage(_selectedImage!) as ImageProvider<Object>?,
          radius: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                _pickImage(ImageSource.gallery);
              },
              icon: Icon(
                Icons.collections,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              icon: Icon(
                Icons.photo_camera,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
