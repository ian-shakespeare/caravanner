import 'package:caravanner/components/list.dart';
import 'package:caravanner/theme/colors.dart';
import 'package:flutter/material.dart';

class Profile {
  String uid;
  int userId;
  String avatarUrl;
  String firstName;
  String lastName;
  String handle;
  String bio;

  Profile({
    required this.uid,
    required this.userId,
    required this.avatarUrl,
    required this.firstName,
    required this.lastName,
    required this.handle,
    required this.bio,
  });
}

List<Profile> peopleList = [
  Profile(
    uid: '1',
    userId: 101,
    avatarUrl: 'https://avatars.githubusercontent.com/u/31287009?s=400&u=d88723a7721a72d70aa732b9c499cc3ecc39f3c7&v=4',
    firstName: 'John',
    lastName: 'Doe',
    handle: 'john_doe',
    bio: 'Flutter Developer',
  ),
  Profile(
    uid: '2',
    userId: 102,
    avatarUrl: 'https://avatars.githubusercontent.com/u/31287009?s=400&u=d88723a7721a72d70aa732b9c499cc3ecc39f3c7&v=4',
    firstName: 'Jane',
    lastName: 'Doe',
    handle: 'jane_doe',
    bio: 'Mobile App Developer',
  )
];

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final List<CListTile> profs = peopleList.map((e) => CListTile(label: '${e.firstName} ${e.lastName}',
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
      )
  )).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
        backgroundColor: CColors.primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: CList(items: profs),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //
        //     // for ( var people in peopleList ) {
        //     //   CircleAvatar(
        //     //     radius: 50.0,
        //     //     backgroundImage: AssetImage('images/profile.jpeg'),
        //     //   ),
        //     //   SizedBox(height: 16.0),
        //     //   Text(
        //     //     '@jeb_',
        //     //     style: TextStyle(
        //     //       fontSize: 24.0,
        //     //       color: Colors.white,
        //     //     ),
        //     //   ),
        //     //   SizedBox(height: 8.0),
        //     //   Text(
        //     //     'I love the office',
        //     //     style: TextStyle(
        //     //       fontSize: 16.0,
        //     //       color: Colors.grey,
        //     //     ),
        //     //   ),
        //     // }
        //   ],
        // ),
      ),
    );
  }
}
