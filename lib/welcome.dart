import 'package:classifier/aboutapp.dart';
import 'package:classifier/classifier.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/UI.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          // Rayon lumineux mauve en haut à gauche (Purple Light Ray Top Left)
          

          // Rayon lumineux mauve en bas sous forme de "lampe"
          // Positioned(
          //   bottom: -40,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     height: 200,
          //     decoration: BoxDecoration(
          //       gradient: RadialGradient(
          //         colors: [
          //           Colors.purple.withOpacity(0.6),
          //           const Color.fromARGB(255, 255, 255, 255),
          //         ],
          //         center: Alignment.bottomCenter,
          //         radius: 2.0,
          //         stops: [0.4, 1],
          //       ),
          //       shape: BoxShape.rectangle,
          //     ),
          //   ),
          // ),


          // Main content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                const Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Neuro Scan',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Detect objects instantly\nusing AI Model',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(174, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
  child: Center(
    child: _controller.value.isInitialized
        ? Container(
            color: const Color.fromARGB(255, 255, 255, 255), // Set background color to white
            child: Transform.scale(
              scale: 1.5, // Adjust the scale factor to zoom in or out
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          )
        : const CircularProgressIndicator(),
  ),
),
                                // Video Player
                // SizedBox(height: 150,),
                // const Expanded(
                //   child: Center(
                //     child:Text(""),
                //   ),
                // ),
                

                // Description
                const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Text(
                    'This app enables users to effortlessly upload or capture images, leveraging an advanced AI model trained with Google Teachable Machine to instantly recognize and identify objects with precision',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 80),
                // Buttons
                Padding(
  padding: const EdgeInsets.only(bottom: 35),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // About App Button
      Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 172, 33, 214),Color(0xFFFC466B)], // Pink to Blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(2, 4), // Shadow effect
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  HomeScreen(),
              )
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "About App",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),

      const SizedBox(width: 20),

      // Skip Button
      Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFC466B), Color.fromARGB(255, 172, 33, 214)], // Pink to Blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(2, 4), // Shadow effect
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  Classifier(),
              )
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Skip All",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  ),
),

              ],
            ),
          ),
                    // Rayon lumineux mauve en haut à gauche
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     width: 200,
          //     height: 200,
          //     decoration: BoxDecoration(
          //       gradient: RadialGradient(
          //         colors: [const Color.fromARGB(255, 235, 34, 34).withOpacity(0.6), const Color.fromARGB(255, 255, 255, 255)],
          //         center: Alignment.topLeft,
          //         radius: 0.8,
          //         stops: [0.5, 1],
          //       ),
          //       shape: BoxShape.rectangle,
          //     ),
          //   ),
          // ),
          // Positioned title and text
        const Positioned(
          top: 50,
          left: 20, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Neuro Scan',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Detect objects instantly\nusing AI Model',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(173, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
