import 'package:story_craft/features/profile/domain/entities/reader_profile.dart';

sealed class AccountState {
  const AccountState();
}

class AccountInitial extends AccountState {
  const AccountInitial();
}

class AccountLoading extends AccountState {
  const AccountLoading();
}

class AccountLoaded extends AccountState {
  const AccountLoaded(this.profile);
  final ReaderProfile profile;
}

class AccountError extends AccountState {
  const AccountError(this.message);
  final String message;
}
