import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/models/faq_model.dart';
import 'package:flutter_riverpod_template/services/repository/base_repository.dart';

final fAQScreenProvider = FutureProvider<List<Faq>>((ref) async {
  return BaseRepository.instance.getAllFaq();
});

final expandedFaqIdProvider = StateProvider.autoDispose<String?>((ref) => null);
