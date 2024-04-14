import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ui/pages/video_page.dart';

import '../utils/app_colors.dart';
import '../utils/app_text_style.dart';
import '../utils/custom_sizes.dart';

class CameraPageIntermediate extends StatefulWidget {
  const CameraPageIntermediate({Key? key}) : super(key: key);

  @override
  _CameraPageIntermediateState createState() => _CameraPageIntermediateState();
}

class _CameraPageIntermediateState extends State<CameraPageIntermediate> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;
  late AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _initCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _audioPlayer.setSourceAsset('sound/crowd_intermed.mp3');
    });
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo() async {
    if (_isRecording) {

      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      _audioPlayer.stop();
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      _audioPlayer.play(_audioPlayer.source!);
      setState(() => _isRecording = true);
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Record and get feedback",
            style: AppTextStyle.darkDefaultStyle(),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: AppColors.ivory),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: CustomSizes.defaultVerticalOffset() ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CameraPreview(_cameraController),
                      // Padding(
                      //   padding: const EdgeInsets.all(25),
                      //   child: FloatingActionButton(
                      //     backgroundColor: Colors.red,
                      //     child: Icon(_isRecording ? Icons.stop : Icons.circle),
                      //     onPressed: () => _recordVideo(),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.6),
                          ),
                          child: IconButton(
                            icon: Icon(_isRecording ?  Icons.stop_circle:Icons.not_started),
                            iconSize: 48.0,
                            color: Colors.red,
                            onPressed: _recordVideo,
                          ),

                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}