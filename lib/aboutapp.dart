import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0; // Default: 'Regional'

  final List<String> _titles = [
    "AI Image Classifier\n is a powerful and lightweight mobile application that uses Artificial Intelligence (AI) and Machine Learning (ML) to recognize and classify objects in images. Built with Flutter and TensorFlow Lite (TFLite), the app offers fast and accurate image recognition right on your mobile device.", 
    "Key Features",
    "Future Updates",
  ];

  // Data for each category
  final List<List<Map<String, dynamic>>> categories = [
  [
    {"Title": "Upload", "data": "Upload an image using your phone.", "icon": Icons.upload},
    {"Title": "Analyze", "data": "The AI model analyzes the image and predicts the object.", "icon": Icons.analytics},
    {"Title": "Results", "data": "Instantly get results with accuracy scores.", "icon": Icons.assessment},
  ],
  [
    {"Title": "AI-Powered Image Classification", "data": "Instantly identify objects like animals, vehicles, and more.", "icon": Icons.image_search},
    {"Title": "Offline Functionality", "data": "Works without an internet connection.", "icon": Icons.offline_bolt},
    {"Title": "Fast & Lightweight", "data": "Optimized for mobile performance with TFLite.", "icon": Icons.speed},
    {"Title": "User-Friendly Interface", "data": "Simple and intuitive design for easy use.", "icon": Icons.touch_app},
  ],
  [
    {"Title": "Real-time Detection", "data": "Real-time camera detection for instant classification, allowing users to analyze objects live through their phone's camera.", "icon": Icons.camera},
    {"Title": "Expanded Categories", "data": "Object categories, including food, landmarks, and other common items, to make the app more versatile.", "icon": Icons.category},
    {"Title": "Improved AI", "data": "Improved AI model for even higher accuracy, ensuring more reliable and precise image classification results.", "icon": Icons.upgrade},
    {"Title": "Enhanced UI", "data": "Enhanced user interface with new features and customization options for a better user experience.", "icon": Icons.enhanced_encryption},
  ],
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neuro Scan", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
        
        

        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Rate App", style: TextStyle(color: Colors.white)),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      
      body: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color.fromARGB(255, 215, 146, 168)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            SizedBox(height: 20,),
            // Toggle Buttons
            ToggleButtons(
              isSelected: [selectedIndex == 0, selectedIndex == 1, selectedIndex == 2],
              selectedColor: const Color.fromARGB(255, 255, 255, 255),
              fillColor: const Color.fromARGB(255, 0, 0, 0),
              borderRadius: BorderRadius.circular(10),
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("About")),
                Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Features")),
                Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Updates")),
              ],
              onPressed: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            SizedBox(height: 20),

            // Heading Text
             Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                _titles[selectedIndex],
                // textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 20),

            // Dynamic Title List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: categories[selectedIndex].map((item) {
                  return _dataCard(item["Title"]!, item["data"]!, item["icon"]!);
                }).toList(),
              ),
            ),
            SizedBox(height: 20),

            // See More Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: const Text("See More", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the Title data card
  Widget _dataCard(String title, String data, IconData icon) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 0, 0, 0)),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(data),
      trailing: CircleAvatar(
        backgroundColor: const Color.fromARGB(187, 0, 0, 0),
        radius: 15,
      ),
    ),
  );
}
}