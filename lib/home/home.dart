import "package:caravanner/theme/colors.dart";
import "package:caravanner/theme/text.dart";
import "package:flutter/material.dart";
import 'package:badges/badges.dart' as badges;

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool notifications = true;

  @override
  Widget build(BuildContext ctx) {
    return SafeArea(
        child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/purple_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Padding(
                    padding: EdgeInsets.only(right: 24.0, top: 16.0),
                    child: badges.Badge(
                        showBadge: notifications,
                        child: Icon(
                            notifications
                                ? Icons.notifications
                                : Icons.notifications_none,
                            size: 36,
                            color: Colors.white),
                        badgeStyle: badges.BadgeStyle(badgeColor: CColors.bad),
                        position: badges.BadgePosition.topEnd(top: 4, end: 6)),
                  )
                ]),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: CNextEvent(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 32.0),
                  child: CAddEvent(),
                ),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(color: Colors.black),
                )),
              ],
            )));
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
  const CNextEvent({super.key});

  @override
  State<CNextEvent> createState() => _CNextEventState();
}

class _CNextEventState extends State<CNextEvent> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: [
          CText.heading('🤩', textAlign: TextAlign.center),
          CText.heading('18 days', textAlign: TextAlign.center),
          CText.subheading('Until your next event', textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
