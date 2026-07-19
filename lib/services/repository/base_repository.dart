import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/models/faq_model.dart';
import 'package:flutter_riverpod_template/models/static_content_model.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

class BaseRepository {
  /////////////// constructor
  BaseRepository._privateConstructor();
  static final BaseRepository _instance = BaseRepository._privateConstructor();
  static BaseRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiUrl _api = AppApiUrl.instance;

  //////////////// function
  Future<String> termsAndConditions() async {
    try {
      var response = await _apiServices.getServices(_api.termsAndConditions);
      if (response != null) {
        var model = StaticContentModel.fromJson(response);
        var content = model.data?.content?.content;
        if (content != null) {
          return content
              .toString()
              .replaceAll('white-space:pre-wrap;', '')
              .replaceAll('\u00A0', ' ')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
        }
      }
    } catch (e) {
      errorLog("termsAndConditions repo", e);
    }
    return "";
  }

  Future<String> aboutUs() async {
    try {
      var response = await _apiServices.getServices(_api.about);
      if (response != null) {
        var model = StaticContentModel.fromJson(response);
        var content = model.data?.content?.content;
        if (content != null) {
          return content
              .toString()
              .replaceAll('white-space:pre-wrap;', '')
              .replaceAll('\u00A0', ' ')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
        }
      }
    } catch (e) {
      errorLog("aboutUs repo", e);
    }
    return "";
  }

  Future<String> privacyPolicy() async {
    try {
      var response = await _apiServices.getServices(_api.privacyPolicy);
      if (response != null) {
        var model = StaticContentModel.fromJson(response);
        var content = model.data?.content?.content;
        if (content != null) {
          return content
              .toString()
              .replaceAll('white-space:pre-wrap;', '')
              .replaceAll('\u00A0', ' ')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
        }
      }
    } catch (e) {
      errorLog("privacyPolicy repo", e);
    }
    return "";
  }

  Future<List<Faq>> getAllFaq() async {
    try {
      var response = await _apiServices.getServices(_api.faq);
      if (response != null) {
        var model = FaqModel.fromJson(response);
        return model.data.faqs;
      }
    } catch (e) {
      errorLog("getAllFaq", e);
    }
    return [];
  }
}
