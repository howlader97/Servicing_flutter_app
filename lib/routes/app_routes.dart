import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/error_handling_screen/error_screen/error_screen.dart';
import 'package:flutter_riverpod_template/error_handling_screen/not_found_screen/not_found_screen.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/routes/internet_check_provider.dart';
import 'package:flutter_riverpod_template/screens/app_navigation_screen/app_navigation_screen.dart';
import 'package:flutter_riverpod_template/screens/auth/forget_password_screen/forget_password_screen.dart';
import 'package:flutter_riverpod_template/screens/auth/forget_password_verification_screen/forget_password_verification_screen.dart';
import 'package:flutter_riverpod_template/screens/auth/introduce_screen/introduce_screen.dart';
import 'package:flutter_riverpod_template/screens/auth/login_screen/login_screen.dart';
import 'package:flutter_riverpod_template/screens/auth/on_board_screen/on_board_screen.dart';
import 'package:flutter_riverpod_template/screens/auth/reset_password_screen/reset_password_screen.dart';
import 'package:flutter_riverpod_template/screens/auth/sign_up_screen/sign_up_screen.dart';
import 'package:flutter_riverpod_template/screens/auth/sign_up_verification_screen/sign_up_verification_screen.dart';
import 'package:flutter_riverpod_template/screens/base_screen/about_us_screen/about_us_screen.dart';
import 'package:flutter_riverpod_template/screens/base_screen/faq_screen/faq_screen.dart';
import 'package:flutter_riverpod_template/screens/base_screen/privacy_policy_screen/privacy_policy_screen.dart';
import 'package:flutter_riverpod_template/screens/base_screen/terms_and_conditions_screen/terms_and_conditions_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contract_delete_account_form/contract_delete_account_form.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contract_job_details_screen/contract_job_details_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contract_job_evidence_screen/contract_job_evidence_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_alert_screen/contractor_allert_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_delete_account_screen/contractor_delete_accoutn_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_edit_profile_screen/contractor_edit_profile_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_home_screen/contractor_home_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_jobs_screen/contractor_jobs_screen.dart';
import 'package:flutter_riverpod_template/screens/contractor_screen/contractor_profile_screen/contractor_profile_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/change_password_screen/change_password_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housign_maintainence_screen/housing_maintainence_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_create_job_screen/housing_create_job_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_feedback_screen/housing_feedback_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_issue_details_screen/housing_issue_details_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_job_details_screen/housing_job_details_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_assets_screen/housing_manager_assets_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_home_screen/housing_manager_home_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_job_screen/housing_manager_job_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_notification_screen/housing_manager_notification_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_manager_profile_screen/housing_manager_profile_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_contractor_info/housing_contractor_info.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_contractor_info/housing_contractor_review_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_profile_edit_screen/housing_profile_edit_screen.dart';
import 'package:flutter_riverpod_template/screens/housing_manager_screen/housing_subscription_screen/housing_subscription_screen.dart';
import 'package:flutter_riverpod_template/screens/splash_screen/splash_screen.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:go_router/go_router.dart';
import '../models/all_jobs_model.dart';
import '../screens/contractor_screen/contractor_job_success/contract_job_success.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  ////////////// constructor
  AppRoutes._privateConstructor();
  static final AppRoutes _instance = AppRoutes._privateConstructor();
  static AppRoutes get instance => _instance;
  //////////////// routes

  GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppRoutesKey.instance.initial,
    routes: [
      GoRoute(
        path: AppRoutesKey.instance.initial,
        name: AppRoutesKey.instance.splash,
        builder: (context, state) => SplashScreen(),
      ),

      GoRoute(
        path: "/${AppRoutesKey.instance.onBoardScreen}",
        name: AppRoutesKey.instance.onBoardScreen,
        builder: (context, state) => OnBoardScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.loginScreen}",
        name: AppRoutesKey.instance.loginScreen,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.signUpScreen}",
        name: AppRoutesKey.instance.signUpScreen,
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.signUpVerificationScreen}",
        name: AppRoutesKey.instance.signUpVerificationScreen,
        builder: (context, state) => SignUpVerificationScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.forgetPasswordScreen}",
        name: AppRoutesKey.instance.forgetPasswordScreen,
        builder: (context, state) => ForgetPasswordScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.forgetPasswordVerificationScreen}",
        name: AppRoutesKey.instance.forgetPasswordVerificationScreen,
        builder: (context, state) => ForgetPasswordVerificationScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.resetPasswordScreen}",
        name: AppRoutesKey.instance.resetPasswordScreen,
        builder: (context, state) => ResetPasswordScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.introduceScreen}",
        name: AppRoutesKey.instance.introduceScreen,
        builder: (context, state) => IntroduceScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.appNavigationScreen}",
        name: AppRoutesKey.instance.appNavigationScreen,
        builder: (context, state) => AppNavigationScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingManagerHomeScreen}",
        name: AppRoutesKey.instance.housingManagerHomeScreen,
        builder: (context, state) => HousingManagerHomeScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingManagerJobScreen}",
        name: AppRoutesKey.instance.housingManagerJobScreen,
        builder: (context, state) => HousingManagerJobScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingManagerAssetsScreen}",
        name: AppRoutesKey.instance.housingManagerAssetsScreen,
        builder: (context, state) => HousingManagerAssetsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingManagerProfileScreen}",
        name: AppRoutesKey.instance.housingManagerProfileScreen,
        builder: (context, state) => HousingManagerProfileScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractorHomeScreen}",
        name: AppRoutesKey.instance.contractorHomeScreen,
        builder: (context, state) => ContractorHomeScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractorJobsScreen}",
        name: AppRoutesKey.instance.contractorJobsScreen,
        builder: (context, state) => ContractorJobsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractorAlertScreen}",
        name: AppRoutesKey.instance.contractorAlertScreen,
        builder: (context, state) => ContractorAlertScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractorProfileScreen}",
        name: AppRoutesKey.instance.contractorProfileScreen,
        builder: (context, state) => ContractorProfileScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.notFoundScreen}",
        name: AppRoutesKey.instance.notFoundScreen,
        builder: (context, state) => NotFoundScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingCreateJobScreen}",
        name: AppRoutesKey.instance.housingCreateJobScreen,
        builder: (context, state) => HousingCreateJobScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingJobDetailsScreen}",
        name: AppRoutesKey.instance.housingJobDetailsScreen,
        builder: (context, state) {
          if (state.extra is Job) {
            final job = state.extra as Job;
            return HousingJobDetailsScreen(job: job);
          } else if (state.extra is String) {
            final jobId = state.extra as String;
            return HousingJobDetailsScreen(jobId: jobId);
          }
          return ErrorScreen();
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingIssueDetailsScreen}",
        name: AppRoutesKey.instance.housingIssueDetailsScreen,
        builder: (context, state) {
          final issue = state.extra as String? ?? '';
          return HousingIssueDetailsScreen(issueId: issue);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.privacyPolicyScreen}",
        name: AppRoutesKey.instance.privacyPolicyScreen,
        builder: (context, state) => PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.termsAndConditionsScreen}",
        name: AppRoutesKey.instance.termsAndConditionsScreen,
        builder: (context, state) => TermsAndConditionsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.aboutUsScreen}",
        name: AppRoutesKey.instance.aboutUsScreen,
        builder: (context, state) => AboutUsScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.faqScreen}",
        name: AppRoutesKey.instance.faqScreen,
        builder: (context, state) => FaqScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingManagerNotificationScreen}",
        name: AppRoutesKey.instance.housingManagerNotificationScreen,
        builder: (context, state) => HousingManagerNotificationScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingMaintenanceScreen}",
        name: AppRoutesKey.instance.housingMaintenanceScreen,
        builder: (context, state) {
          final propertyId = state.extra as String? ?? '';
          return HousingMaintenanceScreen(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingContractorInfo}",
        name: AppRoutesKey.instance.housingContractorInfo,
        builder: (context, state) => const HousingContractorInfo(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingContractorReview}",
        name: AppRoutesKey.instance.housingContractorReview,
        builder: (context, state) => const HousingContractorReviewScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingSubscriptionScreen}",
        name: AppRoutesKey.instance.housingSubscriptionScreen,
        builder: (context, state) => const HousingSubscriptionScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingProfileEditScreen}",
        name: AppRoutesKey.instance.housingProfileEditScreen,
        builder: (context, state) => const HousingProfileEditScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractorEditProfileScreen}",
        name: AppRoutesKey.instance.contractorEditProfileScreen,
        builder: (context, state) => const ContractorEditProfileScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractorDeleteAccountScreen}",
        name: AppRoutesKey.instance.contractorDeleteAccountScreen,
        builder: (context, state) => const ContractorDeleteAccountScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractDeleteAccountForm}",
        name: AppRoutesKey.instance.contractDeleteAccountForm,
        builder: (context, state) => const ContractDeleteAccountForm(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.changePasswordScreen}",
        name: AppRoutesKey.instance.changePasswordScreen,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractJobDetailsScreen}",
        name: AppRoutesKey.instance.contractJobDetailsScreen,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final jobId = extra?['jobId'] as String?;
          return ContractJobDetailsScreen(
            jobId: jobId,
          );
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractJobEvidenceScreen}",
        name: AppRoutesKey.instance.contractJobEvidenceScreen,
        builder: (context, state) {
          final jobId= state.extra as String;
          return  ContractJobEvidenceScreen(jobId: jobId,);
        },
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.contractJobSuccess}",
        name: AppRoutesKey.instance.contractJobSuccess,
        builder: (context, state) => const ContractJobSuccess(),
      ),
      GoRoute(
        path: "/${AppRoutesKey.instance.housingFeedbackScreen}",
        name: AppRoutesKey.instance.housingFeedbackScreen,
        builder: (context, state) {
          final job = state.extra as Job;
          return HousingFeedbackScreen(job: job);
        },
      ),
    ],
    errorBuilder: (context, state) {
      return NotFoundScreen();
    },
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context, listen: false);
      final asyncStatus = container.read(internetStatusProvider);

      if (asyncStatus.isLoading) return null;
      if (asyncStatus.hasError) return "/${AppRoutesKey.instance.errorScreen}";

      final isOnline = asyncStatus.value ?? true;
      final goingToNoInternet =
          state.name == AppRoutesKey.instance.noInternetScreen;

      if (!isOnline && !goingToNoInternet) {
        return "/${AppRoutesKey.instance.noInternetScreen}";
      }

      if (isOnline && goingToNoInternet) {
        return "/"; // initial route
      }

      return null;
    },
  );

  ////////////////////. route operation start
  String _normalize(String value) => value.startsWith("/") ? value : "/$value";

  void go(String value) {
    try {
      router.go(_normalize(value));
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void goNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    String? fragment,
  }) {
    try {
      router.goNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        fragment: fragment,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("goNamed", e);
    }
  }

  void replace(String value, {Object? extra}) {
    try {
      router.replace(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  void replaceNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.replaceNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("replaceNamed", e);
    }
  }

  void push(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.push(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("push", e);
    }
  }

  void pushNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.pushNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("pushNamed", e);
    }
  }

  void pushReplacement(String value, {Object? extra}) {
    try {
      router.pushReplacement(_normalize(value), extra: extra);
    } catch (e) {
      errorLog("pushReplacement", e);
    }
  }

  void pushReplacementNamed(
    String value, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      router.pushReplacementNamed(
        value,
        pathParameters: pathParameters,
        extra: extra,
        queryParameters: queryParameters,
      );
    } catch (e) {
      errorLog("pushReplacementNamed", e);
    }
  }

  void pop() {
    try {
      GoRouter.of(rootNavigatorKey.currentContext!).pop();
    } catch (e) {
      errorLog("pop", e);
    }
  }

  ////////////////////. route operation end
}


