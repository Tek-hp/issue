class DataModel {
  final String? fieldOne;
  final List<String>? multiFields;

  const DataModel({
    this.fieldOne = '',
    this.multiFields = const [],
  });

  DataModel copyWith({String? fieldOne, List<String>? multiFields}) {
    return DataModel(
      fieldOne: fieldOne ?? this.fieldOne,
      multiFields: multiFields ?? this.multiFields,
    );
  }
}
