import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> profile;

  DetailScreen({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile['first_name']),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${profile['first_name']} ${profile['last_name']}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '${profile['handle']}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '${profile['bio']}',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class YourWidget extends StatelessWidget {
  final List<Map<String, dynamic>>
      profiles; // Assume this is passed to your widget

  YourWidget({required this.profiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile List'),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return ListTile(
            title: Text(profile['first_name'] + ' ' + profile['last_name']),
            subtitle: Text(profile['handle']),
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(profile: profile),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
