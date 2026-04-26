import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_craft/core/usecase/usecase.dart';
import 'package:story_craft/features/profile/domain/usecases/get_reader_profile_usecase.dart';
import 'package:story_craft/features/profile/presentation/cubit/account/account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this._getProfile) : super(const AccountInitial());

  final GetReaderProfileUseCase _getProfile;

  Future<void> load() async {
    emit(const AccountLoading());
    final result = await _getProfile(const NoParams());
    result.fold(
      (f) => emit(AccountError(f.message)),
      (p) => emit(AccountLoaded(p)),
    );
  }
}
