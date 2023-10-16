part of 'list_bloc.dart';

abstract class ListEvent {}

class UpdateListEvent extends ListEvent {
  final String? fieldOne;
  final List<String>? multiFields;

  UpdateListEvent({this.fieldOne, this.multiFields});
}
