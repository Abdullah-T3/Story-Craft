class CloudinaryConfig {
  const CloudinaryConfig._();

  static const String cloudName = 'da7lxmvto';
  static const String uploadPreset = 'flutter_upload_preset';
  static const String folder = 'story_craft/users';

  static Uri get unsignedUploadUri =>
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
}
