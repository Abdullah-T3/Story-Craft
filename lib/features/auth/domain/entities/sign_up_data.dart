class SignUpData {
  const SignUpData({
    required this.name,
    required this.email,
    required this.password,
    required this.childName,
    required this.ageCategory,
    required this.photoUrl,
    this.localPhotoPath,
  });

  final String name;
  final String email;
  final String password;
  final String childName;
  final String ageCategory;
  final String photoUrl;
  final String? localPhotoPath;

  SignUpData copyWith({
    String? name,
    String? email,
    String? password,
    String? childName,
    String? ageCategory,
    String? photoUrl,
    String? localPhotoPath,
  }) {
    return SignUpData(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      childName: childName ?? this.childName,
      ageCategory: ageCategory ?? this.ageCategory,
      photoUrl: photoUrl ?? this.photoUrl,
      localPhotoPath: localPhotoPath ?? this.localPhotoPath,
    );
  }
}
