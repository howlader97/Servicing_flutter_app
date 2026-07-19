import 'package:flutter_riverpod/legacy.dart';

final onboardingStepProvider = StateProvider.autoDispose<int>((ref) => 0);