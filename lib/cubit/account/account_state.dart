import 'package:mobile_store/cubit/account/no_logged_in_state.dart';
import 'package:mobile_store/cubit/account/success_state.dart';
import 'package:mobile_store/cubit/account/token_has_expired_state.dart';

import '../../models/user.dart';
import 'error_state.dart';
import 'initial_state.dart';
import 'loading_state.dart';

class AccountState {
  const AccountState();

  factory AccountState.initial() => InitialState();

  factory AccountState.loading() => LoadingState();

  factory AccountState.success(User user) => SuccessState(user);

  factory AccountState.error(String errorMessage) => ErrorState(errorMessage);

  factory AccountState.noLoggedIn() => NoLoggedInState();

  factory AccountState.tokenHasExpired() =>TokenHasExpiredState();
}
