import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_ui/utils/app_colors.dart';
import 'package:mobile_ui/utils/app_text_style.dart';
import 'package:mobile_ui/utils/custom_sizes.dart';
import 'package:mobile_ui/widgets/choice_button.dart';
import 'package:mobile_ui/widgets/option_panel.dart';

import '../navigation/route_type.dart';

class OptionsPage extends StatefulWidget{
  const OptionsPage({super.key});

  @override
  State<StatefulWidget> createState() => _OptionsPageState();

}
class _OptionsPageState extends State<OptionsPage>{
  final List<String> options = ["Beginner", "Intermediate", "Advanced"];
  final List<Color> colors = [
    AppColors.green,
    AppColors.yellow,
    AppColors.red
  ];
  final List<RouteType> routes= [
    RouteType.CameraPageBeginner,
    RouteType.CameraPageIntermediate,
    RouteType.CameraPageAdvanced
  ];
  final PageController _pageController = PageController(initialPage: 0);
  int _activePage = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Practice your public speaking skills",
          style: AppTextStyle.darkDefaultStyle(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          IconButton(
              color: AppColors.black,
              icon: Icon(Icons.logout),
              onPressed: () {
                //TODO: handle logout
              })
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: AppColors.ivory),
          ),
          SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: CustomSizes.defaultHorizontalOffset() * 3,
                    vertical: CustomSizes.defaultVerticalOffset() * 2),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    return Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: constraints.maxHeight * 0.5,
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                                onPageChanged: (int pageIndex) {
                                setState(() {
                                  _activePage = pageIndex;
                                });
                                },
                                controller: _pageController,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: constraints.maxWidth * 0.04,
                                        right: constraints.maxWidth * 0.04),
                                    child: OptionPanel(
                                      width: constraints.maxWidth * 0.7,
                                      height: constraints.maxHeight * 0.5,
                                      color: colors[index],
                                      optionType: options[index],
                                      onPressed: (){
                                      Navigator.of(context).pushNamed(routes[index].path());
                                      },
                                    ),
                                  );
                                }),
                            ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: CustomSizes.defaultVerticalOffset() * 5,
                            ),
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                  List<Widget>.generate(
                                    options.length,
                                      (index) => Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: CustomSizes.defaultHorizontalOffset() * 3,
                                        ),
                                        child: InkWell(
                                          onTap:(){
                                            _pageController.animateToPage(
                                                index,
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeIn);
                                          },
                                          child: CircleAvatar(
                                            radius: 5,
                                            backgroundColor: _activePage == index
                                              ? Colors.black
                                                : Colors.grey
                                          ),
                                        ),
                                      )
                                  )
                                ,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
          )
        ],
      ),
    );
  }
}