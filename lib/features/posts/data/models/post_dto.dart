import 'package:story_craft/features/posts/domain/entities/post.dart';

class PostDto {
  const PostDto({required this.id, required this.title});

  factory PostDto.fromJson(Map<String, dynamic> json) {
    return PostDto(id: json['id'] as int, title: json['title'] as String);
  }

  Post toEntity() => Post(id: id, title: title);

  final int id;
  final String title;
}
