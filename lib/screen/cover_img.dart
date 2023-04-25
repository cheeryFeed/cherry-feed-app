import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:cherry_feed/utils/api_host.dart';
import 'package:cherry_feed/utils/token_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class CoverImg extends StatefulWidget {
  final void Function(int?) onImageUploaded;

  const CoverImg({Key? key, required this.onImageUploaded}) : super(key: key);

  @override
  _CoverImgState createState() => _CoverImgState();
}

class _CoverImgState extends State<CoverImg> {
  File? _image;
  late String _accessToken;

  @override
  void initState() {
    super.initState();
    _initWidget();
  }
  Future<void> _initWidget() async {
    final tokenProvider = TokenProvider();
    await tokenProvider.init();
    final token = await tokenProvider.getAccessToken();

    setState(() {
      _accessToken = token.toString();
    });
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final response = await uploadFileToServer(File(pickedFile.path));
      if (response != null) {
        widget.onImageUploaded(response);
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  Future<http.MultipartFile> getMultipartFileFromImageFile(File file) async {
    final filename = file.path.split('/').last;
    final mimeType = lookupMimeType(file.path);
    final stream = StreamView<List<int>>(file.openRead());
    final length = await file.length();

    return http.MultipartFile(
      'image',
      stream,
      length,
      filename: filename,
      contentType: MediaType.parse(mimeType!),
    );
  }

  Future<int?> uploadFileToServer(File file) async {
    final url = Uri.parse('${ApiHost.API_HOST_DEV}/api/v1/file/file-system');
    final request = http.MultipartRequest('POST', url);
    final multipartFile = await getMultipartFileFromImageFile(file);
    request.files.add(multipartFile);
    final token = _accessToken;
    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();
    if (response.statusCode == 200) {
      final jsonResponse = await response.stream.bytesToString(utf8);
      final parsedResponse = json.decode(jsonResponse);
      print(parsedResponse);
      return parsedResponse['fileId'];
    } else {
      throw Exception('Failed to upload file');
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _getImageFromGallery,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          image: _image == null
              ? null
              : DecorationImage(
            image: FileImage(_image!),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera_back_outlined,
                size: 32,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                '커버사진 변경',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class ImageUploadResponse {
  final String id;
  final String url;

  ImageUploadResponse(this.id, this.url);
}