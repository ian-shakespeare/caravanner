import "package:caravanner/auth/profile_model.dart";
import "package:caravanner/components/list.dart";
import "package:caravanner/theme/colors.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import 'package:badges/badges.dart' as badges;
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext _) {
    return Consumer<ProfileModel>(
        builder: (_, profile, __) => _HomeScreen(profile: profile));
  }
}

class _HomeScreen extends StatefulWidget {
  final ProfileModel profile;
  _HomeScreen({required this.profile});

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  final supabase = Supabase.instance.client;
  late final PostgrestTransformBuilder<dynamic> _futureData;
  late final PostgrestTransformBuilder<dynamic> _futureNotificationData;

  @override
  void initState() {
    _futureData = supabase
        .from("events")
        .select(
            "id, name, occurs_at, group:group_id!inner( group_name, group_members:group_members!group_members_group_id_fkey( member_id ))")
        .eq("group.group_members.member_id", widget.profile.id)
        .order("occurs_at");

    _futureNotificationData = supabase.from("profiles").select("""
          id,
          friend_requests!friend_requests_recipient_id_fkey(id),
          group_invitations!group_invitations_recipient_id_fkey(id)
        """).eq("id", widget.profile.id).order("created_at");
  }

  @override
  Widget build(BuildContext ctx) {
    return SafeArea(
        child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/purple_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(children: [
              FutureBuilder(
                future: _futureNotificationData,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final Map<String, dynamic> data = snapshot.data![0];
                  final List<dynamic> requests = data['friend_requests'];
                  final List<dynamic> invitations = data['group_invitations'];
                  final rids = requests.map((r) => r['id']);
                  final iids = invitations.map((r) => r['id']);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        badges.Badge(
                            showBadge:
                                (requests.isNotEmpty || invitations.isNotEmpty),
                            onTap: () {},
                            child: Icon(
                                (requests.isNotEmpty || invitations.isNotEmpty)
                                    ? Icons.notifications
                                    : Icons.notifications_none,
                                size: 36,
                                color: Colors.white),
                            badgeStyle:
                                badges.BadgeStyle(badgeColor: CColors.bad),
                            position:
                                badges.BadgePosition.topEnd(top: 4, end: 6)),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: CNextEvent(
                  futureData: _futureData,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 32.0, bottom: 16.0),
                child: CAddEvent(),
              ),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(color: Colors.black),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          FutureBuilder(
                            future: _futureData,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final List<dynamic> events = snapshot.data!;
                              final _e = events
                                  .map(
                                    (e) => CListTile(
                                      label: e['name'],
                                      sublabel: e['occurs_at'],
                                      trailing: Icon(Icons.chevron_right,
                                          color: Colors.white),
                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                        child: Image.asset(
                                            'images/google_logo.png',
                                            width: 50,
                                            height: 50),
                                      ),
                                    ),
                                  )
                                  .toList();
                              return Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CList(
                                  label: "Upcoming Events",
                                  items: _e,
                                  borders: true,
                                ),
                              ));
                            },
                          ),
                        ],
                      )))
            ])));
  }
}

class CAddEvent extends StatelessWidget {
  const CAddEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(CColors.onSurface),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Padding(
                  padding: EdgeInsets.only(right: 36.0),
                  child: Icon(Icons.calendar_today_outlined,
                      color: Colors.white, size: 36)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CText.title('Add Event', color: Colors.white),
                  CText.subtitle('Create a new event', color: Colors.white)
                ],
              ),
              const Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward,
                          color: Colors.white, size: 20)))
            ],
          ),
        ));
  }
}

class CNextEvent extends StatefulWidget {
  final PostgrestTransformBuilder futureData;
  const CNextEvent({super.key, required this.futureData});

  @override
  State<CNextEvent> createState() => _CNextEventState();
}

class _CNextEventState extends State<CNextEvent> {
  late final int daysUntil;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: FutureBuilder(
        future: widget.futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<dynamic> events = snapshot.data!;
          final DateTime? firstEventDate =
              DateTime.parse(events[0]['occurs_at']);
          DateTime? currentDate = DateTime.now();
          daysUntil = firstEventDate?.difference(currentDate).inDays ?? 0;
          bool eventsExist = events[0].isNotEmpty;
          return Column(
            children: [
              CText.heading(
                  eventsExist
                      ? daysUntil > 1
                          ? '🤩'
                          : '🤠'
                      : '😔',
                  textAlign: TextAlign.center),
              CText.heading(
                  eventsExist
                      ? daysUntil > 1
                          ? daysUntil.toString() + " days"
                          : 'Event Today'
                      : 'No Events',
                  textAlign: TextAlign.center),
              CText.subheading(
                  eventsExist
                      ? daysUntil > 1
                          ? 'Until your next event'
                          : 'Have a great time!'
                      : 'Go to your Calender\n to make one!',
                  textAlign: TextAlign.center)
            ],
          );
        },
      ),
    );
  }
}
