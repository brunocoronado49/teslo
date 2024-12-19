import 'package:formz/formz.dart';

enum NameError { empty, format }

class Name  extends FormzInput<String, NameError>{
  const Name.pure() : super.pure('');
  const Name.dirty(super.value) : super.dirty();

  static final RegExp nameRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == NameError.empty ) return 'El campo es requerido';
    if ( displayError == NameError.format ) return 'Ingrese un nombre correcto';

    return null;
  }

  @override
  NameError? validator(String value) {
    if ( value.isEmpty || value.trim().isEmpty ) return NameError.empty;
    if ( !nameRegExp.hasMatch(value) ) return NameError.format;

    return null;
  }

}

