import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
        // Assuming you want to use Material 3, set `useMaterial3` to true
        // useMaterial3: true,
      ),
      home: const MyHomePage(title: 'VoiceLingo'),
    );
  }
}

class MySpeechController extends GetxController {
  // final _speechRecognition = SpeechRecognition();
  // bool _isListening = false;
  // String transcription = '';
  String selectedAudioPath = ''; // Track selected audio path

  Future<void> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      Get.snackbar(
        'Storage Permission',
        'Storage access is required to select audio files. Please grant permission in your device settings.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return; // Handle permission denial gracefully
    }
  }

  Future<void> _pickAudioFile() async {
    await _requestStoragePermission(); // Ensure storage permission
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      final platformFile = result.files.single;
      selectedAudioPath = platformFile.path!;
      update(); // Update UI with selected audio path
    }

    print(selectedAudioPath);
  }

  // ... existing speech recognition and translation logic ...

  Future<void> _translateAndSpeakTamil() async {
    if (selectedAudioPath.isEmpty) {
      Get.snackbar(
        'No Audio Selected',
        'Please select an audio file before translation.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Implement audio processing logic here (e.g., using just_audio or flutter_sound)
    // to extract text from the audio file for translation

    // ... existing translation and text-to-speech logic ...
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final speechController = Get.put(MySpeechController());

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select audio or record:',
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: speechController._pickAudioFile,
                  child: const Text('Select Audio'),
                  style: ElevatedButton.styleFrom(
                      // primary: Colors.teal, // Change button background color
                      // onPrimary: Colors.white, // Change text color
                      ),
                ),
                const SizedBox(width: 20),
                // ElevatedButton(
                //   onPressed: speechController._toggleListening,
                //   child: Obx(() => Text(speechController._isListening
                //       ? 'Stop Recording'
                //       : 'Record Audio')),
                //   style: ElevatedButton.styleFrom(
                //       // primary: Colors.teal, // Change button background color
                //       // onPrimary: Colors.white, // Change text color
                //       ),
                // ),
              ],
            ),
            SizedBox(height: 20),
            if (speechController.selectedAudioPath.isNotEmpty)
              Text(
                'Selected Audio: ${speechController.selectedAudioPath}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),
            // Text(
            //   speechController.transcription,
            //   style: TextStyle(fontSize: 18),
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: speechController._translateAndSpeakTamil,
              child: const Text('Translate to Tamil and Speak'),
              style: ElevatedButton.styleFrom(
                  // primary: Colors.teal, // Change button background color
                  // onPrimary: Colors.white, // Change text color
                  ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
