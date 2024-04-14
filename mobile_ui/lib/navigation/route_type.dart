enum RouteType{
  OptionsPage,
  CameraPageBeginner,
  CameraPageAdvanced,
  CameraPageIntermediate,
  OverallFeedbackPage,
  DetailedFeedbackPage
}
extension RouteTypeNamed on RouteType{
  String path(){
    return '/$name';
  }
}