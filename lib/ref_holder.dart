import 'package:flutter_riverpod/flutter_riverpod.dart';

class DummyNotifier extends Notifier<bool> {
  @override
  bool build() {
     refHolder = RefHolder._(ref);
    return true;
  }
}

final dummyProvider = NotifierProvider<DummyNotifier, bool>(() {
  return DummyNotifier();
});

late RefHolder refHolder;

class RefHolder {
   final Ref _ref;
   RefHolder._(this._ref);

   get ref {
    return _ref;
   }
}