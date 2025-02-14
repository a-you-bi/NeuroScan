// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'dart:io';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late Interpreter _interpreter;
//   File? _selectedImage;
//   String _result = "Pick an image to classify";

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   /// Load TensorFlow Lite model
//   Future<void> loadModel() async {
//     _interpreter = await Interpreter.fromAsset('assets/model.tflite');
//     print("Model loaded successfully!");
//   }

//   /// Pick an image from the gallery
//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

//     if (image == null) return;

//     setState(() {
//       _selectedImage = File(image.path);
//     });

//     classifyImage();
//   }

//   /// Dummy function for classification (Replace with real image processing)
//   void classifyImage() {
//     if (_selectedImage == null) return;

//     // Process image and get classification results
//     // (In a real scenario, convert the image to a format expected by the model)
//     setState(() {
//       _result = "Classified as: Example Label"; // Replace with actual model output
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Image Classifier")),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _selectedImage != null
//                   ? Image.file(_selectedImage!, height: 200)
//                   : Icon(Icons.image, size: 100, color: Colors.grey),
//               SizedBox(height: 20),
//               Text(_result, style: TextStyle(fontSize: 18)),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: pickImage,
//                 child: Text("Pick Image"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image/image.dart' as img;
// import 'package:flutter/services.dart' show rootBundle;

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late Interpreter _interpreter;
//   File? _selectedImage;
//   String _result = "Pick an image to classify";
//   List<String> _labels = [];

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//     loadLabels();
//   }

//   /// Load TensorFlow Lite model
//   // Future<void> loadModel() async {
//   //   _interpreter = await Interpreter.fromAsset('assets/model.tflite');
//   //   print("Model loaded successfully!");
//   // }
//   Future<void> loadModel() async {
//   _interpreter = await Interpreter.fromAsset('assets/model.tflite');

//   var inputShape = _interpreter.getInputTensor(0).shape;
//   var outputShape = _interpreter.getOutputTensor(0).shape;

//   print("✅ Model Loaded");
//   print("📌 Expected Input Shape: $inputShape");
//   print("📌 Expected Output Shape: $outputShape");
// }


//   /// Load labels from assets
//   Future<void> loadLabels() async {
//     String labelsData = await rootBundle.loadString('assets/labels.txt');
//     setState(() {
//       _labels = labelsData.split('\n');
//     });
//   }

//   /// Pick an image from the gallery
//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

//     if (image == null) return;

//     setState(() {
//       _selectedImage = File(image.path);
//     });

//     classifyImage();
//   }

//   /// Preprocess Image (Resize & Normalize)
//   Uint8List preprocessImage(File imageFile) {
//     img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;
//     img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

//     var buffer = Uint8List(224 * 224 * 3);
//     int index = 0;

//     for (int y = 0; y < 224; y++) {
//       for (int x = 0; x < 224; x++) {
//         var pixel = resizedImage.getPixel(x, y);
//         buffer[index++] = pixel.r.toInt();
//         buffer[index++] = pixel.g.toInt();
//         buffer[index++] = pixel.b.toInt();
//       }
//     }

//     return buffer;
//   }

//   /// Classify Image
//   void classifyImage() async {
//     if (_selectedImage == null) return;

//     Uint8List inputImage = preprocessImage(_selectedImage!);

//     var input = inputImage.buffer.asUint8List();
//     var output = List.filled(1 * _labels.length, 0).reshape([1, _labels.length]);

//     _interpreter.run(input, output);

//     int predictedIndex = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));

//     setState(() {
//       _result = "Classified as: ${_labels[predictedIndex]}";
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Image Classifier")),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               _selectedImage != null
//                   ? Image.file(_selectedImage!, height: 200)
//                   : Icon(Icons.image, size: 100, color: Colors.grey),
//               SizedBox(height: 20),
//               Text(_result, style: TextStyle(fontSize: 18)),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: pickImage,
//                 child: Text("Pick Image"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Interpreter _interpreter;
  File? _selectedImage;
  String _result = "Pick an image to classify";
  List<String> _labels = [];

  @override
  void initState() {
    super.initState();
    loadModel();
    loadLabels();
  }

  /// Load TensorFlow Lite model
  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');

    var inputShape = _interpreter.getInputTensor(0).shape;
    var outputShape = _interpreter.getOutputTensor(0).shape;

    print("✅ Model Loaded");
    print("📌 Expected Input Shape: $inputShape");
    print("📌 Expected Output Shape: $outputShape");
  }

  /// Load labels from assets
  Future<void> loadLabels() async {
    String labelsData = await rootBundle.loadString('assets/labels.txt');
    setState(() {
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
    });
    print("📌 Labels Loaded: ${_labels.length}");
  }

  /// Pick an image from the gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });

    classifyImage();
  }

  /// Preprocess Image (Resize, Normalize, Convert to Float32)
  List<List<List<List<double>>>> preprocessImage(File imageFile) {
    img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    List<List<List<List<double>>>> buffer = List.generate(1, (_) =>
        List.generate(224, (_) =>
            List.generate(224, (_) =>
                List.generate(3, (_) => 0.0))));

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        var pixel = resizedImage.getPixel(x, y);
        buffer[0][y][x][0] = pixel.r / 255.0; // Normalize
        buffer[0][y][x][1] = pixel.g / 255.0;
        buffer[0][y][x][2] = pixel.b / 255.0;
      }
    }
    return buffer;
  }

  /// Classify Image
  void classifyImage() async {
    if (_selectedImage == null) return;

    var inputImage = preprocessImage(_selectedImage!);
    var output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter.run(inputImage, output);

    int predictedIndex = output[0].indexWhere((val) => val == output[0].reduce((a, b) => a > b ? a : b));

    setState(() {
      _result = "Classified as: ${_labels[predictedIndex]}";
    });

    print("🔍 Classification Output: ${output[0]}");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Image Classifier")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 200)
                  : Icon(Icons.image, size: 100, color: Colors.grey),
              SizedBox(height: 20),
              Text(_result, style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Pick Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

