import "package:flutter/material.dart";
import "../components/screen.dart";

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext ctx) {
    return Screen(
        headerCenter: const Text("Home"),
        body: Center(
          child: Column(
            children: <Widget>[
              const Text("Home page!"),
            ],
          ),
        ));
  }
}
