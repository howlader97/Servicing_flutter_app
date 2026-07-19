import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_icons_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/auth/sign_up_verification_screen/provider/signup_verificaiton_provider.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';

class SignUpVerificationScreen extends ConsumerStatefulWidget {
  const SignUpVerificationScreen({super.key});

  @override
  ConsumerState<SignUpVerificationScreen> createState() => _SignUpVerificationScreenState();
}

class _SignUpVerificationScreenState extends ConsumerState<SignUpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  String _email = "";
  bool _isLoadingEmail = true;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final email = await StorageServices.instance.getEmail();
    if (mounted) {
      setState(() {
        _email = email;
        _isLoadingEmail = false;
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verifyState = ref.watch(signUpOtpVerifyProvider);
    final resendState = ref.watch(signUpResendOtpProvider);

    ref.listen<AsyncValue<bool?>>(signUpOtpVerifyProvider, (previous, next) {
      next.whenOrNull(
        data: (success) {
          if (success == true) {
            AppSnackBar.instance.success("Verification successful!");
            AppRoutes.instance.go(
              AppRoutesKey.instance.loginScreen,
            );
          } else if (success == false) {
            AppSnackBar.instance.error("OTP verification failed.");
          }
        },
        error: (err, stack) {
          AppSnackBar.instance.error("Verification error: $err");
        },
      );
    });

    ref.listen<AsyncValue<bool?>>(signUpResendOtpProvider, (previous, next) {
      next.whenOrNull(
        data: (success) {
          if (success == true) {
            AppSnackBar.instance.success("OTP resent successfully!");
          } else if (success == false) {
            AppSnackBar.instance.error("Failed to resend OTP.");
          }
        },
        error: (err, stack) {
          AppSnackBar.instance.error("Resend error: $err");
        },
      );
    });

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
                      text: "Verify Gmail",
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textHeading,
                    ),
                    const Gap(height: 10),
                    AppText(
                      text: "We sent code to your Gmail",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.instance.textColor,
                    ),
                    if (_isLoadingEmail)
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      AppText(
                        text: _email.isNotEmpty ? _email : "No email found",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
                      controller: _codeController,
                      title: "Code",
                      hintText: "Input code",
                      maxLines: 1,
                      titleColor: AppColors.instance.textHeading,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter verification code";
                        }
                        return null;
                      },
                    ),
                    Gap(height: AppSize.height(value: 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppText(
                            text: "If you didn't receive a code?",
                            color: AppColors.instance.textColor,
                            fontSize: 16,
                          ),
                          const Gap(width: 5),
                          resendState.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    if (_email.isNotEmpty) {
                                      ref.read(signUpResendOtpProvider.notifier).resendOtp(email: _email);
                                    } else {
                                      AppSnackBar.instance.error("Email not found to resend OTP");
                                    }
                                  },
                                  child: AppText(
                                    text: "Resend",
                                    color: AppColors.instance.textColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Gap(height: AppSize.height(value: 20)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: AppButton(
                        isLoading: verifyState.isLoading,
                        onTap: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (_email.isNotEmpty) {
                              ref.read(signUpOtpVerifyProvider.notifier).verifyOtp(
                                    email: _email,
                                    code: _codeController.text.trim(),
                                  );
                            } else {
                              AppSnackBar.instance.error("Email not found");
                            }
                          }
                        },
                        height: AppSize.height(value: 46),
                        backgroundColor: AppColors.instance.primary,
                        title: "Verify",
                      ),
                    ),
                    Gap(height: AppSize.height(value: 25)),
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
