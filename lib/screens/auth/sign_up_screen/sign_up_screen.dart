import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/constant/app_constant.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/provider/user_role_provider.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/buttons/drop_down.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/auth/sign_up_screen/provider/sign_up_provider.dart';
import 'package:flutter_riverpod_template/models/community_name_model.dart';
import 'package:flutter_riverpod_template/models/service_name_model.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:shimmer/shimmer.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Gap(height: 3),
                  Image.asset(
                    AppAssertsIconsPath.instance.splashIcon,
                    scale: 5,
                  ),
                  Gap(height: 8),
                  AppText(
                    text: "Sign up Common Ground",
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Gap(height: 8),
                  AppText(
                    text: "Join the elite network of protected\nindividuals",
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    color: AppColors.instance.textColor,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SignUpForm(userRole: userRole),
            ),
            SliverToBoxAdapter(child: Column(children: [
              Gap(height: AppSize.height(value: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: "Already have an account?",
                    color: AppColors.instance.textColor,
                    fontSize: 16,
                    fontFamily: AppConstant.instance.libreFranklin,
                  ),
                  Gap(width: 5),
                  GestureDetector(
                    onTap: () {
                      AppRoutes.instance.go(
                        AppRoutesKey.instance.loginScreen,
                      );
                    },
                    child: AppText(
                      text: "Sign In",
                      color: AppColors.instance.textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppConstant.instance.libreFranklin,
                    ),
                  ),
                ],
              ),
              Gap(height: 25),
            ],),)
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({
    super.key,
    required this.userRole,
  });

  final String userRole;

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPassController;

  void onAppInitial(){
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPassController = TextEditingController();
  }

  @override
  void initState() {
    onAppInitial();
    super.initState();
  }

  void onAppDispose(){
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
  }

  @override
  void dispose() {
    onAppDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(signUpActionProvider);

    ref.listen<AsyncValue<bool?>>(signUpActionProvider, (previous, next) {
      next.whenOrNull(
        data: (success) {
          if (success == true) {
            AppSnackBar.instance.success("Sign up successful!");
            AppRoutes.instance.pushNamed(
              AppRoutesKey.instance.signUpVerificationScreen,
            );
          }
        },
      );
    });

    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppInputWidgetTwo(
            controller: nameController,
            title: "Full Name",
            titleColor: AppColors.instance.textHeading,
            hintText: "Input name",
            validator: (String? value){
              if(value?.isEmpty == true){
                return "Enter name";
              }
              return null;
            },
          ),
          AppInputWidgetTwo(
            controller: emailController,
            title: "Email",
            titleColor: AppColors.instance.textHeading,
            hintText: "Input email",
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return "Enter email";
              }
              final emailRegex = RegExp(
                r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
              );
              if (!emailRegex.hasMatch(value.trim())) {
                return "Enter a valid email";
              }
              return null;
            },
          ),
          AppInputWidgetTwo(
            controller: phoneController,
            title: "Contact Number",
            titleColor: AppColors.instance.textHeading,
            hintText: "Input contact",
            validator: (String? value){
              if(value?.isEmpty == true){
                return "Enter number";
              }
              return null;
            },
          ),
          if (widget.userRole == "CONTRACTOR")
            ref.watch(servicesProvider).when(
                  data: (services) => DropdownField<ServiceCategory>(
                    title: "Service",
                    hintText: "Select service",
                    value: ref.watch(selectedServiceProvider),
                    options: services,
                    itemLabel: (e) => e.name,
                    onChanged: (val) {
                      ref.read(selectedServiceProvider.notifier).select(val);
                    },
                  ),
                  loading: () => Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.instance.grayE2,
                      highlightColor: AppColors.instance.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(height: 15),
                          Container(
                            width: 120.0,
                            height: 18.0,
                            decoration: BoxDecoration(
                              color: AppColors.instance.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          const Gap(height: 10),
                          Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: AppColors.instance.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  error: (err, stack) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: AppText(
                      text: "Error loading services",
                      color: AppColors.instance.error,
                    ),
                  ),
                )
          else
            ref.watch(communitiesProvider).when(
                  data: (communities) => DropdownField<Community>(
                    title: "Community Name",
                    hintText: "Select community",
                    value: ref.watch(selectedCommunityProvider),
                    options: communities,
                    itemLabel: (e) => e.name,
                    onChanged: (val) {
                      ref.read(selectedCommunityProvider.notifier).select(val);
                    },
                  ),
                  loading: () => Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0)),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.instance.grayE2,
                      highlightColor: AppColors.instance.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(height: 15),
                          Container(
                            width: 120.0,
                            height: 18.0,
                            decoration: BoxDecoration(
                              color: AppColors.instance.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          const Gap(height: 10),
                          Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: AppColors.instance.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  error: (err, stack) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: AppText(
                      text: "Error loading communities",
                      color: AppColors.instance.error,
                    ),
                  ),
                ),
          AppInputWidgetTwo(
            controller: passwordController,
            title: "Password",
            titleColor: AppColors.instance.textHeading,
            hintText: "Input password",
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Enter password";
              }
              if (value.length < 8) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          AppInputWidgetTwo(
            controller: confirmPassController,
            title: "Confirm Password",
            titleColor: AppColors.instance.textHeading,
            hintText: "Confirm password",
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Confirm your password";
              }
              if (value != passwordController.text) {
                return "Passwords do not match";
              }
              return null;
            },
          ),
          Gap(height: AppSize.height(value: 15)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: AppButton(
              isLoading: signUpState.isLoading,
              onTap: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final role = widget.userRole;
                  String? communityId;
                  String? serviceId;

                  if (role == "HOUSING_MANAGER") {
                    final selectedCommunity = ref.read(selectedCommunityProvider);
                    if (selectedCommunity == null) {
                      AppSnackBar.instance.error("Please select a community");
                      return;
                    }
                    communityId = selectedCommunity.id;
                  } else if (role == "CONTRACTOR") {
                    final selectedService = ref.read(selectedServiceProvider);
                    if (selectedService == null) {
                      AppSnackBar.instance.error("Please select a service");
                      return;
                    }
                    serviceId = selectedService.id;
                  }

                  await ref.read(signUpActionProvider.notifier).signUp(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    phone: phoneController.text.trim(),
                    password: passwordController.text,
                    confirmPassword: confirmPassController.text,
                    role: role,
                    communityId: communityId,
                    serviceId: serviceId,
                  );
                }
              },
              height: AppSize.height(value: 47),
              backgroundColor: AppColors.instance.primary,
              title: "Create an account",
            ),
          ),
        ],
      ),
    );
  }
}
