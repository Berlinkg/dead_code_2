import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImagePickerPage(),
    );
  }
}

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  List<ImageData> imageList = [];

  Future<void> _captureImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imageList.add(ImageData(
          imageFile: File(image.path),
          description: '',
          phoneNumber: '',
        ));
      });
    }
  }

  Future<void> _selectImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imageList.add(ImageData(
          imageFile: File(image.path),
          description: '',
          phoneNumber: '',
        ));
      });
    }
  }

  Future<void> _fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.example.com/data'));
      if (response.statusCode == 200) {
        final dataList = response.body.split('\n');
        setState(() {
          imageList = dataList
              .map((data) => ImageData(
                    imageFile: null,
                    description: data,
                    phoneNumber: '',
                  ))
              .toList();
        });
      } else {
        log('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('Error: $error');
    }
  }

  Future<void> _showImagePickerDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Capture from Camera'),
              onTap: () {
                Navigator.pop(context);
                _captureImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Select from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _selectImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateDescription(int index, String description) {
    setState(() {
      imageList[index].description = description;
    });
  }

  void _updatePhoneNumber(int index, String phoneNumber) {
    setState(() {
      imageList[index].phoneNumber = phoneNumber;
    });
  }

  void _deleteImage(int index) {
    setState(() {
      imageList.removeAt(index);
    });
  }

  void _navigateToDisplayDataPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisplayDataPage(imageList: imageList),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: imageList.length,
              itemBuilder: (context, index) {
                final imageData = imageList[index];
                return ListTile(
                  leading: imageData.imageFile != null
                      ? Image.file(imageData.imageFile!)
                      : Container(),
                  title: TextField(
                    onChanged: (value) => _updateDescription(index, value),
                    decoration: const InputDecoration(
                      labelText: 'Image Description',
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (value) => _updatePhoneNumber(index, value),
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Description: ${imageData.description}'),
                      Text('Phone Number: ${imageData.phoneNumber}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteImage(index),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _showImagePickerDialog(context),
            child: const Text('Pick Image'),
          ),
          ElevatedButton(
            onPressed: () => _fetchData(),
            child: const Text('Fetch Data'),
          ),
          ElevatedButton(
            onPressed: _navigateToDisplayDataPage,
            child: const Text('Next Page'),
          ),
        ],
      ),
    );
  }
}

class ImageData {
  final File? imageFile;
  String description;
  String phoneNumber;

  ImageData({
    this.imageFile,
    required this.description,
    required this.phoneNumber,
  });
}

class DisplayDataPage extends StatelessWidget {
  final List<ImageData> imageList;

  DisplayDataPage({required this.imageList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Data'),
      ),
      body: ListView.builder(
        itemCount: imageList.length,
        itemBuilder: (context, index) {
          final imageData = imageList[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: imageData.imageFile != null
                  ? Image.file(imageData.imageFile!)
                  : Container(),
              title: Text('Description: ${imageData.description}'),
              subtitle: Text('Phone Number: ${imageData.phoneNumber}'),
            ),
          );
        },
      ),
    );
  }
}



// import 'dart:developer';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: ImagePickerPage(),
//     );
//   }
// }

// class ImagePickerPage extends StatefulWidget {
//   const ImagePickerPage({Key? key}) : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _ImagePickerPageState createState() => _ImagePickerPageState();
// }

// class _ImagePickerPageState extends State<ImagePickerPage> {
//   List<ImageData> imageList = [];

//   Future<void> _captureImageFromCamera() async {
//     final image = await ImagePicker().pickImage(source: ImageSource.camera);
//     if (image != null) {
//       setState(() {
//         imageList.add(ImageData(
//           imageFile: File(image.path),
//           description: '',
//         ));
//       });
//     }
//   }

//   Future<void> _selectImageFromGallery() async {
//     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() {
//         imageList.add(ImageData(
//           imageFile: File(image.path),
//           description: '',
//         ));
//       });
//     }
//   }

//   Future<void> _fetchData() async {
//     try {
//       final response =
//           await http.get(Uri.parse('https://api.example.com/data'));
//       if (response.statusCode == 200) {
//         final dataList = response.body.split('\n');
//         setState(() {
//           imageList = dataList
//               .map((data) => ImageData(
//                     imageFile: null,
//                     description: data,
//                   ))
//               .toList();
//         });
//       } else {
//         log('Request failed with status: ${response.statusCode}');
//       }
//     } catch (error) {
//       debugPrint('Error: $error');
//     }
//   }

//   Future<void> _showImagePickerDialog(BuildContext context) async {
//     return showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Pick Image'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt),
//               title: const Text('Capture from Camera'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _captureImageFromCamera();
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library),
//               title: const Text('Select from Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _selectImageFromGallery();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _updateDescription(int index, String description) {
//     setState(() {
//       imageList[index].description = description;
//     });
//   }

//   void _deleteImage(int index) {
//     setState(() {
//       imageList.removeAt(index);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Picker'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: imageList.length,
//               itemBuilder: (context, index) {
//                 final imageData = imageList[index];
//                 return ListTile(
//                   leading: imageData.imageFile != null
//                       ? Image.file(imageData.imageFile!)
//                       : Container(),
//                   title: TextField(
//                     onChanged: (value) => _updateDescription(index, value),
//                     decoration: const InputDecoration(
//                       labelText: 'Image Description',
//                     ),
//                   ),
//                   subtitle: Text('Description: ${imageData.description}'),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => _deleteImage(index),
//                   ),
//                 );
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => _showImagePickerDialog(context),
//             child: const Text('Pick Image'),
//           ),
//           // ElevatedButton(
//           //   onPressed: () => _fetchData(),
//           //   child: const Text('Fetch Data'),
//           // ),
//         ],
//       ),
//     );
//   }
// }

// class ImageData {
//   final File? imageFile;
//   String description;

//   ImageData({
//     this.imageFile,
//     required this.description,
//   });
// }
