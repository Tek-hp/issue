import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class FocusIndexCubit extends Cubit<int?> {
  FocusIndexCubit() : super(null);

  bool isFocused(int index) {
    return index == state;
  }

  changeFocus(int? index) {
    emit(index);
  }

  @override
  void onChange(Change<int?> change) {
    super.onChange(change);
    log('Changed focus to : $change');
  }
}
