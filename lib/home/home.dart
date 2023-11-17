import "package:flutter/material.dart";
import "../theme/text.dart";
import "../components/bottom_modal.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Center(
      child: Column(
        children: <Widget>[
          CText.paragraph("Home page!"),
          ElevatedButton(
            child: const Text("Show Modal"),
            onPressed: () {
              showModalBottomSheet(
                context: ctx,
                builder: (modalCtx) {
                  return BottomModal(
                    child: Column(
                      children: <Widget>[
                        CText.subheading("my modal"),
                      ],
                    ),
                  );
                },
              );
            }
          ),
        ],
      ),
    );
  }
}
