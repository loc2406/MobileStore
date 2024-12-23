import '../../models/user.dart';
import 'account_state.dart';

class SuccessState extends AccountState {
  final User user;

  SuccessState(this.user);
}
