import 'package:get/get.dart';

import '../../../services/tool_service.dart';

class FirebaseResult {
  final ToolService _tool = Get.find<ToolService>();
  int? multicastId;
  int? success;
  int? failure;
  int? canonicalIds;
  List<Map<String, dynamic>>? results;

  FirebaseResult({
    this.multicastId = 0,
    this.success = 0,
    this.failure = 0,
    this.canonicalIds = 0,
    this.results = const [],
  });

  Map toJson() => {
    'multicast_id'    : multicastId,
    'success'         : success,
    'failure'         : failure,
    'canonical_ids'   : canonicalIds,
    'results'         : results,
  };

  FirebaseResult.fromApi(Map<String, dynamic> json) {
    multicastId = _tool.str2int(json['multicastId'].toString());
    success = _tool.str2int(json['success'].toString());
    failure = _tool.str2int(json['failure'].toString());
    canonicalIds = _tool.str2int(json['canonicalIds'].toString());
    results = const [];
  }
}