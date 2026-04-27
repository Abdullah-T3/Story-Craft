import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/localization/locale_keys.g.dart';
import 'package:story_craft/core/theme/app_colors.dart';
import 'package:story_craft/core/widgets/app_loading.dart';
import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';
import 'package:story_craft/features/profile/presentation/cubit/personal_info/personal_info_cubit.dart';
import 'package:story_craft/features/profile/presentation/cubit/personal_info/personal_info_state.dart';
import 'package:story_craft/features/profile/presentation/widgets/account/avatar_badge.dart';
import 'package:story_craft/features/profile/presentation/widgets/personal_info/age_group_selector.dart';
import 'package:story_craft/features/profile/presentation/widgets/shared/screen_header.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PersonalInfoCubit>()..load(),
      child: const _PersonalInfoView(),
    );
  }
}

class _PersonalInfoView extends StatefulWidget {
  const _PersonalInfoView();

  @override
  State<_PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<_PersonalInfoView> {
  final _formKey = GlobalKey<FormState>();
  final _parentName = TextEditingController();
  final _childName = TextEditingController();
  String _ageGroup = '7-9';
  bool _hydrated = false;

  void _hydrate(ReaderProfile p) {
    if (_hydrated) return;
    _hydrated = true;
    _parentName.text = p.displayName;
    _childName.text = p.displayName;
  }

  @override
  void dispose() {
    _parentName.dispose();
    _childName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.headerBackground,
        body: SafeArea(
          child: BlocConsumer<PersonalInfoCubit, PersonalInfoState>(
            listener: (context, state) {
              if (state.savedAt != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(LocaleKeys.personalInfo_saved.tr())),
                );
              }
              if (state.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error!)),
                );
              }
              if (state.profile != null) _hydrate(state.profile!);
            },
            builder: (context, state) {
              if (state.isLoading && state.profile == null) {
                return const AppLoading();
              }
              final p = state.profile;
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 32.h),
                child: Column(
                  children: [
                    ScreenHeader(title: LocaleKeys.personalInfo_title.tr()),
                    SizedBox(height: 12.h),
                    AvatarBadge(
                      emoji: p?.avatarEmoji ?? '🐻',
                      photoUrl: p?.photoUrl,
                      size: 96,
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(LocaleKeys.personalInfo_avatar.tr()),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _Field(
                              label: LocaleKeys.personalInfo_name.tr(),
                              controller: _parentName,
                            ),
                            SizedBox(height: 14.h),
                            _Field(
                              label: LocaleKeys.personalInfo_childName.tr(),
                              controller: _childName,
                            ),
                            SizedBox(height: 18.h),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                LocaleKeys.personalInfo_ageGroup.tr(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            AgeGroupSelector(
                              value: _ageGroup,
                              onChanged: (v) => setState(() => _ageGroup = v),
                            ),
                            SizedBox(height: 28.h),
                            FilledButton(
                              onPressed: state.isSaving
                                  ? null
                                  : () {
                                      if (!(_formKey.currentState?.validate() ??
                                          false)) {
                                        return;
                                      }
                                      context.read<PersonalInfoCubit>().save(
                                        parentName: _parentName.text.trim(),
                                        childName: _childName.text.trim(),
                                        ageCategory: _ageGroup,
                                      );
                                    },
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primaryDark,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.r),
                                ),
                              ),
                              child: state.isSaving
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(LocaleKeys.personalInfo_save.tr()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.controller});
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      validator: (v) => (v == null || v.trim().isEmpty) ? label : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
