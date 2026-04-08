import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/theme/theme_cubit.dart';
import 'package:story_craft/core/widgets/app_error_view.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:story_craft/features/posts/presentation/cubit/posts_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _increment() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PostsCubit>()..load(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          toolbarHeight: 56.h,
          title: Text('Story Craft', style: TextStyle(fontSize: 18.sp)),
          actions: [
            IconButton(
              tooltip: 'Toggle theme',
              onPressed: () => context.read<ThemeCubit>().toggleLightDark(),
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Text(
                    'You have pushed the button this many times:',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(fontSize: 28.sp),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Sample posts',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<PostsCubit, PostsState>(
                builder: (context, state) {
                  return switch (state) {
                    PostsInitial() || PostsLoading() => const AppLoading(),
                    PostsLoaded(:final posts) => RefreshIndicator(
                      onRefresh: () => context.read<PostsCubit>().load(),
                      child: ListView.separated(
                        padding: EdgeInsets.all(16.w),
                        itemCount: posts.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                            ),
                            dense: true,
                            leading: CircleAvatar(
                              radius: 18.r,
                              child: Text(
                                '${post.id}',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                            title: Text(
                              post.title,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          );
                        },
                      ),
                    ),
                    PostsError(:final message) => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        AppErrorView(
                          message: message,
                          onRetry: () => context.read<PostsCubit>().load(),
                        ),
                      ],
                    ),
                  };
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _increment,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
