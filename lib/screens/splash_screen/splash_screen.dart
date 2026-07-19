import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StorageServices storageServices =StorageServices.instance;


   @override
  void initState() {
    goToNextScreen();
    super.initState();
  }
  void goToNextScreen()async{
     try{
      await Future.delayed(Duration(seconds: 2));
      final token = await storageServices.getToken();
      if(token.isEmpty){
        AppRoutes.instance.go(AppRoutesKey.instance.onBoardScreen);
      }else{
        AppRoutes.instance.go(AppRoutesKey.instance.appNavigationScreen);
      }
     }catch(e){
       errorLog("error is", e);
     }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssertsIconsPath.instance.splashIcon, scale: 4),
            Gap(height: 15),
            AppText(
              text: "COMMON GROUND",
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
            Gap(height: 10),
            AppText(
              text: "DEVELOPMENTS",
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF727E3E),
            ),
          ],
        ),
      ),
    );
  }
}
