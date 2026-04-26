import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/di/service_locator.dart';
import 'package:story_craft/core/services/router/extantions.dart';
import 'package:story_craft/core/widgets/main_scaffold.dart';
import 'package:story_craft/features/auth/domain/entities/sign_up_data.dart';
import 'package:story_craft/features/auth/sign_up/presentation/cubit/sign_up_cubit.dart';
import 'package:story_craft/features/auth/sign_up/presentation/cubit/sign_up_state.dart';
import 'package:story_craft/features/auth/sign_up/presentation/widgets/sign_up_appBar.dart';
import 'package:story_craft/features/auth/sign_up/presentation/widgets/sign_up_step_indicator.dart';
import 'package:story_craft/features/auth/sign_up/presentation/widgets/sign_up_step_one.dart';
import 'package:story_craft/features/auth/sign_up/presentation/widgets/sign_up_step_two.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SignUpCubit>(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView();

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _childNameController = TextEditingController();

  String ageCategory = '';
  bool agreed = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickProfileImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (picked != null) {
      setState(() => _profileImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      child: BlocListener<SignUpCubit, SignUpState>(
        listener: _handleSignUpState,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SignUpAppBar(onBackPressed: () {
                    final cubit = context.read<SignUpCubit>();
                    final state = cubit.state;
                    if (state is SignUpStepState && state.step == 1) {
                      cubit.goToPreviousStep(); 
                    } else {
                      context.pop(); 
                    }
                  },
                ),
                SizedBox(height: 24.h),
                BlocBuilder<SignUpCubit, SignUpState>(
                  builder: (context, state) {
                    int currentStep = 0;
                    if (state is SignUpStepState) {
                      currentStep = state.step;
                    }
                    return SignUpStepIndicator(currentStep: currentStep);
                  },
                ),

                SizedBox(height: 44.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Form(
                    key: _formKey,
                    child: BlocBuilder<SignUpCubit, SignUpState>(
                      builder: (context, state) {
                        
                        if (state is SignUpStepState && state.step == 0) {
                          return SignUpStepOne(
                            nameController: _nameController,
                            emailController: _emailController,
                            passwordController: _passwordController,
                          );
                        }

                        return SignUpStepTwo(
                          childNameController: _childNameController,
                          agreed: agreed,
                          selectedAge: ageCategory,
                          onAgeCategorySelected: (value) {
                            setState(() => ageCategory = value);
                          },
                          onAgreementToggled: () {
                            setState(() => agreed = !agreed);
                          },
                          onSubmit: _onSubmit,
                          profileImage: _profileImage,
                          onPickImage: _pickProfileImage,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!agreed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('يجب الموافقة على الشروط')),
        );
        return;
      }

      context.read<SignUpCubit>().signUp(
        SignUpData(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
          childName: _childNameController.text,
          ageCategory: ageCategory,
          photoUrl: '',
          localPhotoPath: _profileImage?.path,
        ),
      );
    }
  }

  void _handleSignUpState(BuildContext context, SignUpState state) {
    if (state is SignUpSuccess) {
      context.pushNamedAndRemoveUntil(
        AppRoutes.mainLayoutPath,
        predicate: (_) => false,
      );
    } else if (state is SignUpError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(state.message),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
    }
  }
}
