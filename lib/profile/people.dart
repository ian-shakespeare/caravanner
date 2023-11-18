import 'dart:async';

import 'package:caravanner/auth/profile_model.dart';
import 'package:caravanner/components/list.dart';
import 'package:caravanner/components/screen.dart';
import 'package:caravanner/profile/profile.dart';
import 'package:caravanner/theme/colors.dart';
import 'package:caravanner/theme/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:supabase_flutter/supabase_flutter.dart";

class People {
  String user_id;
  String first_name;
  String last_name;
  String handle;
  String bio;

  People({
    required this.user_id,
    required this.first_name,
    required this.last_name,
    required this.handle,
    required this.bio,
  });
}

List<People> peopleList = [
  People(
    user_id: '1',
    first_name: 'John',
    last_name: 'Doe',
    handle: 'john_doe',
    bio: 'Flutter Developer',
  ),
  People(
    user_id: '2',
    first_name: 'Jane',
    last_name: 'Doe',
    handle: 'jane_doe',
    bio: 'Mobile App Developer',
  )
];

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext _) {
    return Consumer<ProfileModel>(
        builder: (_, profile, __) => _PeopleScreen(profile: profile));
  }
}

class _PeopleScreen extends StatefulWidget {
  _PeopleScreen({required this.profile});

  final ProfileModel profile;

  @override
  State<_PeopleScreen> createState() => _PeopleScreenState();
}

// class _MessageScreenState extends State<_MessageScreen> {
class _PeopleScreenState extends State<_PeopleScreen> {
  final supabase = Supabase.instance.client;
  late final PostgrestTransformBuilder<dynamic> _futureData;

  @override
  void initState() {
    _futureData = supabase.from("profiles").select("""
      id,
      first_name,
      last_name,
      handle
    """);
    super.initState();
  }

  final List<CListTile> profs = peopleList
      .map((e) => CListTile(
          label: '${e.first_name} ${e.last_name}',
          sublabel: e.handle,
          trailing: const Icon(Icons.arrow_forward_ios),
          leading: ClipOval(
            child: SizedBox.fromSize(
              size: const Size.fromRadius(30),
              child: Image.network(
                'https://avatars.githubusercontent.com/u/31287009?s=400&u=d88723a7721a72d70aa732b9c499cc3ecc39f3c7&v=4',
                fit: BoxFit.cover,
              ),
            ),
          )))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Screen(
      headerCenter: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: CText.subheading("People"),
      ),
      body: FutureBuilder<dynamic>(
        future: _futureData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final profiles = snapshot.data!;
          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: ((context, index) {
              final profile = profiles[index];
              return ListTile(
                title: CText.title(
                  "${profile["first_name"][0].toUpperCase()}${profile["first_name"].substring(1)} ${profile["last_name"][0].toUpperCase()}${profile["last_name"].substring(1)}",
                  color: CColors.white,
                ),
                subtitle:
                    CText.subtitle(profile['handle'], color: CColors.white),
                leading: const CircleAvatar(
                  child: Icon(Icons.person, color: Colors.white),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: CColors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(profile: profile),
                    ),
                  );
                },
              );
            }),
          );
        }),
    );
  }
}
