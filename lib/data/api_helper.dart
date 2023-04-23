import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:planttag/models/detect_species_model.dart';

class DioClient {
  final Dio _dio = Dio();
  static final instance = DioClient();

  DioClient() {
    _dio.interceptors
      .add(TokenInterceptor());
  }

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