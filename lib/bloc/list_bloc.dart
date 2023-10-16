import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/model.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<UpdateListEvent>(_updateList);
  }

  DataModel _model = const DataModel();

  void _updateList(UpdateListEvent event, Emitter<ListState> emit) {
    _model = _model.copyWith(
      fieldOne: event.fieldOne,
      multiFields: event.multiFields,
    );

    emit(UpdateListState(_model));
  }
}
