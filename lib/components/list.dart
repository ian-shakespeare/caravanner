import 'package:caravanner/theme/colors.dart';
import 'package:caravanner/theme/text.dart';
import 'package:flutter/material.dart';

class CListTile extends StatelessWidget {
  const CListTile({
    super.key,
    required this.label,
    this.sublabel,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final Widget? leading;
  final Widget? trailing;
  final String label;
  final String? sublabel;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap ?? () {},
        child: ListTile(
          leading: leading,
          trailing: trailing,
          title: CText.label(label),
          subtitle: sublabel == null ? null : CText.sublabel(sublabel!),
        ));
  }
}

class CList extends StatelessWidget {
  final String? label;
  final bool borders;
  final List<CListTile> items;

  const CList({
    super.key,
    required this.items,
    this.label,
    this.borders = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null && label!.isNotEmpty)
          CText.superlabel(label!, textAlign: TextAlign.left),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            prototypeItem: items.first,
            itemBuilder: (context, index) {
              return borders == false
                  ? items[index]
                  : Container(
                      decoration: BoxDecoration(
                          border: borders
                              ? Border(bottom: BorderSide(color: CColors.faded))
                              : Border.all()),
                      child: items[index],
                    );
            },
          ),
        ),
      ],
    );
  }
}
