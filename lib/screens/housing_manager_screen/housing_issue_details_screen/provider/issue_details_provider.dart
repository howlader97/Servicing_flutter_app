import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/issue_model.dart';
import '../../../../services/repository/housing_issue_repository.dart';

final issueDetailsProvider = FutureProvider.family<Issue?,String>((ref,issueId)async{
  final repo = HousingIssueRepository.instance;
  return repo.getIssueDetails(issueId);
});