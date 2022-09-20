import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../entities/entities.dart';

abstract class AddAccount {
  Future<AccountEntity> add(AddAccountParams params);
}

class AddAccountParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  AddAccountParams({@required this.email, @required this.password, this.passwordConfirmation, this.name});

  @override
  List<Object> get props => [name, email, password, passwordConfirmation];
}
