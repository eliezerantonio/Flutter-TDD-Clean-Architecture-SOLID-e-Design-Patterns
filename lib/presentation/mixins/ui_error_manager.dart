import 'package:flutter_tdd_clean_architecture/ui/helpers/errors/ui_error.dart';
import 'package:get/get.dart';

 mixin UIErrorManager{

  final _mainError =Rx<UIError>(null);
  Stream<UIError> get mainErrorStream =>_mainError.stream;
  set mainError(UIError value)=>_mainError.value = value;
}