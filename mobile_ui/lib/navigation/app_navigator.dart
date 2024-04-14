import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ui/pages/camera_page_advanced.dart';
import 'package:mobile_ui/pages/camera_page_intermediate.dart';
import 'package:mobile_ui/pages/options_page.dart';
import 'package:mobile_ui/pages/overall_feeback_page.dart';

import '../pages/camera_page_beginner.dart';
import '../pages/detailed_feedback_page.dart';
import 'route_type.dart';

class AppNavigator {
  static RouteObserver navigationObserver = RouteObserver();
  static Route? generateRoute(RouteSettings routeSettings) {
    for (RouteType route in RouteType.values) {
      if (route.path() == routeSettings.name) {
        print(routeSettings.name);
        switch (route) {
          case RouteType.OptionsPage:
            return MaterialPageRoute(builder: (BuildContext context) {
              return const OptionsPage();
            });
          case RouteType.CameraPageBeginner:
            return MaterialPageRoute(builder: (BuildContext context) {
              return const CameraPageBeginner();
            });
          case RouteType.CameraPageIntermediate:
            return MaterialPageRoute(builder: (BuildContext context) {
              return const CameraPageIntermediate();
            });
          case RouteType.CameraPageAdvanced:
            return MaterialPageRoute(builder: (BuildContext context) {
              return const CameraPageAdvanced();
            });
          case RouteType.OverallFeedbackPage:
            return MaterialPageRoute(builder: (BuildContext context) {
              return OverallFeedbackPage();
            });
          case RouteType.DetailedFeedbackPage:
            return MaterialPageRoute(builder: (BuildContext context) {
              return DetailedFeedbackPage();
            });
        }
      }
    }
    return null;
  }

  static MaterialPageRoute unknownRoute(RouteSettings settings) {
      return MaterialPageRoute(builder: (BuildContext context) {
        return const OptionsPage();
      });
  }
}
