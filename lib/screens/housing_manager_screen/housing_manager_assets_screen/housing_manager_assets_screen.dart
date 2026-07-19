import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/auth/sign_up_screen/provider/sign_up_provider.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_assets_screen/provider/housing_property.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/widgets/custome_header.dart';

import '../housing_manager_home_screen/widgets/custom_container.dart';

class HousingManagerAssetsScreen extends StatelessWidget {
  const HousingManagerAssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer(
              builder: (context,ref,child) {
                final community =ref.watch(selectedCommunityProvider);
                return CustomHeader(
                  title: 'Welcome back to',
                  name:  community?.name ?? '',
                  isSearch: true,
                  isFilter: false,
                       onTap: () => AppRoutes.instance.pushNamed(
                          AppRoutesKey.instance.housingManagerNotificationScreen,)
                );
              }
            ),
          ),

          SliverToBoxAdapter(
            child: Consumer(
              builder: (context,ref,child) {
                final asyncPropertyData = ref.watch(housingPropertyProvider);
              return  asyncPropertyData.when(
                  data: (propertyData){
                    if(propertyData == null ){
                      return const Center(
                        child: Text("No Property Found"),
                      );
                    }
                  return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 22),
                      shrinkWrap: true,
                      itemCount:propertyData.data.properties.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data =propertyData.data.properties[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: (){
                              AppRoutes.instance.pushNamed(
                                AppRoutesKey.instance.housingMaintenanceScreen,
                                extra: data.id,
                              );
                            },
                            child: CustomContainer(
                              color: AppColors.instance.grayE2,
                              // isButton: true,
                              imageUrl:data.images.isNotEmpty ? data.images.first.imageUrl: '',
                              propertyId: data.propertyCode,
                              propertyLocation: data.location,
                              detailText: data.type,
                              status: "complete",
                              isDetails: true,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },  error: (error, _) => Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Error: $error"),
              ),
                  loading: () => Center(child: CircularProgressIndicator()));

              }
            ),
          ),
        ],
      ),
    );
  }
}
