import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'dart:typed_data';
import 'dart:html' as html; // Add this line to import 'dart:html' with a prefix

import '../../../Services/BlogServices.dart';

class BlogScreen extends StatefulWidget {
  final BlogServices blogServices;

  BlogScreen({BlogServices? blogServices})
      : blogServices = blogServices ?? BlogServices(apiUrl: 'http://localhost:9097/blog');

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  late TextEditingController titreController;
  late TextEditingController descriptionController;
  late TextEditingController lieuController;
  late TextEditingController dateController;
  late TextEditingController prixController;

  late Uint8List uploadedImage;

  @override
  void initState() {
    super.initState();
    titreController = TextEditingController();
    descriptionController = TextEditingController();
    lieuController = TextEditingController();
    dateController = TextEditingController();
    prixController = TextEditingController();
    uploadedImage = Uint8List(0); // Initialize with an empty Uint8List
  }

  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          controller: controller,
        ),
      ],
    );
  }

  Future<void> _startFilePicker() async {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) {
          setState(() {
            uploadedImage = reader.result as Uint8List;
          });
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            print("Error occurred while reading the file");
          });
        });

        reader.readAsArrayBuffer(file!);
      }
    });
  }


  Future<void> _pickImage() async {
    _startFilePicker(); // Use the _startFilePicker method

    // Optionally, you can add logic here to handle the picked image
  }

  Future<Widget> _loadImage() async {
    if (uploadedImage.isNotEmpty) {
      return Image.memory(
        uploadedImage,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        height: 150,
        width: 150,
        color: Colors.grey,
      );
    }
  }

  void _showAddBlogDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Blog'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildEditableField('Title', titreController),
              buildEditableField('Description', descriptionController),
              buildEditableField('Lieu', lieuController),
              ElevatedButton(
                child: Text('Choose File'),
                onPressed: _pickImage,
              ),
              buildEditableField('Date', dateController),
              buildEditableField('Price', prixController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (uploadedImage.isNotEmpty) {
                    await widget.blogServices.createBlog(
                      titre: titreController.text,
                      description: descriptionController.text,
                      lieu: lieuController.text,
                      imageFile: html.File(
                        [uploadedImage],
                        'image.png', // Adjust the file name and type as needed
                        {'type': 'image/png'},
                      ),
                      date: dateController.text,
                      prix: double.tryParse(prixController.text) ?? 0.0,
                    );

                    Navigator.pop(context);
                  } else {
                    print('Please pick an image.');
                  }
                } catch (e) {
                  print('Error adding blog: $e');
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blog Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            FutureBuilder<Widget>(
              future: _loadImage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      snapshot.data ?? Container(),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _showAddBlogDialog,
                        child: Text('Add Blog'),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('Error loading image');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titreController.dispose();
    descriptionController.dispose();
    lieuController.dispose();
    dateController.dispose();
    prixController.dispose();
    super.dispose();
  }
}
