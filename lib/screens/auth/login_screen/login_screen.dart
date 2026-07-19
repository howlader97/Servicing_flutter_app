import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/auth/login_screen/provider/login_provider.dart';

import '../../../constant/app_asserts_icons_path.dart';
import '../../../widgets/buttons/app_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  void onAppInitial() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void initState() {
    onAppInitial();
    super.initState();
  }

  void onAppDispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void dispose() {
    onAppDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginActionProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Gap(height: 5),
                    Image.asset(
                      AppAssertsIconsPath.instance.splashIcon,
                      scale: 5,
                    ),
                    const Gap(height: 12),
                    AppText(
                      text: "Welcome back",
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                    const Gap(height: 10),
                    AppText(
                      text: "Please login with your Gmail",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textColor,
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Gap(height: AppSize.height(value: 50)),
                    AppInputWidgetTwo(
                      controller: emailController,
                      title: "Email",
                      maxLines: 1,
                      titleColor: AppColors.instance.textHeading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: "Input Email",
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
                      controller: passwordController,
                      title: "Password",
                      maxLines: 1,
                      titleColor: AppColors.instance.textHeading,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      hintText: "Input Password",
                      isPassWord: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Enter password";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    Gap(height: AppSize.height(value: 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: AppButton(
                        isLoading: loginState.isLoading,
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref
                                .read(loginActionProvider.notifier)
                                .login(
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                );
                          }
                        },
                        height: AppSize.height(value: 50),
                        backgroundColor: AppColors.instance.primary,
                        title: "Next",
                      ),
                    ),
                    Gap(height: AppSize.height(value: 25)),
                    GestureDetector(
                      onTap: () {
                        AppRoutes.instance.pushNamed(
                          AppRoutesKey.instance.forgetPasswordScreen,
                        );
                      },
                      child: AppText(
                        text: "Forgot password?",
                        color: AppColors.instance.error,
                        fontSize: 16,
                      ),
                    ),
                    Gap(height: AppSize.height(value: 25)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: "Don't have an account?",
                          color: AppColors.instance.textColor,
                          fontSize: 16,
                        ),
                        const Gap(width: 5),
                        GestureDetector(
                          onTap: () {
                            AppRoutes.instance.push(
                              AppRoutesKey.instance.introduceScreen,
                            );
                          },
                          child: AppText(
                            text: "Sign Up",
                            color: AppColors.instance.textColor,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
