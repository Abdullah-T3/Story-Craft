import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_cubit.dart';
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
          title: Text('appTitle'.tr()),
          actions: [
            IconButton(
              tooltip: 'toggleTheme'.tr(),
              onPressed: () => context.read<ThemeCubit>().toggleLightDark(),
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            ),
            PopupMenuButton<Locale?>(
              onSelected: (locale) {
                context.read<LocaleCubit>().setLocale(locale);
                if (locale == null) {
                  context.resetLocale();
                  return;
                }
                context.setLocale(locale);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: const Locale('en'),
                  child: Text('languageEnglish'.tr()),
                ),
                PopupMenuItem(
                  value: const Locale('ar'),
                  child: Text('languageArabic'.tr()),
                ),
                PopupMenuItem(value: null, child: Text('languageSystem'.tr())),
              ],
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('counterMessage'.tr()),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'samplePosts'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
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
                        padding: const EdgeInsets.all(16),
                        itemCount: posts.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return ListTile(
                            dense: true,
                            leading: CircleAvatar(child: Text('${post.id}')),
                            title: Text(post.title),
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
          tooltip: 'incrementTooltip'.tr(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
