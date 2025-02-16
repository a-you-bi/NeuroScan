import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//new packages


import 'package:tflite_flutter/tflite_flutter.dart'; /*This package is used to run TensorFlow Lite (TFLite) models
 in a Flutter application. It enables on-device machine learning (ML)
 without needing an internet connection.*/

import 'package:image/image.dart' as img;/*The image package is used for image processing in Dart. 
It allows you to load, modify, and convert images in memory without depending on platform-specific tools.*/

import 'package:flutter/services.dart' show rootBundle; /*rootBundle is used to load assets (such as text files, images, or other resources) 
that are bundled with your Flutter app.*/

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Interpreter _interpreter; // Stores the TensorFlow Lite model.
  File? _selectedImage;//Holds the picked image file.
  String _result = "Pick an image to classify";//Displays the classification output.
  List<String> _labels = [];//Stores category labels.

  @override
  void initState() { // runs when the widget is first created.
    super.initState();
    loadModel();
    loadLabels();
    //loads the machine-learning model and category labels when the app starts.
  }

  /// Load TensorFlow Lite model
  Future<void> loadModel() async {
    // loads the model.tflite file from assets.
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');

    //These lines retrieve the input and output shape of the model.
    var inputShape = _interpreter.getInputTensor(0).shape;
    var outputShape = _interpreter.getOutputTensor(0).shape;

    //Testing if the model is loaded successfully.
    print("✅ Model Loaded");
    print("📌 Expected Input Shape: $inputShape");
    print("📌 Expected Output Shape: $outputShape");
  }

  /// Load labels from assets
  /// I used Future Function, because this may take a long time to load.
  Future<void> loadLabels() async {
    String labelsData = await rootBundle.loadString('assets/labels.txt');// Reads category labels from labels.txt
    setState(() {
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();//and stores them in _labels
    });

    // For Testing
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
    // The first dimension is the batch size, which is 1 in this case.(Means one image is loaded at a time)
    // The second and third dimensions are the height and width of the image, which are both 224.
    // The fourth dimension is the number of channels in the image, which is 3 (RGB).
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        var pixel = resizedImage.getPixel(x, y);
        buffer[0][y][x][0] = pixel.r / 255.0; // Normalize
        buffer[0][y][x][1] = pixel.g / 255.0;
        buffer[0][y][x][2] = pixel.b / 255.0;
        // This part 3a9datni :) any way, here we Normalized pixel values (0-255 → 0-1) for the model. because 99% (i think) of models doesnt not support or understand this values(0-255)
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
        appBar: AppBar(title: Text("NeuroScan")),
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
                child: Text("Choose an Image"),
              ),
            ],  
          ),
        ),
      ),
    );
  }
}

