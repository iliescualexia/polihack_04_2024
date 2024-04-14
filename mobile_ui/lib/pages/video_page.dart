import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_ui/models/feedback_mapping_extension.dart';
import 'package:mobile_ui/models/feedback_model.dart';
import 'package:mobile_ui/navigation/route_type.dart';
import 'package:mobile_ui/provides/report_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:http/http.dart' as http;

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  @override
  void dispose() {
    _videoPlayerController.dispose();
    Navigator.of(context).pop();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }
  Future<void> _extractAudio() async {
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String audioFilePath = '$tempPath/audio.mp3'; // Output audio file path
    var sampleVideo = widget.filePath;
    final ReportProvider feedbackProvider = context.read<ReportProvider>();
    await feedbackProvider.fetchReportData(sampleVideo, audioFilePath);
    Navigator.of(context).pushReplacementNamed(RouteType.OverallFeedbackPage.path());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _videoPlayerController.pause();
              _extractAudio();
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context){
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 20.0),
                            Text(
                              textAlign: TextAlign.center,
                              'Analysing...\nThis may take a few minutes',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    );

                  }
              );
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
  double calculateRating(double percentage) {
    percentage = percentage.clamp(0, 100);

    double rating = (percentage / 100) * 5;

    return double.parse((rating).toStringAsFixed(2));
  }
}