import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class Classifier extends StatefulWidget {
  @override
  _ClassifierState createState() => _ClassifierState();
}

class _ClassifierState extends State<Classifier> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late Interpreter _interpreter;
  File? _selectedImage;
  String _result = "";
  String _WifiNot = "";
  String? _animalInfo = "";

  List<String> _labels = [];
  bool isConnected = false;

  static const String apiKey = 'AIzaSyBb_FWTzNWYrIYoS5uSgBryQicBe2uhxyg';
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro';

  @override
  void initState() {
    super.initState();
    loadModel();
    loadLabels();
    isConnectedToWiFi();
  }

  Future<void> isConnectedToWiFi() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    String connectivityResultStr = connectivityResult.toString();
    print('✅ Connectivity Result ✅ ✅ ✅ ✅ : $connectivityResultStr');

    if (connectivityResultStr == '[ConnectivityResult.wifi]') {
      print('Connected to WiFi');
      setState(() {
        isConnected = true;
      });
    } else {
      print('Not connected to WiFi');
      setState(() {
        isConnected = false;
      });
      _showSnackBar("To enjoy the full experience, please connect to Wi-Fi and try again.");
    }
  }

  Future<String> generateText(String prompt) async {
    final Uri url = Uri.parse('$baseUrl:generateContent?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String rawText = data['candidates'][0]['content']['parts'][0]['text'];
      return rawText.replaceAll('*', '');
    } else {
      print('⚠️ ERROR: ${response.body}');
      throw Exception('❌ Failed to generate text.');
    }
  }

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
    print("✅ Model Loaded");
  }

  Future<void> loadLabels() async {
    String labelsData = await rootBundle.loadString('assets/labels.txt');
    setState(() {
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });

    classifyImage();
  }

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
        buffer[0][y][x][0] = pixel.r / 255.0;
        buffer[0][y][x][1] = pixel.g / 255.0;
        buffer[0][y][x][2] = pixel.b / 255.0;
      }
    }
    return buffer;
  }

  Future<void> classifyImage() async {
    if (_selectedImage == null) return;

    var inputImage = preprocessImage(_selectedImage!);
    var output = List.generate(1, (_) => List.filled(_labels.length, 0.0));

    _interpreter.run(inputImage, output);

    int predictedIndex = output[0].indexWhere((val) => val == output[0].reduce((a, b) => a > b ? a : b));
    String result = _labels[predictedIndex];

    setState(() {
      _result = result;
    });


    if (isConnected) {
      _animalInfo = await generateText("Give me 5 lines of important information about the following animal: [$result]. Include whether it's wild or a pet, its diet (herbivorous, carnivorous, etc.), and any notable traits (e.g., behavior, habitat, etc.).");
    } else {
      _animalInfo = "";
      _WifiNot = "WiFi is required to fetch animal information.";
    }

    setState(() {});
  }
   void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(title: const Text("NeuroScan")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 200)
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(_result, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(_animalInfo ?? 'No information available', style: const TextStyle(fontSize: 14)),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Choose an Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
