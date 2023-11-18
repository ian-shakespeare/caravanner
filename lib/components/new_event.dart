import 'package:caravanner/auth/profile_model.dart';
import 'package:caravanner/calendar/types.dart';
import 'package:caravanner/components/popup_menu.dart';
import 'package:caravanner/components/text_input.dart';
import 'package:caravanner/theme/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/colors.dart';

class CNewEvent extends StatelessWidget {
  const CNewEvent({super.key, required this.onSubmit, this.initial});
  final void Function(CEvent) onSubmit;
  final CEvent? initial;

  @override
  Widget build(BuildContext _) {
    return Consumer<ProfileModel>(
        builder: (ctx, profile, _) => _CNewEvent(
              profile: profile,
              onSubmit: onSubmit,
              initial: initial,
            ));
  }
}

class _CNewEvent extends StatefulWidget {
  const _CNewEvent(
      {required this.profile, required this.onSubmit, this.initial});
  final CEvent? initial;
  final void Function(CEvent) onSubmit;
  final ProfileModel profile;

  @override
  State<_CNewEvent> createState() => _CNewEventState();
}

class _CNewEventState extends State<_CNewEvent> {
  final TextEditingController _nameInputController = TextEditingController();
  final supabase = Supabase.instance.client;

  String? name;
  DateTime date = DateTime.now();
  CEventGroup? group;

  List<CEventGroup> groups = [];

  @override
  void initState() {
    if (widget.initial != null) {
      name = widget.initial!.name;
      date = widget.initial!.date;
      group = widget.initial!.group;
      _nameInputController.text = name!;
    }

    _nameInputController.addListener(() {
      setState(() {
        name = _nameInputController.text;
      });
    });

    supabase.from("profiles").select("""
        id,
        group_members (
          groups (
            id,
            group_name
          )
        )
      """).eq("id", widget.profile.id).then((res) {
          setState(() {
            groups = <Map<String, dynamic>>[...res.first["group_members"]]
                .map((e) => <Map<String, dynamic>>[e["groups"]]
                    .map((g) => CEventGroup(g["id"], g["group_name"]))
                    .toList())
                .fold(<CEventGroup>[], (acc, e) => [...acc, ...e]).fold(
                    <CEventGroup>[], (acc, e) => [...acc, e]).toList();
          });
        });

    super.initState();
  }

  @override
  void dispose() {
    _nameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CTextInput(hintText: "Event Name", controller: _nameInputController),
        const SizedBox(height: 20),
        CText.subtitle("Date"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CText.label(DateFormat("EEEE, d MMM `yy").format(date)),
            FloatingActionButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                ).then(
                  (value) => setState(
                    () {
                      date = value!;
                    },
                  ),
                );
              },
              backgroundColor: CColors.interactive,
              shape: const CircleBorder(),
              mini: true,
              child: const Icon(
                Icons.edit,
                color: CColors.white,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        // ListView( primary: true, shrinkWrap: true, children: [
        //     Wrap(
        //       alignment: WrapAlignment.center, spacing: 3, runSpacing: 3,
        //       children: images.map((e) => Image.network(e, width: 100, height: 100 )).toList())]),
        CText.subtitle("Group"),
        // Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CText.label(group?.name ?? "Select a group...",
                color: group == null ? CColors.faded : CColors.white),
            CPopupMenu<CEventGroup>(
              items: groups
                  .map(
                    (e) => PopupMenuItem<CEventGroup>(
                      child: Text(e.name),
                      value: e,
                    ),
                  )
                  .toList(),
              onSelected: (selectedGroup) {
                setState(
                  () {
                    group = selectedGroup;
                  },
                );
              },
            ),
          ],
        ),
        Spacer(),
        FloatingActionButton(
          onPressed: () {
            if (name == null || group == null || name!.isEmpty) return;
            final futureP = widget.initial == null
                ? supabase.from("events").insert({
                    "name": name,
                    "group_id": group!.id,
                    "occurs_at": date.toIso8601String(),
                  }).select("id")
                : supabase.from('events').update({
                    "name": name,
                    "group_id": group!.id,
                    "occurs_at": date.toIso8601String(),
                  }).eq("id", widget.initial!.id);
            futureP.then((value) {
              widget.onSubmit(CEvent(
                  id: value?.first?["id"],
                  name: name!,
                  date: date,
                  group: group!));
              Navigator.pop(context);
            });
          },
          backgroundColor: CColors.primary,
          child: CText.button(widget.initial == null ? "Create" : "Update"),
        ),
        widget.initial != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                    onPressed: () {
                      supabase
                          .from("events")
                          .delete()
                          .eq("id", widget.initial!.id)
                          .then((value) {
                        widget.onSubmit(CEvent(
                            id: null, name: name!, date: date, group: group!));
                        Navigator.pop(context);
                      });
                    },
                    backgroundColor: CColors.onSurface,
                    child: CText.button("Delete")),
              )
            : Text(""),
      ],
    );
  }
}
