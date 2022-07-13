import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_explorer/core/core.dart';
import 'package:image_explorer/modules/landing/views/views.dart';
import 'package:image_explorer/modules/search/controllers/search_controller.dart';
import 'package:provider/provider.dart';

class ImageExplorer extends StatelessWidget {
  const ImageExplorer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Utilities.setDeviceOrientation();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SearchController())
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, widget) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const ImageExplorerEntry(),
          theme: ThemeData(
            textTheme:
                GoogleFonts.workSansTextTheme(Theme.of(context).textTheme),
          ),
        ),
      ),
    );
  }
}

class ImageExplorerEntry extends StatelessWidget {
  const ImageExplorerEntry({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child:  Landing(),
              ),
            )
          ],
        );
      },
    );
  }
}
