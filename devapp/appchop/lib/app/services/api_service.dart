import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../data/models/local_storage/local_storage.dart';
import '../utils/literals.dart';
import 'storage_service.dart';
import 'tool_service.dart';

class ApiService {
  final StorageService _storage = Get.find<StorageService>();
  final ToolService _tool = Get.find<ToolService>();

  Future<String?> post(String url, dynamic data) async {
    return await _call(url, data);
  }

  Future<String?> get(String url) async {
    return await _call(url, null, false);
  }

  Future<String?> _call(String url, dynamic data, [bool post = true]) async {
    try {
      var api = _api();
      var response = post ? await api.post(
        "${Literals.uri}$url",
        data: data,
      ) : await api.get(
        "${Literals.uri}$url"
      );
      if(response.statusCode != 200) {
        return response.data;
      }
      var result = response.data;
      if(_tool.isObject(result)) {
        return jsonEncode(result);
      } else {
        return result.toString();
      }
    } catch(e) {
      return null;
    }
  }

  Dio _api() {
    
    var localStorage = LocalStorage.fromJson(_storage.get(LocalStorage()));
    var api = Dio()
    ..options.headers = {
      Literals.autorization : localStorage.token,
    }
    ..options.receiveTimeout = 15.seconds
    ..options.connectTimeout = 15.seconds
    ..options.followRedirects = false
    ..options.contentType = Literals.applicationJson
    ..options.validateStatus = (status) => status! < 500;
    return api;
  }
}