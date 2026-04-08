import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_craft/app/story_craft_app.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/error/failures.dart';
import 'package:story_craft/features/posts/domain/entities/post.dart';
import 'package:story_craft/features/posts/domain/repositories/posts_repository.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await configureDependencies();
    getIt.unregister<PostsRepository>();
    getIt.registerLazySingleton<PostsRepository>(() => _FakePostsRepository());

    await tester.pumpWidget(const StoryCraftApp());
    await tester.pumpAndSettle();

    expect(find.text('Test post'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

final class _FakePostsRepository implements PostsRepository {
  @override
  Future<AppResult<List<Post>>> getPosts() async {
    return right(const [Post(id: 42, title: 'Test post')]);
  }
}
