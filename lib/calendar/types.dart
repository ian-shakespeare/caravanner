class CEventGroup {
  CEventGroup(this.id, this.name);
  String id;
  String name;
}

class CEvent {
  CEvent(this.name, this.Date, this.group);
  String name;
  String? image;
  DateTime Date;
  CEventGroup group;
}
