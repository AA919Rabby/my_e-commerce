import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:mye_commerce/presentation/intro/ui/screen/intro_screen.dart';

import 'all_binding.dart';
import 'all_route.dart';
import 'core/theme/app_color.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required home});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E Commerce',
          initialBinding: AllBinding(),
          initialRoute: AllRoute.intro,
          getPages: AllRoute.routes,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColor.drawerGradient1,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
            ),
          ),
          home: child,
        );
      },
      child: IntroScreen(),
    );
  }
}
