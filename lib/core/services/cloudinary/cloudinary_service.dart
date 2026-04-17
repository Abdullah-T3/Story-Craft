import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_craft/core/services/cloudinary/cloudinary_config.dart';

class CloudinaryUploadException implements Exception {
  const CloudinaryUploadException(this.message);
  final String message;

  @override
  String toString() => message;
}

class CloudinaryService {
  CloudinaryService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> uploadImage(File file) async {
    final request = http.MultipartRequest('POST', CloudinaryConfig.unsignedUploadUri)
      ..fields['upload_preset'] = CloudinaryConfig.uploadPreset
      ..fields['folder'] = CloudinaryConfig.folder
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final streamed = await _client.send(request);
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw CloudinaryUploadException(
        'Cloudinary upload failed (${response.statusCode}): ${response.body}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final url = body['secure_url'] as String?;
    if (url == null || url.isEmpty) {
      throw const CloudinaryUploadException('Cloudinary response missing secure_url');
    }
    return url;
  }
}
