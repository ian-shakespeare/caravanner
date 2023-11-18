import "package:caravanner/messages/messages.dart";
import "package:supabase/supabase.dart";

void subscribeToGroupMessages(SupabaseClient supabase, Function(List<Message>) callback) {
  supabase.from("group_messages")
    .stream(primaryKey: ["id"])
    .listen((List<Map<String, dynamic>> data) {
      Future.wait(data.map((d) {
        return supabase
          .from("profiles")
          .select("first_name")
          .eq("id", d["sender_id"])
          .then((res) {
            final firstName = res[0]["first_name"];
            return Message(
              messageBody: d["message_body"],
              senderFirstName: firstName,
              createdAt: DateTime.parse(d["created_at"]),
              groupId: d["group_id"]
            );
          });
      })).then((m) => callback(m));
    });
}

void subscribeToDirectMessages(SupabaseClient supabase, Function(List<Message>) callback) {
  supabase.from("direct_messages")
    .stream(primaryKey: ["id"])
    .listen((List<Map<String, dynamic>> data) {
      Future.wait(data.map((d) {
        return supabase
          .from("profiles")
          .select("first_name")
          .eq("id", d["sender_id"])
          .then((res) {
            final firstName = res[0]["first_name"];
            return Message(
              messageBody: d["message_body"],
              senderFirstName: firstName,
              createdAt: DateTime.parse(d["created_at"]),
            );
          });
      })).then((m) => callback(m));
    });
}