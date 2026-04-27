import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/features/home/create/domain/story_page_draft.dart';
import 'package:story_craft/features/home/create/presentation/widgets/editor_buttons.dart';
import 'package:story_craft/features/home/create/presentation/widgets/story_page_card.dart';
import 'package:story_craft/features/home/create/presentation/widgets/text_editor_toolbar.dart';
import 'package:story_craft/features/home/create/presentation/widgets/page_navigation_bar.dart';

class StoryPagesEditorScreen extends StatefulWidget {
  const StoryPagesEditorScreen({super.key});

  @override
  State<StoryPagesEditorScreen> createState() => _StoryPagesEditorScreenState();
}

class _StoryPagesEditorScreenState extends State<StoryPagesEditorScreen> {
  final List<StoryPageDraft> _pages = [
    StoryPageDraft(controller: TextEditingController()),
  ];

  int _activePageIndex = 0;
  int selectedIndex = -1;

  bool showTextToolbar = false;
  TextAlign currentAlign = TextAlign.right;
  bool isBold = false;
  Color textColor = Colors.black;

  void _addNewPage() {
    setState(() {
      _pages.add(StoryPageDraft(controller: TextEditingController()));
      _activePageIndex = _pages.length - 1;
    });
  }

  void _toggleTextToolbar() {
    setState(() {
      showTextToolbar = !showTextToolbar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'صفحات القصة',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.onPrimaryContainer,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              PageNavigationBar(
                currentPage: _activePageIndex + 1,
                pageCount: _pages.length,
                onPrevious: () {
                  if (_activePageIndex > 0) {
                    setState(() => _activePageIndex--);
                  }
                },
                onNext: () {
                  if (_activePageIndex < _pages.length - 1) {
                    setState(() => _activePageIndex++);
                  }
                },
              ),
              Expanded(
                child: PageView.builder(
                  controller: PageController(initialPage: _activePageIndex),
                  onPageChanged: (index) {
                    setState(() {
                      _activePageIndex = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      child: StoryPageCard(
                        page: page,
                        index: index,
                        onTap: () => setState(() {
                          _activePageIndex = index;
                        }),
                      ),
                    );
                  },
                ),
              ),
              if (showTextToolbar)
                TextEditorToolbar(
                  onBold: () {
                    setState(() {
                      isBold = !isBold;
                    });
                  },
                  onAlignLeft: () {
                    setState(() {
                      currentAlign = TextAlign.left;
                    });
                  },
                  onAlignCenter: () {
                    setState(() {
                      currentAlign = TextAlign.center;
                    });
                  },
                  onAlignRight: () {
                    setState(() {
                      currentAlign = TextAlign.right;
                    });
                  },
                  onColor: () {
                    setState(() {
                      textColor = Colors.red;
                    });
                  },
                ),

              EditorButtons(
                onAddPage: _addNewPage,
                onEditText: _toggleTextToolbar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
