class DirectMessage {
  final String id;
  final DateTime createdAt;
  final String senderId;
  final String messageBody;

  DirectMessage({
    required this.id,
    required this.createdAt,
    required this.senderId,
    required this.messageBody,
  });

  factory DirectMessage.fromJson(Map<String, dynamic> json) => DirectMessage(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    senderId: json["senderId"],
    messageBody: json["messageBody"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "senderId": senderId,
    "messageBody": messageBody,
  };
}

class GroupMessage {
  final String id;
  final DateTime createdAt;
  final String groupId;
  final String messageBody;

  GroupMessage({
    required this.id,
    required this.createdAt,
    required this.groupId,
    required this.messageBody,
  });

  factory GroupMessage.fromJson(Map<String, dynamic> json) => GroupMessage(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    groupId: json["groupId"],
    messageBody: json["messageBody"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "groupId": groupId,
    "messageBody": messageBody,
  };
}
