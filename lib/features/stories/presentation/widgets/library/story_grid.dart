import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/features/stories/domain/entities/story.dart';
import 'package:story_craft/features/stories/presentation/widgets/library/story_card.dart';

class StoryGrid extends StatelessWidget {
  const StoryGrid({super.key, required this.stories});

  final List<Story> stories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: stories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (_, i) {
        final story = stories[i];
        return StoryCard(
          story: story,
          onTap: () => context.pushNamed(
            AppRoutes.storyDetailsPath,
            arguments: story.id,
          ),
        );
      },
    );
  }
}
