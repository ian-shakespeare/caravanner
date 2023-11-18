import "package:caravanner/components/bottom_modal.dart";
import "package:caravanner/components/list.dart";
import "package:caravanner/components/screen.dart";
import "package:caravanner/theme/colors.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:table_calendar/table_calendar.dart";
import '../theme/text.dart';

Map<DateTime, List<dynamic>> kEvents = {
  DateUtils.dateOnly(DateTime.now()): [
    [
      "https://media.gettyimages.com/id/1027300542/photo/st-catharines-collegiate-institute-and-vocational-school.jpg?s=2048x2048&w=gi&k=20&c=Orw0kjpPLAOmWECxg864JkLzqDsSi-Mzefiq1ZvbXAQ=",
      "GroupA",
      "Palace"
    ],
    [
      "https://media.gettyimages.com/id/1027300542/photo/st-catharines-collegiate-institute-and-vocational-school.jpg?s=2048x2048&w=gi&k=20&c=Orw0kjpPLAOmWECxg864JkLzqDsSi-Mzefiq1ZvbXAQ=",
      "GroupA",
      "Cathedral"
    ]
  ],
  DateUtils.dateOnly(DateTime(2023, 11, 21)): [
    [
      "https://media.gettyimages.com/id/1027300542/photo/st-catharines-collegiate-institute-and-vocational-school.jpg?s=2048x2048&w=gi&k=20&c=Orw0kjpPLAOmWECxg864JkLzqDsSi-Mzefiq1ZvbXAQ=",
      "GroupC",
      "Potala Palace"
    ]
  ],
  DateUtils.dateOnly(DateTime(2023, 11, 30)): [
    [
      "https://media.gettyimages.com/id/1027300542/photo/st-catharines-collegiate-institute-and-vocational-school.jpg?s=2048x2048&w=gi&k=20&c=Orw0kjpPLAOmWECxg864JkLzqDsSi-Mzefiq1ZvbXAQ=",
      "GroupA",
      "Museum"
    ],
    [
      "https://media.gettyimages.com/id/1027300542/photo/st-catharines-collegiate-institute-and-vocational-school.jpg?s=2048x2048&w=gi&k=20&c=Orw0kjpPLAOmWECxg864JkLzqDsSi-Mzefiq1ZvbXAQ=",
      "GroupB",
      "Bar Hopping"
    ],
    [
      "https://media.gettyimages.com/id/1027300542/photo/st-catharines-collegiate-institute-and-vocational-school.jpg?s=2048x2048&w=gi&k=20&c=Orw0kjpPLAOmWECxg864JkLzqDsSi-Mzefiq1ZvbXAQ=",
      "GroupA",
      "Street Festival"
    ],
    [
      "https://media.gettyimages.com/id/1027300542/photo/st-catharines-collegiate-institute-and-vocational-school.jpg?s=2048x2048&w=gi&k=20&c=Orw0kjpPLAOmWECxg864JkLzqDsSi-Mzefiq1ZvbXAQ=",
      "GroupA",
      "Boat Tour"
    ],
    [
      "https://media.gettyimages.com/id/1027300542/photo/st-catharines-collegiate-institute-and-vocational-school.jpg?s=2048x2048&w=gi&k=20&c=Orw0kjpPLAOmWECxg864JkLzqDsSi-Mzefiq1ZvbXAQ=",
      "GroupC",
      "Club"
    ],
    [
      "https://media.gettyimages.com/id/1027300542/photo/st-catharines-collegiate-institute-and-vocational-school.jpg?s=2048x2048&w=gi&k=20&c=Orw0kjpPLAOmWECxg864JkLzqDsSi-Mzefiq1ZvbXAQ=",
      "GroupD",
      "Midnight Mass"
    ],
  ],
};

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  Function(DateTime, DateTime) _onDaySelected(BuildContext ctx) {
    return (DateTime selectedDay, DateTime focusedDay) {
      final events =
          kEvents[DateUtils.dateOnly(selectedDay.add(Duration(days: -3)))];
      if (events == null) return;

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
                  items: events
                      .map(
                        (value) => CListTile(
                          label: value[2],
                          sublabel: value[1],
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.network(
                              value[0],
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

  List<dynamic> _getEventsForDay(DateTime date) {
    // Implementation example
    return kEvents[DateUtils.dateOnly(date.add(const Duration(days: -3)))] ?? [];
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
              eventLoader: _getEventsForDay,
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
            )
          ],
        ),
      ),
    );
  }
}
