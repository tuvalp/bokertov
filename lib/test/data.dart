class Data {
  int id;
  DateTime time;
  String note;
  bool isActive;

  Data(
      {required this.id,
      required this.isActive,
      required this.note,
      required this.time});
}

List<Data> data = [
  Data(
    id: 1,
    time: DateTime.now(),
    note: "note 1",
    isActive: true,
  ),
  Data(
    id: 2,
    time: DateTime.now(),
    note: "note 2",
    isActive: false,
  ),
  Data(
    id: 3,
    time: DateTime.now(),
    note: "note 3",
    isActive: true,
  ),
];
