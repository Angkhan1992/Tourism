import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tourlao/utils/constants.dart';

import 'loading_provider.dart';


class NetworkProvider {
  final BuildContext context;

  NetworkProvider(this.context);

  static NetworkProvider of(BuildContext context) {
    return NetworkProvider(context);
  }

  Future<Map<String, dynamic>> post(String link, Map<String, dynamic> parameter,
      {bool isProgress = false}) async {
    if (isProgress && context != null) LoadingProvider.of(context).show();

    var url = Uri.parse(
        '${(kReleaseMode || PRODUCTTEST) ? RELEASEBASEURL : DEBUGBASEURL}$link');

    // var token = await PrefProvider().getToken();
    // if (token.isNotEmpty) {
    //   parameter['token'] = token;
    // }

    _httpResponseLog(url, parameter, 'Request');

    final response = await http.post(
      url,
      body: parameter,
    );
    if (isProgress && context != null) LoadingProvider.of(context).hide();

    if (response.statusCode == 201 || response.statusCode == 200) {
      var json = jsonDecode(response.body);
      if (json['ret'] == 9999) {
        _httpResponseLog(url, parameter, "Your token was expired");
        // Navigator.of(context)
        //     .popUntil(ModalRoute.withName(Constants.route_login));
        return null;
      }
      // _httpResponseLog(url, parameter, json);
      return json;
    } else {
      _httpResponseLog(url, parameter, response.statusCode);
      return {'status': response.statusCode, 'ret': 9998};
    }
  }

  static Future<Map<String, dynamic>> upload(
      Map<String, String> params, File file) async {
    String url = ((kReleaseMode || PRODUCTTEST)
        ? RELEASEBASEURL
        : DEBUGBASEURL) + 'upload';
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.fields['kind'] = params['kind'];
    request.fields['type'] = params['type'];
    request.headers['content-type'] = 'multipart/form-data';

    if (file != null) {
      print('File Existed');
      print('${file.path}');
      var pic = await http.MultipartFile.fromPath("media", file.path);
      request.files.add(pic);
    }

    var response =
        await request.send().timeout(Duration(minutes: 10), onTimeout: () {
      print('Timeout');
      return;
    });

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    print('[Uploading] $responseString');

    try {
      return json.decode(responseString);
    } catch (e) {
      return {
        'ret': 10003,
        'msg': e.toString(),
        'result': 'Internet server error'
      };
    }
  }

  void _httpResponseLog(Uri url, dynamic parameter, dynamic response) {
    log("""
    |------------------------------------------------------------------ 
    |
    |  link : ${url.toString()}
    |
    |  params : ${parameter.toString()}
    |
    |  response : ${response.toString()}
    |
    |------------------------------------------------------------------
    """);
  }
}
