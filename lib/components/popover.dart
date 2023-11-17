import 'package:caravanner/theme/colors.dart';
import 'package:caravanner/theme/text.dart';
import "package:flutter/material.dart";
import 'package:popover/popover.dart';

class CPopoverItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Image image;
  const CPopoverItem(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: image,
        ),
        Column(
          children: [CText.title(title), CText.subtitle(subtitle)],
        )
      ],
    );
  }
}

class CPopoverItems extends StatelessWidget {
  final List<CPopoverItem> items;
  const CPopoverItems({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(child: items[index]);
        });
  }
}

class CPopoverButton extends StatelessWidget {
  const CPopoverButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 60,
      decoration: BoxDecoration(
        color: CColors.onSurface,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: GestureDetector(
        child: Center(child: CText.label('Click This!')),
        onTap: () {
          showPopover(
            context: context,
            bodyBuilder: (context) => CPopoverItems(items: [
              CPopoverItem(
                  title: "title",
                  subtitle: "subtitle",
                  image: Image.network(
                    'https://cdn4.iconfinder.com/data/icons/picons-social/57/38-instagram-2-512.png',
                    width: 80,
                    height: 80,
                  )),
            ]),
            direction: PopoverDirection.bottom,
            width: 240,
            height: 280,
            arrowHeight: 5,
            arrowWidth: 0,
            backgroundColor: CColors.onSurface,
          );
        },
      ),
    );
  }
}
