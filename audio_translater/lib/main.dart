import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;

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

class AudioController extends GetxController {
  // final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  // final AudioPlayer _audioPlayer = AudioPlayer();
  // RxString audioPath = ''.obs;
  // Uint8List? recordedAudio;
  // // StreamSink<Food>? audioStreamController =
  // //   StreamSink<Food>? ();
  // StreamSink<Food>? audioStreamController;
  // get http => null;
  // getPath() async {
  //   var directory = await getApplicationDocumentsDirectory();

  //   return '${directory.path}/audio_recording.mp4';
  // }

  // Future<bool> checkAndRequestPermission() async {
  //   if (await Permission.microphone.isGranted) {
  //     // Permission already granted
  //     return true;
  //   } else {
  //     // Request permission
  //     var status = await Permission.microphone.request();
  //     if (status == PermissionStatus.granted) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }
  // }

  // Future<void> startRecording() async {
  //   try {
  //     // Check and request permission
  //     var hasPermission = await checkAndRequestPermission();
  //     if (!hasPermission) {
  //       print('Permission not granted');
  //       return;
  //     }

  //     // Start recording
  //     await _audioRecorder.openRecorder();
  //     await _audioRecorder.startRecorder(toStream: audioStreamController);

  //     // Listen for data events during recording
  //     _audioRecorder.onProgress!.listen((RecordingDisposition event) {
  //       // Do something with the recording disposition if needed
  //       print(event);
  //     });

  //     print('Recording started');
  //   } catch (err) {
  //     print('Error starting recording: $err');
  //   }
  // }

  // void fetchAudioToText() async {
  //   try {
  //     // Make GET request to the API endpoint
  //     var response =
  //         await http.get(Uri.parse('http://192.168.1.4:8000/audio-to-text'));

  //     // Check if the request was successful (status code 200)
  //     if (response.statusCode == 200) {
  //       // Print the response body (the text converted from audio)
  //       print('Audio to text: ${response.body}');
  //     } else {
  //       // Print error message if the request was not successful
  //       print('Failed to fetch audio to text: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // Print any error that occurs during the request
  //     print('Error fetching audio to text: $error');
  //   }
  // }

  // Future<void> stopRecording() async {
  //   try {
  //     String? path = await _audioRecorder.stopRecorder();
  //     audioPath.value = path!;
  //     print('Recording stopped: $path');
  //   } catch (err) {
  //     print('Error stopping recording: $err');
  //   }
  // }

  // Future<void> playRecording() async {
  //   try {
  //     var filePath = await getPath();
  //     print(filePath);
  //     // Play the recorded audio
  //     await _audioPlayer.play(filePath);
  //     // if (result == 1) {
  //     //   print('Playing audio');
  //     // }
  //   } catch (err) {
  //     print('Error playing recording: $err');
  //   }
  // }

  Future<List<int>?> readFileContents(String filePath) async {
    try {
      File file = File(filePath);
      return await file.readAsBytes();
    } catch (e) {
      print('Error reading file: $e');
      return null;
    }
  }

  Future<void> sendAudioFile(String filePath) async {
    try {
      List<int>? fileContents = await readFileContents(filePath);
      if (fileContents != null) {
        var uri =
            Uri.parse('https://mayhackathon-1-5dk1.onrender.com/convert-audio');
        var request = http.MultipartRequest('POST', uri);
        request.files.add(http.MultipartFile.fromBytes(
          'audio',
          fileContents,
        ));
        var response = await request.send();
        if (response.statusCode == 200) {
          print('Audio file successfully sent!');
        } else {
          print(
              'Failed to send audio file. Status code: ${response.statusCode}');
        }
      } else {
        print('File contents are null');
      }
    } catch (e) {
      print('Error sending audio file: $e');
    }
  }

  Future<void> pickAndSendAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: true,
    );
    if (result != null) {
      String filePath = result.files.single.path!;
      await sendAudioFile(filePath);
    } else {
      // User canceled the picker
    }
  }
}

// @override
// void onClose() {
//   _audioRecorder.closeAudioSession();
//   super.onClose();
// }

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final speechController = Get.put(AudioController());

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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     ElevatedButton(
            //       onPressed: speechController.startRecording,
            //       child: const Text('Record Audio'),
            //       style: ElevatedButton.styleFrom(
            //           // primary: Colors.teal, // Change button background color
            //           // onPrimary: Colors.white, // Change text color
            //           ),
            //     ),
            //     const SizedBox(width: 20),
            //     ElevatedButton(
            //       onPressed: speechController.stopRecording,
            //       child: const Text('Stop Audio'),
            //       style: ElevatedButton.styleFrom(
            //           // primary: Colors.teal, // Change button background color
            //           // onPrimary: Colors.white, // Change text color
            //           ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 20),
            // if (speechController.selectedAudioPath.isNotEmpty)
            //   Text(
            //     'Selected Audio: ${speechController.selectedAudioPath}',
            //     style: TextStyle(fontSize: 16),
            //   ),
            SizedBox(height: 20),
            // Text(
            //   speechController.transcription,
            //   style: TextStyle(fontSize: 18),
            // ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: speechController.pickAndSendAudioFile,
              child: const Text('upload audio to Translate'),
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
