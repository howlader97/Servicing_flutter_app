import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class AppApiUrl {
  AppApiUrl._privateConstructor();
  static final AppApiUrl _instance = AppApiUrl._privateConstructor();
  static AppApiUrl get instance => _instance;
  //////////////  app base api end point

  // static final String _baseUrlFromEnv = String.fromEnvironment(
  //   'BASE_URL',
  //   defaultValue: 'https://api.yourapp.com', // safe fallback for CI
  // );

  static final String _baseUrlFromEnv = dotenv.get('BASE_URL');

  static String _validateUrl(String url) {
    // Block plain HTTP in release builds — HTTPS required in production
    if (!kDebugMode && url.startsWith('http://')) {
      errorLog(
        'AppApiUrl',
        'HTTP (non-TLS) base URL blocked in release build. Use HTTPS.',
      );
      assert(false, 'Production builds must use HTTPS. Got: $url');
    }
    return url;
  }

  static final String domain = _validateUrl(_baseUrlFromEnv);
  static final String socket = _validateUrl(_baseUrlFromEnv);
  final String baseUrl = "$domain/api/v1";

  //////////////////////////////////  base
  String refreshToken = "/refreshToken";
  String userProfile = "/user/profile";
  String about = "/public/static-content/about";
  String privacyPolicy = "/public/static-content/privacy";
  String termsAndConditions = "/public/static-content/terms";
  String faq = "/public/faqs";
  String notification = "/notification";
  ////////////
  String login = "/auth/login";
  String authDeleteAccount = "/authDeleteAccount";
  String user = "/auth/register";
  String userCommunity = "/public/communities";
  String userService = "/public/services";
  String changePassword = "/profile/change-password";
  String userResendOtp = "/userResendOtp";
  String authOtpVerify = "/auth/verify-email";
  String authForgotPassword = "/authForgotPassword";
  String authVerifyEmail = "/authVerifyEmail";
  String authResetPassword = "/authResetPassword";
  String housingDashboard = "/housing-manager/dashboard";
  String housingRecentActivity = "/housing-manager/dashboard/recent-activity";
  String contractorDashboard = "/contractor/dashboard";
  String contractorRecentActivity = "/contractor/dashboard/recent-activity";
  String contractorJobs = "/contractor/jobs";
  String contractorJobDetails(String jobId) => "/contractor/jobs/$jobId";
  String housingProperty = "/housing-manager/properties";
  String housingPropertyDetails(String propertyId) =>
      "/housing-manager/properties/$propertyId";
  String housingJobs = "/housing-manager/jobs";
  String jobDetails(String jobId) => "/housing-manager/jobs/$jobId";
  String housingIssues = "/housing-manager/issues";
  String issueDetails(String issueId) => "/housing-manager/issues/$issueId";
  String housingContractors = "/housing-manager/contractors";
  String profile = "/profile/";
  String forgotPassword = "/auth/forgot-password";
  String verifyEmail = "/auth/verify-email";
  String resendVerification = "/auth/resend-verification";
  String resetPassword = "/auth/reset-password";
  String jobEvidence(String jobId) => "/contractor/jobs/$jobId/abidance";
  String contractorAcceptJob(String jobId) => "/contractor/jobs/$jobId/accept";
  String contractorDeclineJob(String jobId) => "/contractor/jobs/$jobId/decline";
  String rejectJob(String jobId) => "/housing-manager/jobs/$jobId/reject";
  String approveJob(String jobId) => "/housing-manager/jobs/$jobId/approve";
  String reviewJob(String jobId) => "/housing-manager/jobs/$jobId/review";
  String assignJob(String jobId) => "/housing-manager/jobs/$jobId/assign";
  String fcmToken = "/auth/fcm-token";
}
