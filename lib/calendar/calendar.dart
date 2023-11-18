import "package:caravanner/auth/profile_model.dart";
import "package:caravanner/calendar/types.dart";
import "package:caravanner/components/bottom_modal.dart";
import "package:caravanner/components/list.dart";
import "package:caravanner/components/screen.dart";
import "package:caravanner/theme/colors.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:table_calendar/table_calendar.dart";
import "../components/new_event.dart";
import '../theme/text.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileModel>(
        builder: (ctx, profile, _) => _CalendarScreen(profile: profile));
  }
}

class _CalendarScreen extends StatefulWidget {
  const _CalendarScreen({required this.profile});

  final ProfileModel profile;

  @override
  State<_CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<_CalendarScreen> {
  final supabase = Supabase.instance.client;

  List<CEvent> events = [];

  Function() _onAddClicked(BuildContext context) {
    return () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        useSafeArea: true,
        backgroundColor: CColors.background,
        builder: (modalCtx) {
          return BottomModal(child: CNewEvent(onCreate: (name, date, group) {
            setState(() {
              events.add(CEvent(name, date, group));
            });
          }));
        },
      );
    };
  }

  Function(DateTime, DateTime) _onDaySelected(BuildContext ctx) {
    return (DateTime selectedDay, DateTime focusedDay) {
      final dayEvents = events.where((element) =>
          DateUtils.dateOnly(element.Date) == DateUtils.dateOnly(selectedDay));
      if (events.isEmpty) return;

      final formattedDate = DateFormat("EEEE, d MMM `yy").format(selectedDay);
      showModalBottomSheet(
        context: ctx,
        isScrollControlled: true,
        showDragHandle: true,
        useSafeArea: true,
        backgroundColor: CColors.background,
        builder: (modalCtx) {
          return BottomModal(
            child: Column(
              children: [
                CText.title(formattedDate),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: CList(
                  label:
                      "${events.length} Event${events.length > 1 ? "s" : ""}",
                  borders: true,
                  items: dayEvents
                      .map(
                        (value) => CListTile(
                          label: value.name,
                          sublabel: value.group.name,
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: value.image == null
                                ? const Icon(
                                    Icons.image,
                                    size: 50,
                                  )
                                : Image.network(
                                    value.image!,
                                    fit: BoxFit.fill,
                                    width: 50,
                                    height: 50,
                                  ),
                          ),
                        ),
                      )
                      .toList(),
                ))
              ],
            ),
          );
        },
      );
    };
  }

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
                        e["name"],
                        DateTime.parse(e["occurs_at"]),
                        CEventGroup(
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
  Widget build(BuildContext context) {
    return Screen(
      headerCenter: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CText.subheading("Calendar"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TableCalendar(
              eventLoader: (DateTime date) => events
                  .where((element) =>
                      DateUtils.dateOnly(element.Date) ==
                      DateUtils.dateOnly(date))
                  .toList(),
              onDaySelected: _onDaySelected(context),
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
              sixWeekMonthsEnforced: true,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: CColors.white),
              ),
              weekNumbersVisible: false,
              calendarStyle: const CalendarStyle(
                defaultTextStyle: TextStyle(color: CColors.white),
              ),
              availableCalendarFormats: const {CalendarFormat.month: "Month"},
              rangeSelectionMode: RangeSelectionMode.toggledOff,
              headerStyle: HeaderStyle(
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: CColors.white,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: CColors.white,
                ),
                titleTextStyle: GoogleFonts.rubik(color: CColors.white),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: CColors.interactive,
                onPressed: _onAddClicked(context),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
