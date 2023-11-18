import "package:caravanner/auth/profile_model.dart";
import "package:caravanner/calendar/types.dart";
import "package:caravanner/components/bottom_modal.dart";
import "package:caravanner/components/list.dart";
import "package:caravanner/components/new_event.dart";
import "package:caravanner/theme/colors.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import 'package:badges/badges.dart' as badges;
import "package:intl/intl.dart";
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
  List<CEvent> events = [];

  @override
  @override
  void initState() {
    supabase
        .from("profiles")
        .select(
          """
            id,
            group_members (
              groups (
                id,
                group_name,
                events (
                  id,
                  name,
                  occurs_at
                )
              )
            )
          """,
        )
        .eq("id", widget.profile.id)
        .then((res) {
          return <Map<String, dynamic>>[...res.first["group_members"]]
              .map((e) {
                return <Map<String, dynamic>>[
                  e["groups"],
                ].map((g) {
                  return <dynamic>[...g["events"]].map(
                    (e) {
                      return CEvent(
                        id: e['id'],
                        name: e["name"],
                        date: DateTime.parse(e["occurs_at"]),
                        group: CEventGroup(
                          g["id"],
                          g["group_name"],
                        ),
                      );
                    },
                  ).toList();
                }).toList();
              })
              .toList()
              .fold(<List<CEvent>>[], (acc, e) => [...acc, ...e])
              .fold(<CEvent>[], (acc, e) => [...acc, ...e])
              .toList();
        })
        .then((d) => setState(() {
              events = d;
            }));
    super.initState();
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    badges.Badge(
                        showBadge:
                            true //(requests.isNotEmpty || invitations.isNotEmpty),
                        ,
                        onTap: () {},
                        child: Icon(
                            true //(requests.isNotEmpty || invitations.isNotEmpty)
                                ? Icons.notifications
                                : Icons.notifications_none,
                            size: 36,
                            color: Colors.white),
                        badgeStyle: badges.BadgeStyle(badgeColor: CColors.bad),
                        position: badges.BadgePosition.topEnd(top: 4, end: 6)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: CNextEvent(events: events),
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
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: events.isNotEmpty
                                  ? CList(
                                      label: "Upcoming Events",
                                      items: events
                                          .map(
                                            (e) => CListTile(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  showDragHandle: true,
                                                  useSafeArea: true,
                                                  backgroundColor:
                                                      CColors.background,
                                                  builder: (modalCtx) {
                                                    return BottomModal(
                                                        child: CNewEvent(
                                                            initial: e,
                                                            onSubmit: (event) {
                                                              setState(() {
                                                                events
                                                                    .remove(e);
                                                                events = [
                                                                  event,
                                                                  ...events
                                                                ];
                                                              });
                                                            }));
                                                  },
                                                );
                                              },
                                              label: e.name,
                                              sublabel:
                                                  DateFormat("EEEE, d MMM yyyy")
                                                      .format(e.date),
                                              trailing: Icon(
                                                  Icons.chevron_right,
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
                                          .toList(),
                                      borders: true,
                                    )
                                  : null,
                            ))
                          ])))
            ])));
  }
}

class CAddEvent extends StatefulWidget {
  const CAddEvent({super.key});

  @override
  State<CAddEvent> createState() => _CAddEventState();
}

class _CAddEventState extends State<CAddEvent> {
  final List<CEvent> events = [];

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
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            useSafeArea: true,
            backgroundColor: CColors.background,
            builder: (modalCtx) {
              return BottomModal(child: CNewEvent(onSubmit: (event) {
                setState(() {
                  events.add(event);
                });
              }));
            },
          );
        },
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
  List<CEvent> events = [];
  CNextEvent({super.key, required this.events});

  @override
  State<CNextEvent> createState() => _CNextEventState();
}

class _CNextEventState extends State<CNextEvent> {
  @override
  Widget build(BuildContext context) {
    int daysUntil = 0;
    DateTime? currentDate = DateTime.now();
    daysUntil = widget.events.isNotEmpty
        ? widget.events[0].date.difference(currentDate).inDays
        : 999;
    return Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            CText.heading(
                widget.events.isNotEmpty
                    ? daysUntil > 1
                        ? '🤩'
                        : '🤠'
                    : '😔',
                textAlign: TextAlign.center),
            CText.heading(
                widget.events.isNotEmpty
                    ? daysUntil > 1
                        ? daysUntil.toString() + " days"
                        : 'Event Today'
                    : 'No Events',
                textAlign: TextAlign.center),
            CText.subheading(
                widget.events.isNotEmpty
                    ? daysUntil > 1
                        ? 'Until your next event'
                        : 'Have a great time!'
                    : 'Go to your Calender\n to make one!',
                textAlign: TextAlign.center)
          ],
        ));
  }
}
