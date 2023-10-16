part of 'list_bloc.dart';

abstract class ListState {}

final class ListInitial extends ListState {}

final class UpdateListState extends ListState {
  final DataModel data;

  UpdateListState(this.data);
}
