import 'dart:async';

mixin ControllerFields {
  final validateField =
      StreamTransformer<String, String>.fromHandlers(handleData: (field, sink) {
    if (field.isEmpty) {
      sink.addError("This field can't be empty.");
    } else {
      sink.add(field);
    }
  });
  final validatePassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (field, sink) {
    if (field.length < 6) {
      sink.addError("Password needs 6 characters at least.");
    } else {
      sink.add(field);
    }
  });
}
