import 'package:flutter_tdd_clean_architecture/ui/helpers/i18n/strings/translations.dart';

class EnUs implements Translations {
  @override
  String get addAccount => 'Create Account';

  @override
  String get email => 'Email';

  @override
  String get enter => 'Enter';

  @override
  String get login => 'Login';

  @override
  String get password => 'password';


 
  @override
  String get msgRequiredField => 'Required field';

  @override
  String get msgInvalidField => 'Invalid field';

  @override
  String get msgInvalidCredentials => 'Invalid credentials';

  @override
  String get msgUnexpectedField => 'Unexpected error';
}
