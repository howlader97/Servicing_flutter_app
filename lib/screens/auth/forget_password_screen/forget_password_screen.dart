import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/auth/forget_password_screen/provider/forget_password_provider.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends ConsumerState<ForgetPasswordScreen> {
    late TextEditingController emailController;
    @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    final isLoading = forgotPasswordState.isLoading;

    return Scaffold(
      backgroundColor: AppColors.instance.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Gap(height: 5),
                  Image.asset(
                    AppAssertsIconsPath.instance.splashIcon,
                    scale: 5,
                  ),
                  Gap(height: 12),
                  AppText(
                    text: "Restore Your Shield",
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: AppColors.instance.textHeading,
                  ),
                  Gap(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AppText(
                      text: "Enter your registered email to receive a secure recovery code",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      color: AppColors.instance.textColor,
                    ),
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
                    hintText: "Input email",
                    titleColor: AppColors.instance.textHeading,
                  ),
                  Gap(height: AppSize.height(value: 30)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: AppButton(
                      onTap: () async {
                        final email = emailController.text.trim();
                        if (email.isEmpty) {
                          AppSnackBar.instance.error("Please enter your email");
                          return;
                        }
                        final success = await ref.read(forgotPasswordProvider.notifier).sendCode(email);
                        if (success) {
                          AppRoutes.instance.pushNamed(
                            AppRoutesKey.instance.forgetPasswordVerificationScreen,
                          );
                        }
                      },
                      isLoading: isLoading,
                      height: AppSize.height(value: 46),
                      backgroundColor: AppColors.instance.primary,
                      title: "Send Code",
                    ),
                  ),
                  Gap(height: AppSize.height(value: 25)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
