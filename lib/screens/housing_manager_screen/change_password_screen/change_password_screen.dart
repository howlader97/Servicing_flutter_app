import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/constant/app_constant.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/buttons/icon_button_widget.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/change_password_screen/provider/change_password_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController currentPassword;
  late TextEditingController newPassword;
  late TextEditingController confirmPassword;

  void onAppInitial() {
    currentPassword = TextEditingController();
    newPassword = TextEditingController();
    confirmPassword = TextEditingController();
  }

  @override
  void initState() {
    onAppInitial();
    super.initState();
  }

  void onAppClose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
  }

  @override
  void dispose() {
    onAppClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final changePasswordState = ref.watch(changePasswordProvider);

    return Scaffold(
      backgroundColor: AppColors.instance.bottomColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    IconButtonWidget(
                      onTap: () => AppRoutes.instance.pop(),
                      color: AppColors.instance.primary,
                      child: const Icon(Icons.arrow_back_outlined),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppText(
                      text: "Create new password",
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                    AppText(
                      text: "Keep your account safe with a unique numeric \npassword",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                      textAlign: TextAlign.center,
                      fontFamily: AppConstant.instance.segoeUi,
                    ),
                    const Gap(height: 20),
                    AppInputWidgetTwo(
                      maxLines: 1,
                      controller: currentPassword,
                      title: "Current Password",
                      hintText: "****",
                      isPassWord: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Current password is required";
                        }
                        return null;
                      },
                    ),
                    AppInputWidgetTwo(
                      maxLines: 1,
                      controller: newPassword,
                      title: "Password",
                      hintText: "****",
                      isPassWord: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "New password is required";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                    ),
                    AppInputWidgetTwo(
                      maxLines: 1,
                      controller: confirmPassword,
                      title: "Confirm Password",
                      hintText: "****",
                      isPassWord: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Confirm password is required";
                        }
                        if (value != newPassword.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18),
                      child: AppButton(
                        title: "Update Password",
                        height: 44,
                        isLoading: changePasswordState.isLoading,
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            ref.read(changePasswordProvider.notifier).changePassword(
                                  currentPassword: currentPassword.text,
                                  newPassword: newPassword.text,
                                  confirmPassword: confirmPassword.text,
                                );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
