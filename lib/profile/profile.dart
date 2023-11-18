import 'package:caravanner/auth/profile_model.dart';
import 'package:caravanner/components/screen.dart';
import 'package:caravanner/theme/colors.dart';
import 'package:caravanner/theme/text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({super.key, required this.profile});

  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext ctx) {
    return Consumer<ProfileModel>(
        builder: (_, myProfile, __) =>
            _DetailScreen(profile: profile, myProfile: myProfile));
  }
}

class _DetailScreen extends StatefulWidget {
  const _DetailScreen({required this.profile, required this.myProfile});

  final Map<String, dynamic> profile;
  final ProfileModel myProfile;

  @override
  State<_DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<_DetailScreen> {
  final supabase = Supabase.instance.client;
  late final Future isFriend;

  @override
  void initState() {
    isFriend = supabase
        .from("friendships")
        .select()
        .or("befriender_id.eq.${widget.profile["id"]},befriendee_id.eq.${widget.profile["id"]}")
        .or("befriender_id.eq.${widget.myProfile.id},befriendee_id.eq.${widget.myProfile.id}")
        .then((res) => res.isNotEmpty);
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    final name =
        "${widget.profile["first_name"][0].toUpperCase()}${widget.profile["first_name"].substring(1)} ${widget.profile["last_name"][0].toUpperCase()}${widget.profile["last_name"].substring(1)}";
    final navigator = Navigator.of(ctx);
    return FutureBuilder(
      future: isFriend,
      builder: (futureCtx, snapshot) => Screen(
        headerCenter: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: CText.subheading(name, textAlign: TextAlign.center),
        ),
        headerLeft: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              size: 32, color: CColors.white),
          onPressed: () {
            navigator.pop();
          },
        ),
        headerRight: IconButton(
          icon: const Icon(Icons.more_vert_rounded,
              size: 32, color: CColors.white),
          onPressed: () {
            navigator.pop();
          },
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50.0,
                child: Icon(
                  Icons.person,
                  size: 60.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              CText.subheading(
                '${widget.profile['handle']}',
              ),
              if (snapshot.hasData && !snapshot.data)
                TextButton(
                  onPressed: () {
                    supabase.from("friendships").insert({
                      "befriender_id": widget.myProfile.id,
                      "befriendee_id": widget.profile["id"]
                    }).then((_) => supabase.from("direct_messages").insert({
                          "sender_id": widget.myProfile.id,
                          "recipient_id": widget.profile["id"],
                          "message_body": "Hey there! I added you as a friend."
                        }));
                  },
                  child: CText.button('Add Friend', color: CColors.interactive),
                )
            ],
          ),
        ),
      ),
    );
  }
}
