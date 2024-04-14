import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:mobile_ui/models/feedback_model.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_ui/models/report_model.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import '../models/feedback_mapping_extension.dart';

class ReportProvider with ChangeNotifier{
  ReportModel? _report;
  ReportProvider();
  ReportModel? get report{
    return _report;
  }
  void setReport(ReportModel reportModel){
    _report = report;
    notifyListeners();
  }
  Future<void> fetchReportData(var sampleVideo, String audioFilePath) async{
    File _avFile = File(sampleVideo);
    var sampleAudio = audioFilePath;
    File audioFile = await _avFile.copy(sampleAudio);
    // Now you can use the extracted audio file path as needed
    final url = Uri.parse('https://ece0-5-2-197-133.ngrok-free.app/upload');
    final audioFileSent = File(audioFilePath);
    final videoFileSent = File(sampleVideo);
    // VideoPlayerController controller = new VideoPlayerController.file(sampleVideo);
    // if(controller.value.duration.inSeconds < 30){
    //
    // }
    final request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath('file1', audioFile.path),
    );

    final compressedVideo = await VideoCompress.compressVideo(
      sampleVideo,
      quality: VideoQuality.LowQuality,
    );

    request.files.add(
      await http.MultipartFile.fromPath('file2', compressedVideo!.file!.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      FeedbackModel feedbackModel;
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print(responseBody);
      feedbackModel = FeedbackModelExtension.fromJson(responseBody);
      print(feedbackModel.isMonotone);
      print(feedbackModel.pausesValue);
      print(feedbackModel.repeatedWords);
      print(feedbackModel.stutteringValue);
      print(feedbackModel.aiFeedback);
      double stutteringRating =  calculateRating(feedbackModel.stutteringValue);
      double pausesRating = calculateRating(feedbackModel.pausesValue);
      double monotoneRating = feedbackModel.isMonotone ? 0.0 : 5.0;
      ReportModel reportModel = ReportModel(stutteringRating: stutteringRating, pausesRating: pausesRating, monotoneRating: monotoneRating, repeatedWords: feedbackModel.repeatedWords, aiFeedback: feedbackModel.aiFeedback,badPosturePercentage: feedbackModel.badPosturePercentage);
     _report = reportModel;
      notifyListeners();
      print('Audio file uploaded successfully');
    } else {
      print('Failed to upload audio file: ${response.statusCode}');
    }
  }
  double calculateRating(double percentage) {
    percentage = percentage.clamp(0, 100);

    double rating = (percentage / 100) * 5;
    rating = 5 - rating;
    return double.parse((rating).toStringAsFixed(2));
  }
  double getPostureRating(){
    double rating = calculateRating(_report!.badPosturePercentage);
    return double.parse(rating.toStringAsFixed(2));
  }
  double getAverageRating() {
    if (_report != null) {
      double totalRating = _report!.stutteringRating +
          _report!.pausesRating +
          _report!.monotoneRating;
      int averageRating = (totalRating / 3).floor();
      return averageRating.toDouble();
    } else {
      return 0.0;
    }
  }
  String evaluateMonotone() {
    if (_report!.monotoneRating > 1.0) {
      return "You are enthusiastic enough.";
    } else {
      return "You are too monotone and should be more enthusiastic.";
    }
  }
  String evaluateStutteringValue(){
    print("Stutter");
    print(_report!.stutteringRating);
    if(_report!.stutteringRating < 1.0){
      return "Your speech was heavily affected by stuttering, which significantly hindered the clarity of your message. Consider seeking support or techniques to manage stuttering for improved communication.";
    }else if(_report!.stutteringRating >= 1.0 &&_report!.stutteringRating < 2.0){
      return "Stuttering was prevalent throughout your speech, causing disruptions in fluency. Exploring strategies to reduce stuttering could enhance the effectiveness of your delivery.";
    }else if(_report!.stutteringRating  >= 2.0 && _report!.stutteringRating < 3.0){
      return "While your message was understandable, there were noticeable instances of stuttering that impacted the flow of your speech. Practicing relaxation techniques may help minimize these interruptions.";
    }else if(_report!.stutteringRating >= 3.0 && _report!.stutteringRating  < 4.0){
      return "Your speech contained a few instances of stuttering, but they didn't detract significantly from the overall clarity. Continued practice may help further reduce stuttering and improve fluency.";
    }else if(_report!.stutteringRating  >= 4.0 &&_report!.stutteringRating  < 5.0){
      return "Your speech was mostly fluent with only occasional instances of stuttering. With continued effort, you can further refine your delivery to minimize these interruptions.";
    }else if(_report!.stutteringRating >= 5.0){
      return "Congratulations! Your speech was delivered with remarkable fluency, free from any noticeable stuttering. Your ability to maintain smooth communication greatly enhanced the impact of your message.";
    }
    return "";
  }

  String evaluatePausesValue(){
    print("Pauses");
    print(_report!.pausesRating );
    if(_report!.pausesRating < 1.0){
      return "Your speech was interrupted by frequent pauses, making it difficult to follow your message. Consider practicing smoother delivery to improve clarity.";
    }else if(_report!.pausesRating >= 1.0 && _report!.pausesRating < 2.0){
      return "Your speech had numerous pauses, causing disruptions in flow and comprehension. Focusing on reducing these pauses could enhance the effectiveness of your communication.";
    }else if(_report!.pausesRating >= 2.0 && _report!.pausesRating < 3.0){
      return "While your message was understandable, there were several pauses that interrupted the flow of your speech. Working on minimizing these pauses would improve the overall delivery.";
    }else if(_report!.pausesRating >= 3.0 && _report!.pausesRating < 4.0){
      return "Your speech had a few pauses, but they didn't significantly disrupt the flow. With some refinement, you could further enhance the fluidity of your delivery.";
    }else if(_report!.pausesRating >= 4.0 && _report!.pausesRating < 5.0){
      return "Your speech flowed smoothly with minimal pauses, contributing to a clear and engaging presentation. With continued practice, you can refine your delivery even further.";
    }else if(_report!.pausesRating >= 5.0){
      return "Congratulations! Your speech was delivered flawlessly without any noticeable pauses. Your ability to maintain a continuous flow greatly enhanced the impact of your message.";
    }
    return "";
  }
  String evaluateWordRepetition(){
    if(_report!.repeatedWords.isEmpty){
      return "You did not have any noticeable repeated words";
    }
    else{
      String string = "You had a some noticeable repeated words: ";
      for(String word in _report!.repeatedWords){
        string = string + word + " ";
      }
      return string;
    }
  }
  String evaluatePosture(){
    if(_report!.badPosturePercentage > 35.0){
      return "Be careful, you have a pretty bad posture. You stayed " + _report!.badPosturePercentage.toString()  +" looking like the Hunchback of Notre Dame";
    }
    else{
      return "Congrats. You maintained a correct posture during your presentation";
    }
  }


}