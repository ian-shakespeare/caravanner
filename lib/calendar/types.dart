class CEventGroup {
  CEventGroup(this.id, this.name);
  String id;
  String name;
}

class CEvent {
  CEvent(
      {required this.name, required this.date, required this.group, this.id});
  String? id;
  String name;
  String? image;
  DateTime date;
  CEventGroup group;
}
