class SignUpData {
  const SignUpData({
    required this.name,
    required this.email,
    required this.password,
    required this.childName,
    required this.ageCategory,
    required this.photoUrl,
  });

  final String name;
  final String email;
  final String password;
  final String childName;
  final String ageCategory;
  final String photoUrl;

  SignUpData copyWith({
    String? name,
    String? email,
    String? password,
    String? childName,
    String? ageCategory,
    String? photoUrl,
  }) {
    return SignUpData(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      childName: childName ?? this.childName,
      ageCategory: ageCategory ?? this.ageCategory,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
