import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'vision_detector_views/barcode_scanner_view.dart';
import 'vision_detector_views/digital_ink_recognizer_view.dart';
import 'vision_detector_views/document_scanner_view.dart';
import 'vision_detector_views/face_detector_view.dart';
import 'vision_detector_views/label_detector_view.dart';
import 'vision_detector_views/object_detector_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LogoWithText(),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12, // Reduced spacing
              mainAxisSpacing: 12, // Reduced spacing
            ),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final feature = _features[index];
              return AnimatedCard(
                label: feature['label']!,
                icon: feature['icon']!,
                viewPage: feature['viewPage']!,
                featureCompleted: feature['featureCompleted'] ?? true,
              );
            },
          ),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}

class LogoWithText extends StatelessWidget {
  const LogoWithText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icon/3.2-02.png',
          height: 60, // Static logo size
        ),
        Text(
          'Hyperscan',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.blueAccent,
                blurRadius: 10,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget viewPage;
  final bool featureCompleted;

  const AnimatedCard({
    required this.label,
    required this.icon,
    required this.viewPage,
    this.featureCompleted = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!featureCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  const Text('This feature has not been implemented yet')));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => viewPage));
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12), // Reduced corner radius
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.5),
              blurRadius: 8, // Reduced blur radius
              offset: Offset(0, 4), // Adjusted shadow offset
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white), // Reduced icon size
              SizedBox(height: 8), // Reduced spacing
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14, // Reduced font size
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> _features = [
  {
    'label': 'Barcode Scanning',
    'icon': Icons.qr_code_scanner,
    'viewPage': BarcodeScannerView(),
  },
  {
    'label': 'Face Detection',
    'icon': Icons.face,
    'viewPage': FaceDetectorView(),
  },
  {
    'label': 'Image Labeling',
    'icon': Icons.image,
    'viewPage': ImageLabelView(),
  },
  {
    'label': 'Object Detection',
    'icon': Icons.category,
    'viewPage': ObjectDetectorView(),
  },
  {
    'label': 'Digital Ink Recognition',
    'icon': Icons.edit,
    'viewPage': DigitalInkView(),
  },
  if (Platform.isAndroid)
    {
      'label': 'Document Scanner',
      'icon': Icons.document_scanner,
      'viewPage': DocumentScannerView(),
    },
];
