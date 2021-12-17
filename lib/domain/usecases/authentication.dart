import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class Authentication {
  Future<AccountEntity> auth(Authenticationparams params);
}

class Authenticationparams {
  final String email;
  final String secret;

  Authenticationparams(this.email, this.secret);
}
