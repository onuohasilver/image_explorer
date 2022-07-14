import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:image_explorer/core/core.dart';
import 'package:image_explorer/services/coco_service/coco_service.dart';

class CocoServiceImpl extends CocoService {
  CocoServiceImpl([this.network = const Network()]);
  final Network network;

  @override
  Future<Map> getCategories() async {
    http.Response response = await network.get(Api.categories);
    /*
    Logic gotten from inspection of cocodataset web element responses
    */
    List<String> bodyList = response.body.split("var").sublist(3, 7);
    Map<String, dynamic> bodyResponse = {};
    for (var element in bodyList) {
      bodyResponse[element.split("=").first.trim()] =
          element.split("=").last.replaceAll("'", "");
    }
    // log(bodyResponse.toString());
    return bodyResponse;
  }

  @override
  Future<List> getImageResults(List categoryIds) async {
    http.Response response = await network.post(Api.imageRequests, body: {
      'querytype': 'getImages',
      'image_ids': ["65604"]
    });
    log(response.body);
    return jsonDecode(response.body);
  }
}
