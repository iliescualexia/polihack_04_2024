import 'package:flutter/material.dart';
import 'package:mobile_ui/navigation/app_navigator.dart';
import 'package:mobile_ui/provides/report_provider.dart';
import 'package:mobile_ui/widgets/choice_button.dart';
import 'package:provider/provider.dart';

import 'pages/camera_page_beginner.dart';
import 'pages/options_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ReportProvider>(
          create: (BuildContext context) => ReportProvider(),
        )
      ],
      child: MyApp(),
    )
  );
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OptionsPage(),
      onGenerateRoute: AppNavigator.generateRoute,
      onUnknownRoute: AppNavigator.unknownRoute,
      navigatorObservers: [AppNavigator.navigationObserver],
    );
  }
}
