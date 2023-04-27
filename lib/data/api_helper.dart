import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:planttag/models/detect_species_model.dart';
import 'package:planttag/models/gbif_model.dart';

class DioClient {
  final Dio _dio = Dio();
  static final instance = DioClient();

  DioClient() {
    _dio.interceptors
      .add(TokenInterceptor());
  }

  // Future<dynamic> getCharacter(String character) async {
  //   String baseUrl = 'https://www.omdbapi.com/?t=$character&apikey=d7617849';

  //   var url = Uri.parse(baseUrl);

  //   var response = await _dio.get(url);

  //   if (response.statusCode == 200) {
  //     if (response.body.isNotEmpty) {
  //       var responseBody = jsonDecode(response.body);
  //       if (responseBody["synonym"] == "False") {
  //         print("Failed ");
  //       } else {
  //         List<String> genrelist = responseBody["Genre"].split(",");
  //         List<String> lang = responseBody["Language"].split(",");
  //         print(responseBody["Poster"].runtimeType);
  //         print(responseBody);
  //       }
  //     } else {
  //       print("Failed");
  //       //throw exception and catch it in UI
  //     }
  //   }
  // }


  Future<DetectSpeciesModel?> detectSpecies(List<XFile>? pickedFile, String organ) async {
    DetectSpeciesModel? detectSpeciesModel;
    try {
      String fileName = pickedFile![0].name;
      String? mimeType = lookupMimeType(fileName);
      String mimee = mimeType?.split('/')[0] ?? "";
      String type = mimeType?.split('/')[1] ?? "";

      print("$mimeType $mimee $type");

      _dio.options.headers["Content-Type"] = "multipart/form-data";
      FormData formData = FormData.fromMap({
        'images':await MultipartFile.fromFile(pickedFile[0].path,
            filename: fileName, contentType: MediaType(mimee, type)),
        'organs': organ
      });
      Response response = await _dio
          .post('https://my-api.plantnet.org/v2/identify/all?api-key=2b10R7trgfZpo3709VUcvtmwc&include-related-images=true', data: formData);
         // print(response.toString());
      detectSpeciesModel = DetectSpeciesModel.fromJson(response.data);
    } on DioError catch (e) {
      if (e.response != null) {
      } else {}
      return null;
    }
    return detectSpeciesModel;
  }

  Dio get dio => _dio;
}

class TokenInterceptor extends Interceptor {
  //String? authToken = GetStorage().read('authToken');
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //options.headers["authorization"] = "Bearer $authToken";
    print(options.headers);
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}'
            'DATA => ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    print(err.response?.data);
    return super.onError(err, handler);
  }
}